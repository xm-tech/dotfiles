
" ==================== markdown ====================
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_fenced_languages = ['go=go', 'viml=vim', 'bash=sh']
let g:vim_markdown_conceal = 0
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_extensions_in_markdown = 1

" create a hugo front matter in toml format to the beginning of a file. Open
" empty markdown file, i.e: '2018-02-05-speed-up-vim.markdown'. Calling this
" function will generate the following front matter under the cursor:
"
"   +++
"   author = "xm-tech"
"   date = 2018-02-03 08:41:20
"   title = "Speed up vim"
"   slug = "speed-up-vim"
"   url = "/2018/02/03/speed-up-vim/"
"   featured_image = ""
"   description =  ""
"   +++
"
function! s:create_front_matter()
  let fm = ["+++"]
  call add(fm, 'author = "xm-tech"')
  call add(fm, printf("date = \"%s\"", strftime("%Y-%m-%d %X")))

  let filename = expand("%:r")
  let tl = split(filename, "-")
  " in case the file is in form of foo.md instead of
  " year-month-day-foo.markdown
  if !empty(str2nr(tl[0])) 
    let tl = split(filename, "-")[3:]
  endif

  let title = join(tl, " ")
  let title = toupper(title[0]) . title[1:]
  call add(fm, printf("title = \"%s\"", title))

  let slug = join(tl, "-")
  call add(fm, printf("slug = \"%s\"", slug))
  call add(fm, printf("url = \"%s/%s/\"", strftime("%Y/%m/%d"), slug))

  call add(fm, 'featured_image = ""')
  call add(fm, 'description = ""')
  call add(fm, "+++")
  call append(0, fm)
endfunction

" create a shortcode that inserts an image holder with caption or class
" attribute that defines on how to set the layout.
function! s:create_figure()
  let fig = ["{{< figure"]
  call add(fig, 'src="/images/image.jpg"')
  call add(fig, 'class="left"')
  call add(fig, 'caption="This looks good!"')
  call add(fig, ">}}")

  let res = [join(fig, " ")]
  call append(line("."), res)
endfunction

augroup md
  autocmd!
  autocmd Filetype markdown command! -bang HugoFrontMatter call <SID>create_front_matter()
  autocmd Filetype markdown command! -bang HugoFig call <SID>create_figure()
augroup END

