# Nvim Keymap Cheat Sheet

Leader is `,`. Press `,` to see the live which-key menu. Open this file anytime with `,?`.

## Fast keys (top level)

| Key | Action |
|-----|--------|
| `,,` | Save file |
| `,.` | Go to last buffer |
| `,e` | Explorer (Yazi) at current file |
| `,E` | Explorer (Yazi) in cwd |
| `,k` | Toggle file drawer (neo-tree) |
| `,z` | Zen mode |
| `,Z` | Zoom |
| `,/` | Toggle comment (line / selection) |
| `,?` | Open this cheat sheet |
| `-`  | Open parent directory (Oil) |

## `,f` find / file

| Key | Action |
|-----|--------|
| `,ff` | Find files |
| `,fs` | Find git files |
| `,fo` | Find recent files (MRU) |
| `,fg` | Search string (live grep) |
| `,fr` | Search string (raw grep args) |
| `,fb` | Find in open buffers |
| `,fh` | Find in help |
| `,fn` | List node_modules |
| `,fc` | Create file |
| `,fd` | Delete current file |
| `,fR` | Rename current file |

## `,p` project

| Key | Action |
|-----|--------|
| `,pp` | Open recent project |
| `,pn` | Open new project (cd + find files) |

## `,g` git

| Key | Action |
|-----|--------|
| `,gg` | Lazygit |
| `,gl` | Lazygit log (cwd) |
| `,gf` | Lazygit current file history |
| `,gB` | Git browse (open in web) |
| `,gc` | Commits (telescope) |
| `,gs` | Status (telescope) |
| `,gC` | Git commit |
| `,gp` | Git pull |
| `,gP` | Git push (confirms first) |
| `,gn` | New branch |
| `,gr` | Read file from git |
| `,gb` | Git blame |

## `,h` git hunks

| Key | Action |
|-----|--------|
| `,hs` | Stage hunk |
| `,hr` | Reset hunk |
| `,hS` | Stage buffer |
| `,hu` | Undo stage hunk |
| `,hR` | Reset buffer |
| `,hp` | Preview hunk |
| `,hb` | Blame line |
| `,hd` | Diff this |
| `,hD` | Diff this file (vs ~) |
| `]c` / `[c` | Next / previous hunk |

## `,c` claude

| Key | Action |
|-----|--------|
| `,cc` | Toggle Claude |
| `,cC` | Toggle Claude (--continue) |
| `,cV` | Toggle Claude (--verbose) |
| `<C-,>` | Toggle Claude (normal & terminal) |

## `,x` diagnostics / code

| Key | Action |
|-----|--------|
| `,xx` | Diagnostics (Trouble) |
| `,xX` | Buffer diagnostics (Trouble) |
| `,xs` | Symbols (Trouble) |
| `,xl` | LSP defs / refs (Trouble) |
| `,xL` | Location list |
| `,xQ` | Quickfix list |
| `,xd` | Show diagnostics |
| `,xq` | Send diagnostics to loclist |

## `,s` search / replace (grug-far)

| Key | Action |
|-----|--------|
| `,sr` | Search & replace (visual mode prefills selection) |
| `,sw` | Search & replace word under cursor |
| `,sp` | Search & replace in current file |

Inside the grug-far buffer: edit Search / Replace / Files fields, then `<localleader>r` (default) to apply. `<localleader>?` for help.

## `,u` ui / toggle

| Key | Action |
|-----|--------|
| `,ui` | Toggle invisible characters |
| `,uC` | Toggle cursor line |
| `,uN` | Notification history |
| `,uB` | Toggle git line blame |
| `,uX` | Toggle git deleted |
| `,um` | Toggle markdown render (in markdown files) |
| `,us` | Spelling · `,uw` Wrap · `,ul` Line number · `,uL` Relative number |
| `,ud` | Diagnostics · `,uc` Conceallevel · `,uT` Treesitter |
| `,ub` | Dark background · `,uh` Inlay hints · `,ug` Indent · `,uD` Dim |
| `,un` | Dismiss all notifications |

## `,t` terminal

| Key | Action |
|-----|--------|
| `,tt` | Toggle terminal |
| `<C-/>` | Toggle terminal |

## `,b` buffer

| Key | Action |
|-----|--------|
| `,bd` | Delete buffer |
| `,bs` | Scratch buffer |
| `,bS` | Select scratch buffer |

## Comments (builtin `gc`)

| Key | Action |
|-----|--------|
| `,/` | Toggle comment (normal line / visual selection) |
| `gcc` | Toggle comment on current line |
| `gc` + motion | Comment a motion, e.g. `gcap`, `gc3j`, `gcG` |
| `gc` (visual) | Toggle comment on selection |

## File drawer (neo-tree, inside `,k`)

| Key | Action |
|-----|--------|
| `a` | Add file · `A` add directory |
| `d` | Delete · `r` rename · `m` move |
| `y` / `x` / `p` | Copy / cut / paste |
| `H` | Toggle hidden · `/` fuzzy find |
