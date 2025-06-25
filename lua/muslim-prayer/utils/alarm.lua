local config = require("muslim-prayer.setup").config
local hadiths = require("muslim-prayer.data.hadiths")
local i18n = require("muslim-prayer.data.i18n")

local M = {}

local last_alarm_prayer = nil

-- Convert "HH:MM" to total minutes
local function to_minutes(time_str)
  local hour, min = time_str:match("(%d+):(%d+)")
  return tonumber(hour) * 60 + tonumber(min)
end

-- Show notification
local function on_notify(prayer, time)
  local notify = require("muslim-prayer.utils.notify")
  local lang = config.lang or "en"
  local L = i18n.get(lang)
  local hadith = hadiths.get_random(lang)

  notify.notify({
    L.upcoming_prayer,
    "",
    string.format("%s %s %s", prayer, L.at, time),
    "",
    L.hadith_title,
    hadith,
  })
end

-- Check upcoming prayer
function M.check_and_show_alarm(next)
  local schedules = require("muslim-prayer.utils.schedules")

  schedules(function(today_schedule)
    if not today_schedule then return end

    local now = os.date("*t")
    local now_minutes = now.hour * 60 + now.min

    if next == true then
      local arr = {}
      for prayer, time in pairs(today_schedule) do
        local time_only = time:match("^(%d+:%d+)")
        local hour, min = time_only:match("(%d+):(%d+)")

        table.insert(arr, {
          prayer = prayer,
          time = time_only,
          minutes = tonumber(hour) * 60 + tonumber(min)
        })
      end

      table.sort(arr, function(a, b)
        return a.minutes < b.minutes
      end)

      local time_now = os.date("*t")
      local time_now_minutes = time_now.hour * 60 + time_now.min

      for _, entry in ipairs(arr) do
        if entry.minutes >= time_now_minutes then
          on_notify(entry.prayer, entry.time)
          break
        end
      end
    else
      for prayer, time_str in pairs(today_schedule) do
        local time_only = time_str:match("^(%d+:%d+)")
        local prayer_minutes = to_minutes(time_only)

        local diff = prayer_minutes - now_minutes
        if diff <= 30 and diff >= 0 then
          if last_alarm_prayer ~= prayer then
            last_alarm_prayer = prayer
            on_notify(prayer, time_only)
          end
          break
        end
      end
    end
  end)
end

-- Schedule to run every 30s
function M.start_alarm()
  local function loop()
    M.check_and_show_alarm()
    vim.defer_fn(loop, 30000)
  end
  loop()
end

return M
