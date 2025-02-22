--MAKES COPILOT CHAT APPEAR IN FLOATING WINDOW
require("CopilotChat").setup({
  window = {
    layout = 'float',
    relative = 'cursor',
    width = 1,
    height = 0.4,
    row = 1
  }
})
