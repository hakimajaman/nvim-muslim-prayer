local Job = require("plenary.job")

local function get_schedules(callback)
  local month = os.date("*t").month
  local base_url = string.format("https://api.aladhan.com/v1/calendar/2025/%d", month)
  local latitude = "1.14937"
  local longitude = "104.02491"
  local method = "3"
  local shafaq = "general"
  local timezonestring = "Asia/Jakarta"
  local calendarMethod = "UAQ"

  local query = string.format(
    "latitude=%s&longitude=%s&method=%s&shafaq=%s&timezonestring=%s&calendarMethod=%s",
    latitude, longitude, method, shafaq, timezonestring, calendarMethod
  )

  local url = base_url .. "?" .. query

  local json = {
    generatedAt = os.time(),
    location = "Batam",
    data = {}
  }

  Job:new({
    command = "curl",
    args = { "-s", "-H", "accept: application/json", url },
    on_exit = function(j, return_val)
      local result = table.concat(j:result(), "\n")

      local ok, decoded = pcall(vim.json.decode, result)
      if ok and decoded and decoded.data then
        for _, item in ipairs(decoded.data) do
          table.insert(json.data, item)
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

local function schedules(callback)
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

    -- Example to print today's prayer times
    --print("Prayer Times for Batam on " .. today_key)
    for prayer, time in pairs(today_schedule) do
      --print(string.format("%s: %s", prayer, time))
    end

    -- You can also return static or dynamic tables as you want:
    local title = { "Prayer Time in Batam" }
    local days = { "", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
    local prayers = {
      { "Fajr" },
      { "Dhuhr" },
      { "Asr" },
      { "Maghrib" },
      { "Isha" },
    }

    if callback then
      callback({
        title = title,
        days = days,
        prayers = prayers,
        today_schedule = today_schedule,
      })
    end
  end)
end

return schedules
