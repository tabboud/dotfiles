" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

" TODO(tabboud): This only ever works on the first file we open!
" Get the location of the previous or next function.
function! go#textobj#FunctionLocation(direction, cnt) abort
  let l:fname = expand("%:p")
  if &modified
    " Write current unsaved buffer to a temp file and use the modified content
    let l:tmpname = tempname()
    call writefile(go#util#GetLines(), l:tmpname)
    let l:fname = l:tmpname
  endif

  let l:cmd = ['motion',
        \ '-format', 'vim',
        \ '-file', l:fname,
        \ '-offset', go#util#OffsetCursor(),
        \ '-shift', a:cnt,
        \ '-mode', a:direction,
        \ ]

  if go#config#TextobjIncludeFunctionDoc()
    let l:cmd += ['-parse-comments']
  endif

  let [l:out, l:err] = go#util#Exec(l:cmd)
  if l:err
    call go#log#Error(out)
    return
  endif

  " if exists, delete it as we don't need it anymore
  if exists("l:tmpname")
    call delete(l:tmpname)
  endif

  let l:result = json_decode(out)
  if type(l:result) != 4 || !has_key(l:result, 'fn')
    return 0
  endif

  return l:result
endfunction

function! go#textobj#FunctionJump(mode, direction) abort
  " get count of the motion. This should be done before all the normal
  " expressions below as those reset this value(because they have zero
  " count!). We abstract -1 because the index starts from 0 in motion.
  let l:cnt = v:count1 - 1

  " set context mark so we can jump back with  '' or ``
  normal! m'

  " select already previously selected visual content and continue from there.
  " If it's the first time starts with the visual mode. This is needed so
  " after selecting something in visual mode, every consecutive motion
  " continues.
  if a:mode == 'v'
    normal! gv
  endif

  let l:result = go#textobj#FunctionLocation(a:direction, l:cnt)
  if l:result is 0
    return
  endif

  " we reached the end and there are no functions. The usual [[ or ]] jumps to
  " the top or bottom, we'll do the same.
  if type(result) == 4 && has_key(result, 'err') && result.err == "no functions found"
    if a:direction == 'next'
      keepjumps normal! G
    else " 'prev'
      keepjumps normal! gg
    endif
    return
  endif

  let info = result.fn

  " if we select something ,select all function
  if a:mode == 'v' && a:direction == 'next'
    keepjumps call cursor(info.rbrace.line, 1)
    return
  endif

  if a:mode == 'v' && a:direction == 'prev'
    if has_key(info, 'doc') && go#config#TextobjIncludeFunctionDoc()
      keepjumps call cursor(info.doc.line, 1)
    else
      keepjumps call cursor(info.func.line, 1)
    endif
    return
  endif

  keepjumps call cursor(info.func.line, 1)
endfunction

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
