local M = {}

M.defaultConfig = {
  -- Aladhan setup
  latitude = "1.14937",
  longitude = "104.02491",
  method = "3",
  shafaq = "general",
  timezonestring = "Asia/Jakarta",
  calendarMethod = "UAQ",
  highlight_color = "LightBlue",

  -- Muslim Prayer Setup
  autoLocation = false, -- false or true
  notification_style = "box", -- or "box"

  -- if always resync, then it's getScheduleBy to be 'day'
  getScheduleBy = 'month', -- day, month, year
  alwaysResync = false, -- false or true

  -- language
  lang = 'id',
  notify_before = 30 -- in mins
}

M.config = {}

function M.setup(opts)
  for key, value in pairs(M.defaultConfig) do
    M.config[key] = value
  end

  for key, value in pairs(opts) do
    M.config[key] = value
  end
end

return M
