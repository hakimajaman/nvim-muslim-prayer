# 🕌 nvim-muslim-prayer

A simple Neovim plugin to display Muslim prayer times directly inside your editor using a minimal floating UI. Built with 💖 for productivity-focused developers.

---

## ✨ Features

- 📅 Show daily prayer schedule for your location
- 🧭 Fetches accurate times using [Aladhan API](https://aladhan.com/prayer-times-api)
- 💡 Minimal UI using Neovim floating windows
- ⚡ Instant access via command `:Prayer`

---

## 📦 Installation

Use your favorite plugin manager. Here’s how with **lazy.nvim**:

```lua
{
  "hakimajaman/nvim-muslim-prayer",
  name = "muslim-prayer",
  dependencies = {
    "nvim-lua/plenary.nvim", -- 💡 Automatically install plenary if not present
  },
  lazy = false
}
