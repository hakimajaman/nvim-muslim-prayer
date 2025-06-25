local M = {}

M.translations = {
  en = {
    upcoming_prayer = "🔔 Upcoming Prayer",
    at = "at",
    hadith_title = "📖 Hadith:",
  },
  id = {
    upcoming_prayer = "🔔 Waktu Shalat Berikutnya",
    at = "pada",
    hadith_title = "📖 Hadis:",
  },
}

function M.get(lang)
  return M.translations[lang] or M.translations["en"]
end

return M
