include ../../plugin_printf/procedures/printf.proc

printf.system = 0

form fprintf...
  sentence Format "%s, %s!"
  sentence Filename ~/test.txt
  sentence Args "Hello", "World"
  comment Argument list must be a comma separated list, with quoted strings
endform

@enquote: filename$
filename$ = enquote.str$

if filename$ == """"""
  exitScript: "Filename cannot be empty"
endif

@enquote: format$
format$ = enquote.str$

call @:fprintf: 'filename$', 'format$', 'args$'

procedure enquote: .str$
  if !index_regex(.str$, "^"".*""$")
    .str$ = """" + .str$ + """"
  endif
endproc
