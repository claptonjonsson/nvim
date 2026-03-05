local M = {}

function M.setup()
	-- Schedule this to run after VimEnter to ensure everything is loaded
	vim.schedule(function()
		-- Only run if we started with no arguments (just `nvim`)
		if vim.fn.argc() == 0 then
			-- Create second tab for GitHub Copilot CLI
			vim.cmd("tabnew")
			vim.cmd("terminal opencode")

			-- Create third tab for regular terminal usage
			vim.cmd("tabnew")
			vim.cmd("terminal")

			--Create a fourth tab for Lazygit
			vim.cmd("tabnew")
			vim.cmd("terminal lazygit")

			-- Return to first tab (main editor window)
			vim.cmd("tabnext 1")
		end
	end)
end

return
