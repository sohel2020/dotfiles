# Neovim File Operations Cheat Sheet

This cheat sheet is based on your current config.

Leader key: `,`

## Open and browse files

| Action | Key | Notes |
|---|---|---|
| Toggle file tree (Neo-tree) | `<leader>k` | Opens or closes the file drawer and reveals current file |
| Open parent directory (Oil) | `-` | Opens filesystem view for current location |

## Find files and text (Telescope)

| Action | Key | Notes |
|---|---|---|
| Find files | `<leader>ff` | Main file picker |
| Recent files | `<leader>fo` | MRU list |
| Find in open buffers | `<leader>fb` or `<leader>r` | Buffer picker |
| Live grep (find string in project) | `<leader>fg` | Project-wide text search |
| Live grep with raw args | `<leader>fr` | Advanced grep args |
| Find git files (inside git repo) | `<leader>fs` or `<leader>t` or `<D-p>` | Uses git tracked files |
| Find all files (outside git repo) | `<leader>t` or `<D-p>` | Falls back to normal file search |

## Save files

| Action | Key | Notes |
|---|---|---|
| Save | `<leader>,` | Normal mode |
| Save | `<C-s>` | Normal/insert/visual |
| Save | `<D-s>` | Normal/insert/visual |

## Tab operations

| Action | Key | Notes |
|---|---|---|
| Open current buffer in a new tab | `gTT` | Useful when splitting work |
| Next tab | `gt` | Built-in Vim tab navigation |
| Previous tab | `gT` | Built-in Vim tab navigation |
| Jump to tab number | `Ngt` | Example: `2gt` |

## Neo-tree file actions (inside tree window)

| Action | Key |
|---|---|
| Open | `<CR>` or double click |
| Open in horizontal split | `S` |
| Open in vertical split | `s` |
| Open in new tab | `t` |
| Add file | `a` |
| Add directory | `A` |
| Rename | `r` |
| Delete | `d` |
| Copy | `c` |
| Move | `m` |
| Copy to clipboard | `y` |
| Cut to clipboard | `x` |
| Paste from clipboard | `p` |
| Toggle hidden files | `H` |
| Fuzzy find in tree | `/` |
| Close tree window | `q` |

## Useful command-line alternatives

- `:Telescope find_files`
- `:Telescope live_grep`
- `:Neotree toggle reveal`
- `:Oil`
- `:tabedit path/to/file`

## IDE-style daily flow

1. Open tree with `<leader>k`.
2. Find a file with `<leader>ff`.
3. Search project text with `<leader>fg`.
4. Open selected file in a tab with `gTT` or `t` (from tree).
5. Save with `<C-s>`.
