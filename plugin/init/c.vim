" 避免插件多次加载
if exists('g:c_vim_loaded')
	echomsg "c.vim already loaded!"
	finish	
endif
let g:c_vim_loaded = 1

" fix the problem that cannot locate the source file of the c system header files
" to locate the c stand library sourcefiles, FIXME instability
set path+=/Library/Developer/CommandLineTools/SDKs/MacOSX13.1.sdk/usr/include/
set path+=/Library/Developer/CommandLineTools/usr/lib/clang/14.0.0/include/

" to locate the SDL sourcefile
set path+=/usr/local/Cellar/sdl2/2.24.0/include/
