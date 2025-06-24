;extends
; extraLuaConfig -> Lua
(binding
  attrpath: (attrpath
    (identifier) @_path)
  expression: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "lua")))
  ]
  (#match? @_path "^extraLuaConfig$")
  (#set! injection.combined))

; neovim.extraConfig -> Vim
(binding
  (
   (attrpath
     (identifier) @_outer
     (identifier) @_inner
   )
  )
  (attrset_expression
    (binding_set
	(binding
	  attrpath: (attrpath
	    (identifier) @_path)
	  expression: [
	    (string_expression
	      ((string_fragment) @injection.content
		(#set! injection.language "vim")))
	    (indented_string_expression
	      ((string_fragment) @injection.content
		(#set! injection.language "vim")))
	  ]
	  (#match? @_path "^extraConfig$")
	  (#match? @_inner "^neovim$")
	  (#set! injection.combined)
	)
     )
  )
)

; inline vim plugin configs of type Lua
(binding_set
	binding: (binding
	  attrpath: (attrpath
	    (identifier) @_path)
	  expression: [
	    (string_expression
	      ((string_fragment) @injection.content
		(#set! injection.language "lua")))
	    (indented_string_expression
	      ((string_fragment) @injection.content
		(#set! injection.language "lua")))
	  ]
	  )
	binding: (binding
	  attrpath: (attrpath
	    (identifier) @_typearg)
	  expression: [
	    (string_expression
	      ((string_fragment) @_typeval
		))
	    (indented_string_expression
	      ((string_fragment) @_typeval
		))
	  ]
	)
	(#match? @_typearg "^type$")
	(#match? @_typeval "^lua$")
	(#match? @_path "^config$")
	(#set! injection.combined)
)

; style -> CSS
(binding
  attrpath: (attrpath
    (identifier) @_path)
  expression: [
    (string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "css")))
    (indented_string_expression
      ((string_fragment) @injection.content
        (#set! injection.language "css")))
  ]
  (#match? @_path "^style$")
  (#set! injection.combined))
