local M = {}

M.hadiths = {
  en = {
    "The best among you are those who have the best manners and character. (Bukhari)",
    "Whoever follows a path in pursuit of knowledge, Allah will make easy for him a path to Paradise. (Muslim)",
    "Make things easy, do not make things difficult. (Bukhari)",
    "None of you truly believes until he loves for his brother what he loves for himself. (Bukhari & Muslim)",
    "The strong person is not the one who can overpower others. Rather, the strong one is the one who controls himself when angry. (Bukhari)",
    "Spread peace between yourselves. (Muslim)"
  },
  id = {
    "Sebaik-baik manusia di antara kalian adalah yang paling baik akhlaknya. (HR. Bukhari)",
    "Barang siapa menempuh jalan untuk mencari ilmu, maka Allah akan mudahkan baginya jalan menuju surga. (HR. Muslim)",
    "Permudahlah dan jangan mempersulit. (HR. Bukhari)",
    "Tidak sempurna iman seseorang sampai ia mencintai saudaranya sebagaimana ia mencintai dirinya sendiri. (HR. Bukhari & Muslim)",
    "Orang kuat bukanlah yang pandai bergulat, tapi yang bisa menahan amarahnya. (HR. Bukhari)",
    "Sebarkanlah salam di antara kalian. (HR. Muslim)"
  }
}

function M.get_random(lang)
  lang = lang or "en"
  local list = M.hadiths[lang] or M.hadiths["en"]
  math.randomseed(os.time())
  return list[math.random(1, #list)]
end

return M
