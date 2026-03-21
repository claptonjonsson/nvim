local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local M = {}

local function tab_label(tabpage)
	local tabnr = vim.api.nvim_tabpage_get_number(tabpage)
	local win = vim.api.nvim_tabpage_get_win(tabpage)
	local bufnr = vim.api.nvim_win_get_buf(win)
	local name = vim.api.nvim_buf_get_name(bufnr)

	if name == "" then
		name = "[No Name]"
	else
		name = vim.fn.fnamemodify(name, ":~:.")
	end

	return string.format("%d: %s", tabnr, name)
end

local function tab_entries()
	local entries = {}

	for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		table.insert(entries, {
			tabnr = vim.api.nvim_tabpage_get_number(tabpage),
			display = tab_label(tabpage),
			ordinal = tab_label(tabpage),
		})
	end

	return entries
end

function M.open()
	pickers.new({}, {
		prompt_title = "Tabs",
		finder = finders.new_table({
			results = tab_entries(),
			entry_maker = function(entry)
				return {
					value = entry.tabnr,
					display = entry.display,
					ordinal = entry.ordinal,
				}
			end,
		}),
		sorter = conf.generic_sorter({}),
		previewer = false,
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)

				if selection and selection.value then
					vim.cmd("tabnext " .. selection.value)
				end
			end)

			local function delete_tab()
				local selection = action_state.get_selected_entry()

				if not selection or not selection.value then
					return
				end

				if #vim.api.nvim_list_tabpages() <= 1 then
					vim.notify("Cannot close the last tab", vim.log.levels.INFO)
					return
				end

				actions.close(prompt_bufnr)

				vim.schedule(function()
					vim.cmd("tabclose " .. selection.value)
					M.open()
				end)
			end

			map("i", "D", delete_tab)
			map("n", "D", delete_tab)

			return true
		end,
	}):find()
end

return M
