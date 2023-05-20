from os import getAppFilename, commandLineParams
import bwap

when isMainModule:
  let ap = newArgsParser(getAppFilename(), "Arg parser help text.")

  var apPos = ap.newOptionalPositionalArgs("Optional positional args.", mostArgs = 2)

  var apRVL = ap.newRequiredValuedListArgs("rvl", 'r', "Required valued list args.", argChoices = ["a", "b", "c", "abc"], mostArgs = 3)
  var apOVL = ap.newOptionalValuedListArgs("ovl", 'o', "Optional valued list args.", argChoices = ["a", "b", "c", "abc"], defaultArgs = ["a", "b", "c", "abc"])

  var apOV = ap.newOptionalValuedArgs("ov", 'O', "Optional valued args.", argChoices = ["a", "b", "c", "abc"], defaultArg = "abc", mostArgs = 3)
  var apRV = ap.newRequiredValuedArgs("rv", 'R', "Required valued args.")

  var apF = ap.newBoolArgs("bool", 'b', "Optional valued args.", leastArgs = 1, mostArgs = 2)
  var apH = ap.newHelpArgs("help", 'h', "Help args.")

  ap.parseOptsSeq( commandLineParams() )
  stderr.write( ap.getArgsParserFullInfo() )
