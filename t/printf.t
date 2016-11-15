include ../../plugin_tap/procedures/more.proc
include ../../plugin_printf/procedures/printf.proc

test.fatal = 0

# Cannot test output from system printf
printf.system = 0

@plan: 3

call @:mytest: "# Hello, World!",           "# %s, %s!",  "Hello", "World"
call @:mytest: "# Hello" + tab$ + "World!", "# %s\t%s!",  "Hello", "World"
call @:mytest: "# Hello World!" + newline$, "# %s %s!\n", "Hello", "World"

@done_testing()

procedure mytest ()
  clearinfo

  .expected$ = .argv$[1]
  .format$ = .argv$[2]
  .msg$ = replace$(.format$, "#", "\#", 0)
  .args$ = replace$(.args$, """" + .argv$[1] + """, ", "", 1)

   if plan.skip != undefined and !plan.skip
     call @:printf: 'mytest.args$'
     .info$ = info$()
   else
     .info$ = ""
   endif

   appendInfoLine: ""
   @is$: .info$, .expected$,
     ... if printf.system then "(system) " else "(PP) " fi + .msg$
endproc
