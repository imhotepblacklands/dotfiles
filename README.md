# Dotfiles

My personal dotfiles for Termux.

## Prerequisites (Termux)

Some Neovim tools are installed globally via `pkg` instead of Mason to ensure compatibility with Termux:

```bash
pkg install -y stylua lua-language-server
```

These are required for the Neovim configuration (`kickstart.nvim`) to function correctly without installation errors.
