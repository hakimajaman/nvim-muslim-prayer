local config = require("muslim-prayer.setup").config
local box = require("muslim-prayer.views.comp.box")

local M = {}

function M.notify(msg_lines)
  if config.notification_style == "box" then
    local win, _ = box(msg_lines)

    -- Automatically close after 10 seconds
    vim.defer_fn(function()
      if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, 10000) -- 10 seconds
  else
    vim.notify(table.concat(msg_lines, "\n"), vim.log.levels.INFO, { title = "Prayer Reminder" })
  end
end

return M
