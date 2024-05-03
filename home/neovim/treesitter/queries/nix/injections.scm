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

; extraConfig -> Vim
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
  (#set! injection.combined))
