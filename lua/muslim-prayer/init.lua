local M = {}

M.schedules = require("muslim-prayer.views.schedules")

local schedule_win = nil

function M.init(opts)
  local arg = opts.args
  if arg == '' or arg == 'schedule' then
    if schedule_win and vim.api.nvim_win_is_valid(schedule_win) then
      vim.api.nvim_win_close(schedule_win, true)
      schedule_win = nil
      return
    end

    M.schedules.openSchedule(function(win_id)
        schedule_win = win_id
      end
    )
  end
end

vim.api.nvim_create_user_command("Prayer", M.init, {
  nargs = "?",
  desc = "Open Muslim Prayer"
})

return M
