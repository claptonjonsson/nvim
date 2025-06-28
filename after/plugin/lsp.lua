---
-- LSP configuration
---
local lsp_zero = require("lsp-zero")
local lsp_attach = function(client, bufnr)
	local opts = { buffer = bufnr }

	vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
	vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
	vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<cr>", opts) --Added myself, not standard LSP binding
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
	vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
	vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
	vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
	vim.keymap.set("n", "gR", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
	vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
end

lsp_zero.extend_lspconfig({
	sign_text = true,
	lsp_attach = lsp_attach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- These are just examples. Replace them with the language
-- servers you have installed in your system

--C#


--OMNISHARP
require("lspconfig").omnisharp.setup({
	cmd = { "dotnet", "/usr/lib/omnisharp-roslyn/OmniSharp.dll" },

	settings = {
		FormattingOptions = {
			-- Enables support for reading code style, naming convention and analyzer
			-- settings from .editorconfig.
			EnableEditorConfigSupport = true,
			-- Specifies whether 'using' directives should be grouped and sorted during
			-- document formatting.
			OrganizeImports = nil,
		},
		MsBuild = {
			-- If true, MSBuild project system will only load projects for files that
			-- were opened in the editor. This setting is useful for big C# codebases
			-- and allows for faster initialization of code navigation features only
			-- for projects that are relevant to code that is being edited. With this
			-- setting enabled OmniSharp may load fewer projects and may thus display
			-- incomplete reference lists for symbols.
			LoadProjectsOnDemand = nil,
		},
		RoslynExtensionsOptions = {
			-- Enables support for roslyn analyzers, code fixes and rulesets.
			EnableAnalyzersSupport = true,
			-- Enables support for showing unimported types and unimported extension
			-- methods in completion lists. When committed, the appropriate using
			-- directive will be added at the top of the current file. This option can
			-- have a negative impact on initial completion responsiveness,
			-- particularly for the first few completion sessions after opening a
			-- solution.
			EnableImportCompletion = true,
			-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
			-- true
			AnalyzeOpenDocumentsOnly = nil,
		},
		Sdk = {
			-- Specifies whether to include preview versions of the .NET SDK when
			-- determining which version to use for project loading.
			IncludePrereleases = true,
		},
	},
})

--CSS
require("lspconfig").cssls.setup({
	capabilities = capabilities,
})

--HTML
require("lspconfig").html.setup({
	capabilities = capabilities,
})

--HTMX
--require('lspconfig').htmx.setup({})

--LUA
require("lspconfig").lua_ls.setup({
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				},
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			},
		})
	end,
	settings = {
		Lua = {},
	},
})

--EMMET
require("lspconfig").emmet_language_server.setup({
	filetypes = { "css", "html", "javascript" },
})

--TAILWIND CSS
require("lspconfig").tailwindcss.setup({})

--TypeScript Language Server
require("lspconfig").ts_ls.setup({})

--Python Language Server (Pyright)
require('lspconfig').pyright.setup{
  on_attach = function(client, bufnr)
    -- Keymaps and other on_attach logic can go here
  end,
  filetypes = { "python" },
  root_dir = require('lspconfig').util.root_pattern(
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
}

---
-- Autocompletion setup
---
local cmp = require("cmp")

cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
	},
	snippet = {
		expand = function(args)
			-- You need Neovim v0.10 to use vim.snippet
			vim.snippet.expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({}),
})
