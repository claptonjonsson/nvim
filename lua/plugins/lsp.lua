return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- Pure native LSP startup using vim.lsp.start
			-- No lsp-zero. No require('lspconfig').SERVER indexing.

			local function safe_require(mod)
				local ok, m = pcall(require, mod)
				return ok and m or nil
			end

			-- Ensure nvim-lspconfig is on runtimepath (safe; deprecation triggers only when indexing its framework)
			pcall(require, "lspconfig")

			-- Utilities (safe submodule)
			local util = safe_require("lspconfig.util")

			-- Buffer-local keymaps
			local function on_attach(_, bufnr)
				local opts = { buffer = bufnr }
				vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gf", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
				vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			end

			-- Capabilities (nvim-cmp integration if present)
			local capabilities = (function()
				local cmp_nvim_lsp = safe_require("cmp_nvim_lsp")
				if cmp_nvim_lsp and type(cmp_nvim_lsp.default_capabilities) == "function" then
					return cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
				end
				return vim.lsp.protocol.make_client_capabilities()
			end)()

			-- Helpers to probe commands
			local fs = vim.uv or vim.loop

			local function is_exec(cmd)
				return vim.fn.executable(cmd) == 1
			end

			local function path_exists(p)
				return p and fs.fs_stat and fs.fs_stat(p) ~= nil
			end

			local function find_first_exec(candidates)
				-- candidates: array of strings or arrays {cmd, arg1, ...}
				for _, c in ipairs(candidates) do
					if type(c) == "string" then
						if is_exec(c) then
							return { c }
						end
					elseif type(c) == "table" and #c > 0 then
						local main = c[1]
						if main == "dotnet" then
							-- dotnet requires next arg to exist
							local dll = c[2]
							if is_exec("dotnet") and path_exists(dll) then
								return c
							end
						elseif is_exec(main) then
							return c
						end
					end
				end
				return nil
			end

			-- Deduplicate by root_dir with modern API
			local function attach_or_start(final, bufnr)
				for _, client in ipairs(vim.lsp.get_clients({ name = final.name })) do
					if client.config and client.config.root_dir == final.root_dir then
						vim.lsp.buf_attach_client(bufnr, client.id)
						return
					end
				end
				vim.lsp.start(final)
			end

			-- Generic starter per filetype set
			local notified_missing = {} -- avoid spamming "not started" messages
			local function autostart_lsp(def)
				-- def: { name, cmd_candidates, filetypes, root_dir = fn, settings, init_options }
				local cmd = def.cmd_candidates and find_first_exec(def.cmd_candidates) or def.cmd
				if not cmd then
					if not notified_missing[def.name] then
						notified_missing[def.name] = true
						vim.schedule(function()
							vim.notify(
								("LSP '%s' not started: no command found on PATH"):format(def.name),
								vim.log.levels.WARN
							)
						end)
					end
					return
				end

				local aug = vim.api.nvim_create_augroup("lsp-start-" .. def.name, { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = aug,
					pattern = def.filetypes,
					callback = function(args)
						local buf = args.buf
						local fname = vim.api.nvim_buf_get_name(buf)
						local root_dir = def.root_dir and def.root_dir(fname) or vim.fn.getcwd()

						-- Support dynamic command generation via cmd_fn
						local final_cmd = cmd
						if def.cmd_fn and type(def.cmd_fn) == "function" then
							final_cmd = def.cmd_fn(root_dir)
						end

						local final = {
							name = def.name,
							cmd = final_cmd,
							root_dir = root_dir,
							filetypes = def.filetypes,
							on_attach = on_attach,
							capabilities = capabilities,
							settings = def.settings,
							init_options = def.init_options,
						}

						attach_or_start(final, buf)
					end,
					desc = "Start " .. def.name .. " LSP",
				})
			end

			-- Root patterns
			local function root_pattern(...)
				if util and util.root_pattern then
					local f = util.root_pattern(...)
					return function(fname)
						return f and f(fname) or vim.fn.getcwd()
					end
				end
				return function()
					return vim.fn.getcwd()
				end
			end

			-- Servers (native startup)
			local servers = {
				-- C# (OmniSharp)
				{
					name = "omnisharp",
					-- Prefer omnisharp -lsp if available; else dotnet + OmniSharp.dll
					cmd_candidates = {
						{ "omnisharp", "-lsp" },
						{ "dotnet", "/usr/lib/omnisharp-roslyn/OmniSharp.dll" },
						{ "dotnet", "/usr/share/omnisharp-roslyn/OmniSharp.dll" },
						{ "dotnet", "/usr/local/lib/omnisharp-roslyn/OmniSharp.dll" },
					},
					filetypes = { "cs" }, -- add "vb" if you need VB.NET
					root_dir = root_pattern("*.sln", "*.csproj", ".git"),
					settings = {
						FormattingOptions = { EnableEditorConfigSupport = true, OrganizeImports = nil },
						MsBuild = { LoadProjectsOnDemand = nil },
						RoslynExtensionsOptions = {
							EnableAnalyzersSupport = true,
							EnableImportCompletion = true,
							AnalyzeOpenDocumentsOnly = nil,
						},
						Sdk = { IncludePrereleases = true },
					},
				},

				-- Lua
				{
					name = "lua_ls",
					cmd_candidates = { "lua-language-server" },
					filetypes = { "lua" },
					root_dir = root_pattern(".luarc.json", ".luarc.jsonc", ".git"),
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
						},
					},
				},

				-- TypeScript/JavaScript
				{
					name = "tsserver",
					cmd_candidates = { { "typescript-language-server", "--stdio" } },
					filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
					root_dir = root_pattern("package.json", "tsconfig.json", ".git"),
				},

				-- CSS
				{
					name = "cssls",
					cmd_candidates = { { "vscode-css-language-server", "--stdio" } },
					filetypes = { "css", "scss", "less" },
					root_dir = root_pattern("package.json", ".git"),
				},

				-- HTML
				{
					name = "html",
					cmd_candidates = { { "vscode-html-language-server", "--stdio" } },
					filetypes = { "html" },
					root_dir = root_pattern(".git"),
				},

				-- Emmet
				{
					name = "emmet_ls",
					cmd_candidates = {
						{ "emmet-ls", "--stdio" },
						{ "emmet-language-server", "--stdio" },
					},
					filetypes = { "html", "css", "javascript", "javascriptreact", "typescriptreact" },
					root_dir = root_pattern(".git"),
				},

				-- Tailwind
				{
					name = "tailwindcss",
					cmd_candidates = { { "tailwindcss-language-server", "--stdio" } },
					filetypes = { "html", "css", "javascript", "javascriptreact", "typescriptreact", "svelte" },
					root_dir = root_pattern("tailwind.config.js", "tailwind.config.cjs", "package.json", ".git"),
				},

			-- Python (Pyright)
			{
				name = "pyright",
				cmd_candidates = { { "pyright-langserver", "--stdio" } },
				filetypes = { "python" },
				root_dir = root_pattern(
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					"pyrightconfig.json",
					".git"
				),
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
						},
					},
				},
			},

			-- Angular (dynamic probe locations per project)
			{
				name = "angularls",
				cmd_candidates = { "ngserver" },
				cmd_fn = function(root_dir)
					-- Find the nearest node_modules directory from project root
					local node_modules_dir = nil
					local search_path = root_dir

					while search_path and search_path ~= "/" do
						local candidate = search_path .. "/node_modules"
						local stat = fs.fs_stat(candidate)
						if stat and stat.type == "directory" then
							node_modules_dir = candidate
							break
						end
						search_path = vim.fn.fnamemodify(search_path, ":h")
					end

					if node_modules_dir then
						return {
							"ngserver",
							"--stdio",
							"--tsProbeLocations", node_modules_dir,
							"--ngProbeLocations", node_modules_dir
						}
					else
						-- Fallback if no node_modules found
						vim.notify(
							"Angular LS: Could not find node_modules. Make sure dependencies are installed.",
							vim.log.levels.WARN
						)
						return { "ngserver", "--stdio" }
					end
				end,
				filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
				root_dir = root_pattern("angular.json"),
			},
		}

			for _, def in ipairs(servers) do
				autostart_lsp(def)
			end

			-- nvim-cmp setup (leave as-is if you already configure elsewhere)
			local cmp = safe_require("cmp")
			if cmp then
				cmp.setup({
					sources = { { name = "nvim_lsp" } },
					snippet = {
						expand = function(args)
							if type(vim.fn["vsnip#anonymous"]) == "function" then
								vim.fn["vsnip#anonymous"](args.body)
							elseif vim.snippet and type(vim.snippet.expand) == "function" then
								vim.snippet.expand(args.body)
							end
						end,
					},
					mapping = cmp.mapping.preset.insert({}),
				})
			end
		end,
	},
}
