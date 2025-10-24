---
-- LSP configuration (native nvim-lspconfig, avoiding deprecated framework access)
---
-- on_attach: keymaps and buffer-local setup
local on_attach = function(client, bufnr)
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

-- capabilities: use cmp_nvim_lsp if available
local capabilities = (function()
	local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if ok_cmp and type(cmp_nvim_lsp.default_capabilities) == "function" then
		return cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
	end
	return vim.lsp.protocol.make_client_capabilities()
end)()

-- Helper that prefers the modern API vim.lsp.config.setup_server
local function setup_server(server_name, opts)
	opts = opts or {}
	opts.on_attach = opts.on_attach or on_attach
	opts.capabilities = opts.capabilities or capabilities

	if type(vim.lsp.config.setup_server) == "function" then
		local ok, err = pcall(function()
			vim.lsp.config.setup_server(server_name, opts)
		end)
		if not ok then
			vim.notify(
				"vim.lsp.config.setup_server failed for " .. server_name .. ": " .. tostring(err),
				vim.log.levels.WARN
			)
		end
	else
		-- Extremely old lspconfig: fall back but warn about deprecation
		local ok, lspconfig = pcall(require, "lspconfig")
		if ok and type(lspconfig) == "table" then
			local srv = lspconfig[server_name]
			if srv and type(srv.setup) == "function" then
				local ok2, err2 = pcall(function()
					srv.setup(opts)
				end)
				if not ok2 then
					vim.notify("lspconfig." .. server_name .. ".setup failed: " .. tostring(err2), vim.log.levels.WARN)
				else
					vim.notify(
						"Warning: used deprecated lspconfig framework access for " .. server_name,
						vim.log.levels.WARN
					)
				end
			else
				vim.notify("No setup available for LSP server: " .. server_name, vim.log.levels.WARN)
			end
		else
			vim.notify("nvim-lspconfig not installed; cannot setup " .. server_name, vim.log.levels.WARN)
		end
	end
end

-- ---------- Servers ----------
-- OMNISHARP
setup_server("omnisharp", {
	cmd = { "dotnet", "/usr/lib/omnisharp-roslyn/OmniSharp.dll" },
	settings = {
		FormattingOptions = {
			EnableEditorConfigSupport = true,
			OrganizeImports = nil,
		},
		MsBuild = { LoadProjectsOnDemand = nil },
		RoslynExtensionsOptions = {
			EnableAnalyzersSupport = true,
			EnableImportCompletion = true,
			AnalyzeOpenDocumentsOnly = nil,
		},
		Sdk = { IncludePrereleases = true },
	},
})

-- CSS
setup_server("cssls", {
	capabilities = capabilities,
})

-- HTML
setup_server("html", {
	capabilities = capabilities,
})

-- LUA
setup_server("lua_ls", {
	on_init = function(client)
		local path = client.workspace_folders and client.workspace_folders[1] and client.workspace_folders[1].name or ""
		if path ~= "" and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc")) then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
		})
	end,
	settings = { Lua = {} },
})

-- EMMET
setup_server("emmet_language_server", {
	filetypes = { "css", "html", "javascript" },
})

-- TAILWIND CSS
setup_server("tailwindcss", {})

-- TypeScript Language Server
setup_server("ts_ls", {})

-- Python (Pyright)
setup_server("pyright", {
	on_attach = function(client, bufnr)
		-- server-specific on_attach
	end,
	filetypes = { "python" },
	root_dir = require("lspconfig.util").root_pattern(
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json"
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
})

-- ---------- Completion ----------
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
	cmp.setup({
		sources = { { name = "nvim_lsp" } },
		snippet = {
			expand = function(args)
				-- adjust to your snippet plugin if needed
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
