local M = {}
--
-- Convert time string (e.g. "04:33") to total minutes
local function to_minutes(time_str)
  local hour, min = time_str:match("(%d+):(%d+)")
  return tonumber(hour) * 60 + tonumber(min)
end

-- Check if it's time to show an alarm
local function check_and_show_alarm(load_schedule, sort_prayers_by_time, last_alarm_prayer)
  local schedule = load_schedule()
  if not schedule then return end

  local now = os.date("*t")
  local now_minutes = now.hour * 60 + now.min

  local sorted = sort_prayers_by_time(schedule)
  for _, entry in ipairs(sorted) do
    local prayer = entry.prayer
    local time_str = entry.time:match("^(%d+:%d+)")
    local prayer_minutes = to_minutes(time_str)

    -- If it's within 10 minutes and not already shown
    if prayer_minutes - now_minutes <= 10 and prayer_minutes - now_minutes >= 0 then
      if last_alarm_prayer ~= prayer then
        last_alarm_prayer = prayer
        show_box({
          "🔔 Upcoming Prayer",
          "",
          string.format("%s at %s", prayer, entry.time)
        })
      end
      break
    end
  end
end

-- Recursively schedule check every 30s
local function start_alarm()
  local function loop()
    check_and_show_alarm()
    vim.defer_fn(loop, 30000)
  end
  loop()
end

M.start_alarm = start_alarm
return M
