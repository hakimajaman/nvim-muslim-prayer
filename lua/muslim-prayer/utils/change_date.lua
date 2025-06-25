local M = {}
local selectedDay = os.date("*t").day
local selectedMonth = os.date("*t").month
local selectedYear = os.date("*t").year

local selectedDate = string.format("%02d/%02d/%04d", selectedDay, selectedMonth, selectedYear)

function M.change_date(buf, date)
  selectedDate = date or selectedDate

  -- Input hotkeys
  vim.keymap.set("n", "C", function()
    vim.ui.input({ prompt = "Enter Date: ", default = tostring(selectedDate) }, function(input)
      if input:match("^%d%d?/%d%d?/%d%d%d%d$") ~= nil then
        selectedDate = input
      else
        print("False inputting date, it should dd/mm/yyyy")
      end
    end)
  end, { buffer = buf })
end

return M
