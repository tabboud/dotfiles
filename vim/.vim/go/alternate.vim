" Alternate to/from a Go test file

" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

" Test alternates between the implementation of code and the test code.
function! go#alternate#Switch(bang, cmd) abort
  let file = expand('%')
  if empty(file)
    call go#log#Error("no buffer name")
    return
  elseif file =~# '^\f\+_test\.go$'
    let l:root = split(file, '_test.go$')[0]
    let l:alt_file = l:root . ".go"
  elseif file =~# '^\f\+\.go$'
    let l:root = split(file, ".go$")[0]
    let l:alt_file = l:root . '_test.go'
  else
    call go#log#Error("not a go file")
    return
  endif
  if !filereadable(alt_file) && !bufexists(alt_file) && !a:bang
    call go#log#Warning("Creating file in vsplit: ".alt_file)
    execute ":vsplit " . alt_file
    return
  elseif empty(a:cmd)
    execute ":vsplit " . alt_file
  else
    execute ":" . a:cmd . " " . alt_file
  endif
endfunction

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
