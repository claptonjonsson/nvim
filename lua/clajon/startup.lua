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

			--Create a fifth tab for Harlequin
			if vim.fn.filereadable("wrangler.jsonc") == 1 then
				vim.cmd("tabnew")
				vim.cmd(
					'terminal bash -c \'cd .wrangler/state/v3/d1/miniflare-D1DatabaseObject/ && f=$(ls *.sqlite | head -n1) && [ -n "$f" ] && harlequin -t nord "$f" || echo "No .sqlite file found"\''
				)
			end

			-- Return to first tab (main editor window)
			vim.cmd("tabnext 1")
		end
	end)
end

return M
