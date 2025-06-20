local M = {}

M.schedules = require("muslim-prayer.views.schedules")


function M.init(opts)
  local arg = opts.args
  if arg == '' or arg == 'schedule' then
    M.schedules.openSchedule()
  end
end

vim.api.nvim_create_user_command("Prayer", M.init, {
  nargs = "?",
  desc = "Open Muslim Prayer"
})

return M
