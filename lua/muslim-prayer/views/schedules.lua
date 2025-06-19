local M = {}

vim.cmd([[
  highlight MyTuesdayHighlight guibg=LightSkyBlue guifg=Red
  highlight MyHotkey guibg=#fdfdfd guifg=black
]])

local function highlight_column(buf, start_line, end_line, column_index, column_width)
  for line = start_line, end_line do
    local col_start = (column_index - 1) * column_width
    vim.api.nvim_buf_add_highlight(buf, -1, "MyTuesdayHighlight", line, col_start, col_start + column_width)
  end
end

local function parse_time(t)
  local h, m = t:match("^(%d%d?):(%d%d)")
  local minutes = tonumber(h) * 60 + tonumber(m)
  if minutes < 360 then
    minutes = minutes + 24 * 60
  end
  return minutes
end

local function rotate_to_fajr(prayers)
  local start_index = 1
  for i, entry in ipairs(prayers) do
    if entry.prayer == "Fajr" then
      start_index = i
      break
    end
  end

  -- Rotate the array so that Fajr is first
  local rotated = {}
  for i = start_index, #prayers do
    table.insert(rotated, prayers[i])
  end
  for i = 1, start_index - 1 do
    table.insert(rotated, prayers[i])
  end

  return rotated
end

local function sort_prayers_by_time(prayer_table)
  local arr = {}
  for prayer, time in pairs(prayer_table) do
    table.insert(arr, { prayer = prayer, time_str = time, time = parse_time(time) })
  end

  table.sort(arr, function(a, b)
    return a.time < b.time
  end)

  return arr
end

function M.openSchedule()
  local schedules = require("muslim-prayer.utils.schedules")


  schedules(function(data)
    if not data then
      print("Failed to get schedules")
      return
    end

    -- Access your data here, for example:
    local description = { "" }
    local lines = {}

    local column_width = 12

    local sorted_prayers = sort_prayers_by_time(data.today_schedule)
    local rotated_prayers = rotate_to_fajr(sorted_prayers)

    for _, entry in ipairs(rotated_prayers) do
      -- Format: left align prayer name (width 12), right align time (width 10)
      local line = string.format("%-12s %10s", entry.prayer, entry.time_str)
      table.insert(lines, line)
    end

    ---- Add the description at the bottom
    --table.insert(lines, "")
    --table.insert(lines, "Tips:")
    --table.insert(lines, '"C" to change the day')

    local box = require("muslim-prayer.views.comp.box")
    local win, buf = box(lines)

    --highlight_column(buf, 2, #lines - 1, 4, column_width)

    ---- Highlight "C" hotkey
    --local desc_line = 3
    --for i = 1, desc_line do
    --  local hot_line = #lines - i
    --  vim.api.nvim_buf_add_highlight(buf, -1, "MyHotkey", hot_line, 0, 3)
    --end

    --local date = require("hakimajaman.muslim_prayer.utils.change_date")
    --date.change_date(buf)
  end)
end

return M
