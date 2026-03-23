return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		dependencies = {
			{
				"copilotlsp-nvim/copilot-lsp",
			},
		},
		opts = {
			panel = {
				enabled = true,
				auto_refresh = false,
				keymap = {
					jump_prev = "<C-p>",
					jump_next = "<C-n>",
					accept = "<CR>",
					refresh = "cr",
					open = false,
				},
				layout = {
					position = "bottom",
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = true,
				debounce = 15,
				trigger_on_accept = true,
				keymap = {
					accept = "<Tab>",
					accept_word = "<S-Tab>",
					accept_line = "<A-S-Tab>",
				},
			},
			nes = {
				enabled = true,
				auto_trigger = true,
			},
		},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
	},
	{
		"folke/sidekick.nvim",
		lazy = false,
		keys = (function()
			local function copilot_nes_jump_or_apply()
				local nes = require("copilot.nes.api")
				if not nes.nes_walk_cursor_start_edit() then
					nes.nes_apply_pending_nes()
				end
			end

			return {
			{
				"<c-.>",
				function()
					require("sidekick.cli").toggle()
				end,
				mode = { "n", "t", "i", "x" },
				desc = "Sidekick Toggle",
			},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>as",
				function()
					require("sidekick.cli").select()
				end,
				desc = "Sidekick Select CLI",
			},
			{
				"<leader>ad",
				function()
					require("sidekick.cli").close()
				end,
				desc = "Sidekick Detach CLI Session",
			},
			{
				"<leader>at",
				function()
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Sidekick Send This",
			},
			{
				"<leader>af",
				function()
					require("sidekick.cli").send({ msg = "{file}" })
				end,
				desc = "Sidekick Send File",
			},
			{
				"<leader>av",
				function()
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = { "x" },
				desc = "Sidekick Send Visual Selection",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			{
				"<leader>an",
				copilot_nes_jump_or_apply,
				desc = "Copilot NES Jump/Apply",
			},
			{
				"<A-Tab>",
				copilot_nes_jump_or_apply,
				mode = { "n", "i", "v" },
				desc = "Copilot NES Jump/Apply (Alt+Tab)",
			},
			}
		end)(),
		opts = {},
	},
}
