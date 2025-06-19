local function parse_time(t)
  local h, m = t:match("^(%d%d?):(%d%d)")
  local minutes = tonumber(h) * 60 + tonumber(m)
  if minutes < 360 then
    minutes = minutes + 24 * 60
  end
  return minutes
end

local function get_next_prayer(lines)
  local now = os.date("*t")
  local now_minutes = now.hour * 60 + now.min
  if now_minutes < 360 then
    now_minutes = now_minutes + 24 * 60
  end

  -- Extract {index, line, time} for sorting
  local prayers = {}
  for i, line in ipairs(lines) do
    local time_str = line:match("%d%d?:%d%d")
    if time_str then
      table.insert(prayers, {
        original_index = i,
        line = line,
        time = parse_time(time_str),
      })
    end
  end

  -- Sort by time ascending
  table.sort(prayers, function(a, b)
    return a.time < b.time
  end)

  -- Find first prayer after now
  for _, prayer in ipairs(prayers) do
    if prayer.time > now_minutes then
      return prayer.original_index
    end
  end

  -- If none found (all times passed), return first prayer (soonest next day)
  if #prayers > 0 then
    return prayers[1].original_index
  end

  return nil
end

local function box(lines)
  lines = lines or {}

  -- Calculate max width & padding as before
  local max_line_width = 0
  for _, line in ipairs(lines) do
    if #line > max_line_width then max_line_width = #line end
  end

  local padding = 4
  local width = max_line_width + padding
  local height = #lines

  if height == 0 then
    lines = { "No content." }
    height = 1
    width = #"No content." + padding
  end

  local row = 1
  local col = vim.o.columns - width - 2

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].swapfile = false
  vim.bo[buf].bufhidden = "wipe"

  for _, key in ipairs({ "i", "a", "I", "A", "o", "O", "s", "S", "c", "C", "x", "d", "r", "R" }) do
    vim.keymap.set("n", key, "<NOP>", { buffer = buf, silent = true })
  end

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- Highlight the next prayer line
  local next_line = get_next_prayer(lines)
  if next_line then
    -- highlight the entire line (0-based indexing internally)
    vim.api.nvim_buf_add_highlight(buf, -1, "MyHotkey", next_line - 1, 0, -1)
  end

  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, nowait = true, silent = true })

  return win, buf
end

return box
