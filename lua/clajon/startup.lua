local M = {}

function M.setup()
	-- Schedule this to run after VimEnter to ensure everything is loaded
	vim.schedule(function()
		-- Only run if we started with no arguments (just `nvim`)
		if vim.fn.argc() == 0 then
			-- Create second tab for GitHub Copilot CLI
			vim.cmd("tabnew")
			vim.cmd("terminal copilot")

			-- Create third tab for regular terminal
			vim.cmd("tabnew")
			vim.cmd("terminal")

			-- Return to first tab (main editor window)
			vim.cmd("tabnext 1")
		end
	end)
end

return M
