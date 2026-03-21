local M = {}

local function open_tab(command)
	vim.cmd("tabnew")

	if command then
		vim.cmd(command)
	else
		vim.cmd("terminal")
	end
end

function M.setup()
	vim.keymap.set("n", "<leader>t", function()
		vim.cmd("tabs")
	end, { noremap = true, silent = true, desc = "List open tabs" })

	vim.keymap.set("n", "<leader>tn", function()
		vim.cmd("tabnew")
	end, { noremap = true, silent = true, desc = "Open empty tab" })

	vim.keymap.set("n", "<leader>tt", function()
		open_tab()
	end, { noremap = true, silent = true, desc = "Open terminal tab" })

	vim.keymap.set("n", "<leader>to", function()
		open_tab("terminal opencode")
	end, { noremap = true, silent = true, desc = "Open opencode tab" })

	vim.keymap.set("n", "<leader>tl", function()
		open_tab("terminal lazygit")
	end, { noremap = true, silent = true, desc = "Open lazygit tab" })

	vim.keymap.set("n", "<leader>th", function()
		if vim.fn.filereadable("wrangler.jsonc") == 1 then
			open_tab(
				'terminal bash -c \'cd .wrangler/state/v3/d1/miniflare-D1DatabaseObject/ && f=$(ls *.sqlite | head -n1) && [ -n "$f" ] && harlequin -t nord "$f" || echo "No .sqlite file found"\''
			)
		else
			vim.notify("Harlequin unavailable: wrangler.jsonc not found in this directory", vim.log.levels.INFO)
		end
	end, { noremap = true, silent = true, desc = "Open harlequin tab" })
end

return M
