-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  {
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup {
        vim.keymap.set('n', '_', require('oil').open_float, { desc = 'open parent directory' }),
      }
    end,
  },
}
