-- Create or clear the group first
vim.api.nvim_create_augroup("MuslimPrayerAutoReload", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = "MuslimPrayerAutoReload",
  pattern = "*/muslim_prayer/**/*.lua",
  callback = function()
    -- Clear all related modules
    for name, _ in pairs(package.loaded) do
      if name:match("^hakimajaman%.muslim_prayer") then
        package.loaded[name] = nil
      end
    end

    -- Reload the root module
    pcall(require, "hakimajaman.muslim_prayer")

    vim.notify("✅ Prayer module reloaded", vim.log.levels.INFO, { title = "Reload" })
  end,
})

local M = {}

--M.plugin = require("hakimajaman.muslim_prayer.plugin")
--M.SentNotification = plugin.Notify()
M.schedules = require("hakimajaman.muslim_prayer.views.schedules")

function M.init(opts)
  local arg = opts.args
  if arg == "schedule" then
    M.schedules.openSchedule()
  end
end

vim.api.nvim_create_user_command("MP", M.init, {
  nargs = "?",
  desc = "Open Muslim Prayer"
})

return M
