" function! Go_to_used() abort
" 	call CocActionAsync('jumpUsed')
" endfunction

" " coc not ccls
" " nmap <silent> \gd <Plug>(coc-definition)
" " nmap <silent> <C-,> <Plug>(coc-references)
" nmap <silent> \gd :<C-U>call CocActionAsync('jumpDefinition')<cr>
" nmap <silent> \gt :<C-U>call CocActionAsync('jumpTypeDefinition')<cr>
" nmap <silent> \gr :<C-U>call CocActionAsync('jumpReferences')<cr>
" " Jump to references without declarations
" nmap <silent> \gu :<C-U>call Go_to_used()<cr>
" " jump to implementation locations
" " nmap <silent> \gi :<C-U>call CocActionAsync('jumpImplementation')<cr>
" " " get definition list
" " nmap <silent> \ld :<C-U>call CocActionAsync('definitions')<cr>
" " " get declaration list
" " nmap <silent> \ldc :<C-U>call CocActionAsync('declarations')<cr>
" " " get implementation list
" " nmap <silent> \li :<C-U>call CocActionAsync('implementations')<cr>

" nn <silent> K :<C-U>call CocActionAsync('doHover')<cr>

" set updatetime=300
" au CursorHold * sil call CocActionAsync('highlight')
" au CursorHoldI * sil call CocActionAsync('showSignatureHelp')

" " bases
" nn <silent> xb :call CocLocations('ccls','$ccls/inheritance')<cr>
" " bases of up to 3 levels
" nn <silent> xB :call CocLocations('ccls','$ccls/inheritance',{'levels':3})<cr>
" " derived
" nn <silent> xd :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true})<cr>
" " derived of up to 3 levels
" nn <silent> xD :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true,'levels':3})<cr>

" " caller
" nn <silent> xc :call CocLocations('ccls','$ccls/call')<cr>
" " callee
" nn <silent> xC :call CocLocations('ccls','$ccls/call',{'callee':v:true})<cr>

" " $ccls/member
" " member variables / variables in a namespace
" nn <silent> xm :call CocLocations('ccls','$ccls/member')<cr>
" " member functions / functions in a namespace
" nn <silent> xf :call CocLocations('ccls','$ccls/member',{'kind':3})<cr>
" " nested classes / types in a namespace
" nn <silent> xs :call CocLocations('ccls','$ccls/member',{'kind':2})<cr>

" nmap <silent> xt <Plug>(coc-type-definition)<cr>
" nn <silent> xv :call CocLocations('ccls','$ccls/vars')<cr>
" nn <silent> xV :call CocLocations('ccls','$ccls/vars',{'kind':1})<cr>

" nn xx x

" nn <silent><buffer> <C-l> :call CocLocations('ccls','$ccls/navigate',{'direction':'D'})<cr>
" nn <silent><buffer> <C-k> :call CocLocations('ccls','$ccls/navigate',{'direction':'L'})<cr>
" nn <silent><buffer> <C-j> :call CocLocations('ccls','$ccls/navigate',{'direction':'R'})<cr>
" nn <silent><buffer> <C-h> :call CocLocations('ccls','$ccls/navigate',{'direction':'U'})<cr>
