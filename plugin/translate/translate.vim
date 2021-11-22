function! TranslateByYoudao() abort
  " expand("cword") : 扩展通配符, cword 表示当前光标下的单词
  let text = expand("<cword>")
  let query = "curl -s 'https://fanyi.youdao.com/translate?doctype=json&type=AUTO&i=" . text . "' | jq '.translateResult[0][0].tgt' | sed 's/\"//g'"
  let ret = system(query)
  call popup_notification(ret, {})
endfunction

" 定义1 vim 命令
command! Trans call TranslateByYoudao()
