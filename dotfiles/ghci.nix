{ pkgs }:

''
  :set prompt "\ESC[01;34mλ> \ESC[m"
  :set prompt-cont "\ESC[1;34m…> \ESC[m"

  :def pretty \_ -> return ("import Text.Pretty.Simple (pPrint, pShow, pString)\n:set -interactive-print pPrint")
  :def prettyl \_ -> return ("import Text.Pretty.Simple (pPrintLightBg, pShowLightBg, pStringLightBg)\n:set -interactive-print pPrintLightBg")
  :def no-pretty \_ -> return (":set -interactive-print System.IO.print")
''
