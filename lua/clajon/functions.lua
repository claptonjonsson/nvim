-- TODO: Make this into a code format file only!
local function handle_filetype()
	-- Get the filetype of the current buffer
	local ft = vim.bo.filetype
	-- Check filetype and perform actions accordingly
	if ft == "html" or ft == "css" or ft == "javascript" then
		vim.cmd("!prettier --write " .. vim.fn.expand("%"))
	elseif ft == "lua" then
		vim.cmd("!stylua " .. vim.fn.expand("%"))
	end
end

-- Register the function as a user command (make it callable with :HandleFiletype)
vim.api.nvim_create_user_command("HandleFiletype", handle_filetype, {})
