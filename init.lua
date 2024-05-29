--
--        _   _       _                  _____             __ _
--       | \ | |     (_)                / ____|           / _(_)
--       |  \| |_   ___ _ __ ___       | |     ___  _ __ | |_ _  __ _
--       | . ` \ \ / / | '_ ` _ \      | |    / _ \| '_ \|  _| |/ _` |
--       | |\  |\ V /| | | | | | |     | |___| (_) | | | | | | | (_| |
--       |_| \_| \_/ |_|_| |_| |_|      \_____\___/|_| |_|_| |_|\__, |
--                                                               __/ |
--                                                              |___/

-- Author: hxajk (hxajkzzz@gmail.com).
-- Update: 2024-05-30 18:41:00

local installpath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(installpath) then
	require("core.bootstrap").init(installpath)
end

require("core.bootstrap").load(installpath)
