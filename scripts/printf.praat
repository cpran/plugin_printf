include ../../plugin_printf/procedures/printf.proc

printf.system = 0

form printf...
  sentence Format "%s, %s!"
  sentence Args "Hello", "World"
endform

@enquote: format$
format$ = enquote.str$

call @:printf: 'format$', 'args$'

procedure enquote: .str$
  if !index_regex(.str$, "^"".*""$")
    .str$ = """" + .str$ + """"
  endif
endproc
