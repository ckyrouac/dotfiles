return {
  {
    dir = "~/projects/nfc.nvim",
    opts = {
      default_todo_list = "Work",
      notes_dir = "/home/chris/Insync/chriskyrouac@gmail.com/Google Drive/Sync/notes.nvim",
    },
    cmd = { "Notes", "NotesMarkDone", "NotesOpen", "NotesSearch", "NotesTodo", "NotesTodoPick" },
    keys = {
      { "<leader>nn", "<cmd>Notes<cr>", desc = "Open today's notes" },
      { "<leader>nd", "<cmd>NotesMarkDone<cr>", desc = "Mark TODO done" },
      { "<leader>nt", "<cmd>NotesTodo<cr>", desc = "Add TODO item" },
      { "<leader>np", "<cmd>NotesTodoPick<cr>", desc = "Pick TODO list" },
    },
  },
}
