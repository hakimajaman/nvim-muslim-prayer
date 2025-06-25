local Job = require("plenary.job")

local function get_schedules(callback)
  local config = require('muslim-prayer.setup').config

  local date = os.date("*t")
  local day = date.day
  local month = date.month
  local year = date.year
  local base_url = ''

  if config.autoLocation == true then
  end

  if config.getScheduleBy == 'day' or config.alwaysResync == true then
    base_url = string.format("https://api.aladhan.com/v1/timings/%d-%d-%d", day, month, year)
  elseif config.getScheduleBy == 'year' then
    base_url = string.format("https://api.aladhan.com/v1/calendar/%d", year)
  else
    base_url = string.format("https://api.aladhan.com/v1/calendar/%d/%d", year, month)
  end

  local latitude = config.latitude
  local longitude = config.longitude
  local method = config.method
  local shafaq = config.shafaq
  local timezonestring = config.timezonestring
  local calendarMethod = config.calendarMethod

  local query = string.format(
    "latitude=%s&longitude=%s&method=%s&shafaq=%s&timezonestring=%s&calendarMethod=%s",
    latitude, longitude, method, shafaq, timezonestring, calendarMethod
  )

  local url = base_url .. "?" .. query

  local json = {
    generatedAt = os.time(),
    data = {}
  }

  Job:new({
    command = "curl",
    args = { "-s", "-H", "accept: application/json", url },
    on_exit = function(j, return_val)
      local result = table.concat(j:result(), "\n")

      local ok, decoded = pcall(vim.json.decode, result)
      if ok and decoded and decoded.data then
        if config.getScheduleBy == 'day' then
          table.insert(json.data, decoded.data)
        elseif config.getScheduleBy == 'year' then
          for month_num, days in pairs(decoded.data) do
            for _, item in ipairs(days) do
              table.insert(json.data, item)
            end
          end
        else
          for _, item in ipairs(decoded.data) do
            table.insert(json.data, item)
          end
        end

        -- Save JSON file asynchronously
        vim.schedule(function()
          local path = vim.fn.stdpath("data") .. "/muslim_prayer/muslim_prayer_time.json"
          vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
          local file = io.open(path, "w")
          if file then
            file:write(vim.fn.json_encode(json))
            file:close()
            print("📁 Prayer time saved to:", path)
          else
            print("❌ Failed to open file for writing")
          end
          if callback then
            callback(json)
          end
        end)
      else
        print("❌ Failed to parse JSON or no data")
        if callback then callback(nil) end
      end
    end,
  }):start()
end

local function get_local_schedules(callback)
  local path = vim.fn.stdpath("data") .. "/muslim_prayer/muslim_prayer_time.json"
  local file = io.open(path, "r")

  if file == nil then
    -- If no local file, fetch schedules and invoke callback once done
    get_schedules(callback)
    return
  end

  local content = file:read("*a")
  file:close()

  local ok, saved = pcall(vim.fn.json_decode, content)
  if not ok or not saved then
    print("❌ Failed to decode local schedules, refetching...")
    get_schedules(callback)
    return
  end

  if callback then
    callback(saved)
  end
end

local function schedules(callback, reschedule)
  if reschedule == true then
    get_schedules()
    return
  end
  -- schedules now accepts a callback to provide data asynchronously
  get_local_schedules(function(local_schedules)
    if not local_schedules or not local_schedules.data then
      print("❌ No schedule data available")
      if callback then callback(nil) end
      return
    end

    local t = os.date("*t")
    local day = string.format("%02d", t.day)
    local month = string.format("%02d", t.month)
    local year = t.year
    local today_key = string.format("%s-%s-%s", day, month, year)

    -- Find today's schedule from the data
    local today_schedule = nil
    for _, day_data in ipairs(local_schedules.data) do
      if day_data.date and day_data.date.gregorian and day_data.date.gregorian.date == today_key then
        today_schedule = day_data.timings
        break
      end
    end

    if not today_schedule then
      print("❌ No prayer times found for today:", today_key)
      if callback then callback(nil) end
      return
    end

    if callback then
      callback(today_schedule, today_key)
    end
  end)
end

return schedules
