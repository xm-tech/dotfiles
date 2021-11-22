function! TranslateByYoudao() abort
  " expand("cword") : 扩展通配符, cword 表示当前光标下的单词
  let text = expand("<cword>")
  let query = "curl -s 'https://fanyi.youdao.com/translate?doctype=json&type=AUTO&i=" . text . "' | jq '.translateResult[0][0].tgt' | sed 's/\"//g'"
  let ret = system(query)
  call popup_notification(ret, {})
endfunction

" 定义1 vim 命令
" 紧接 command 命令其后的 ! 表示强制定义该命令，即使前面已经定义过了同样名称的命令，也将其覆盖掉。
" -nargs=* 表示，该命令可接受任意个数的参数， 包括 0 个
command! Trans call TranslateByYoudao()

" 利用 fanyi 命令翻译, fanyi 命令是我们安装的翻译工具
" translate the word under the cursor
nnoremap fy :call <SID>show_translation()<CR>
function! s:show_translation()
  let fyRet = system('fanyi '.expand('<cword>'))
  call popup_notification(fyRet, {
	\ 'minwidth': 40,
  	\ 'maxwidth': 40,
  	\ 'minheight': 20,
  	\ 'maxheight': 20,
  	\ 'time': 5000,
  	\ 'border': [],
  	\ 'close': 'click',
	\ })
endfunction
