return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            "--query-driver=/usr/bin/i686-elf-gcc",
          },
          init_options = {
            fallbackFlags = {
              "-ffreestanding",
              "-Iinclude",
              "-I.",
              "--target=i686-elf",
            },
          },
        },
      },
    },
  },
}
