local function on_save()
	vim.cmd("wa")
	-- Get the filetype of the current buffer
	local ft = vim.bo.filetype
	-- Check filetype and perform actions accordingly
	if
		ft == "html"
		or ft == "css"
		or ft == "javascript"
		or ft == "typescript"
		or ft == "javascriptreact"
		or ft == "typescriptreact"
	then
		vim.cmd("silent !prettier --write " .. vim.fn.expand("%"))
	elseif ft == "json" then
		vim.cmd("silent %!jq .")
	elseif ft == "lua" then
		vim.cmd("silent !stylua " .. vim.fn.expand("%"))
	elseif ft == "cs" then
		vim.cmd("silent !csharpier format " .. vim.fn.expand("%"))
	end
end

-- Register the function as a user command (make it callable with :OnSave)
vim.api.nvim_create_user_command("OnSave", on_save, {})
