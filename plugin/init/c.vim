" 避免插件多次加载
if exists('g:c_vim_loaded')
	echomsg "c.vim already loaded!"
	finish	
endif
let g:c_vim_loaded = 1

" to locate the c system header files
set path+=/Library/Developer/CommandLineTools/SDKs/MacOSX13.0.sdk/usr/include
