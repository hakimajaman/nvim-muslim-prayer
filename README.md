# 🕌 nvim-muslim-prayer

A simple Neovim plugin to display Muslim prayer times with a beautiful and minimal floating UI.  
Built with 💖 for productivity-focused developers who don't want to miss their prayers.

---

## ✨ Features

- 📅 Daily prayer schedule based on your location
- 🌍 Uses [Aladhan API](https://aladhan.com/prayer-times-api) for accurate global timings
- 🔔 Prayer reminders with customizable styles
- 📖 Random hadith notifications in English or Bahasa Indonesia
- 💻 Lightweight and written in pure Lua for Neovim
- ⚡ Quick access via `:Prayer` command

---

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim);
If you want to check your latitude and longitude, you can find it in [ip-api](http://ip-api.com/json/);

```lua
{
  "hakimajaman/nvim-muslim-prayer",
  name = "muslim-prayer",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Utility functions
  },
  lazy = false,
  config = function()
    require("muslim-prayer").setup({
      -- Aladhan API Settings
      latitude = "1.14937",
      longitude = "104.02491",
      method = "3",
      shafaq = "general",
      timezonestring = "Asia/Jakarta",
      calendarMethod = "UAQ",
      location = "Default City",
      lang = "id", -- or "en"

      notification_style = "box", -- "box" or "notify"
      getScheduleBy = "month",
    })
  end,
}
```
---

## 🚀 Usage
| Command    | Description |
| ----------------- | --------------------------------------------- |
| :Prayer           | Toggle the prayer schedule popup              |
| :Prayer schedule  | Show or hide the floating daily prayer times  |
| :Prayer next      | Show the next upcoming prayer + hadith        |
| :Prayer resync    | Force resync prayer times from Aladhan API    |

---

## ⚙️ Configuration Options
The plugin supports the following default config (overridable via .setup({})):

```lua
{
  -- Aladhan API Settings
  latitude = "1.14937",
  longitude = "104.02491",
  method = "3",
  shafaq = "general",
  timezonestring = "Asia/Jakarta",
  calendarMethod = "UAQ",
  location = "Default City",

  -- UI
  notification_style = "box", -- "box" or "notify"

  -- Fetch behavior
  getScheduleBy = "month", -- "day", "month", or "year"
  alwaysResync = false,

  -- Language
  lang = "id", -- "id" for Bahasa Indonesia or "en" for English
  notify_before = 30 -- in mins // by default it's 30 mins
}
```

---

## 📖 Hadith Display
Each upcoming prayer notification includes a random hadith.
Hadiths are shown in the selected language (lang = "id" or "en").

---

## 🤝 Contribution
Have ideas or suggestions? Feel free to fork, improve, and submit PRs.
Let’s help more developers remember their prayers
