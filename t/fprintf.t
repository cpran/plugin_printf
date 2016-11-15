include ../../plugin_tap/procedures/more.proc
include ../../plugin_printf/procedures/printf.proc

test.fatal = 0
has_system = printf.system
printf.system = 0

@plan: 6

for i to 2
  if printf.system and !has_system
    @skip_all: "No support for system printf (perl)"
  endif

  call @:mytest: "# Hello, World!",           "# %s, %s!",  "Hello", "World"
  call @:mytest: "# Hello" + tab$ + "World!", "# %s\t%s!",  "Hello", "World"
  call @:mytest: "# Hello World!" + newline$, "# %s %s!\n", "Hello", "World"

  printf.system += 1
endfor

@done_testing()

procedure mytest ()
  clearinfo

  .expected$ = .argv$[1]
  .format$ = .argv$[2]
  .msg$ = replace$(.format$, "#", "\#", 0)
  .args$ = replace$(.args$, """" + .argv$[1] + """, ", "", 1)

  if plan.skip != undefined and !plan.skip
    @mktempfile: "fprintf_XXXXXXXX", "txt"
    call @:fprintf: mktempfile.return$, 'mytest.args$'
    .out$ = readFile$(mktempfile.return$)
    deleteFile(mktempfile.return$)
  else
    .out$ = ""
  endif

  @is$: .out$, .expected$,
    ... if printf.system then "(system) " else "(PP) " fi + .msg$
endproc
