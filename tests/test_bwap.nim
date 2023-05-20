#discard """
#
#  # What actions to expect completion on.
#  # Options:
#  #   "compile": expect successful compilation
#  #   "run": expect successful compilation and execution
#  #   "reject": expect failed compilation. The "reject" action can catch
#  #             {.error.} pragmas but not {.fatal.} pragmas because
#  #             {.fatal.} pragmas guarantee that compilation will be aborted.
#  action: "run"
#
#  # The exit code that the test is expected to return. Typically, the default
#  # value of 0 is fine. Note that if the test will be run by valgrind, then
#  # the test will exit with either a code of 0 on success or 1 on failure.
#  exitcode: 0
#
#  # Provide an `output` string to assert that the test prints to standard out
#  # exatly the expected string. Provide an `outputsub` string to assert that
#  # the string given here is a substring of the standard out output of the
#  # test.
#  output: ""
#  outputsub: ""
#
#  # Whether to sort the output lines before comparing them to the desired
#  # output.
#  sortoutput: true
#
#  # Each line in the string given here appears in the same order in the
#  # compiler output, but there may be more lines that appear before, after, or
#  # in between them.
#  nimout: '''
#a very long,
#multi-line
#string'''
#
#  # This is the Standard Input the test should take, if any.
#  input: ""
#
#  # Error message the test should print, if any.
#  errormsg: ""
#
#  # Can be run in batch mode, or not.
#  batchable: true
#
#  # Can be run Joined with other tests to run all togheter, or not.
#  joinable: true
#
#  # On Linux 64-bit machines, whether to use Valgrind to check for bad memory
#  # accesses or memory leaks. On other architectures, the test will be run
#  # as-is, without Valgrind.
#  # Options:
#  #   true: run the test with Valgrind
#  #   false: run the without Valgrind
#  #   "leaks": run the test with Valgrind, but do not check for memory leaks
#  valgrind: true   # Can use Valgrind to check for memory leaks, or not (Linux 64Bit only).
#
#  # Command the test should use to run. If left out or an empty string is
#  # provided, the command is taken to be:
#  # "nim $target --hints:on -d:testing --nimblePath:tests/deps $options $file"
#  # You can use the $target, $options, and $file placeholders in your own
#  # command, too.
#  cmd: "nim c -d:testing --opt:speed --assertions:on --checks:on --threads:on --stackTrace:on --lineTrace:on --app:console --colors:on --debuginfo:on --warnings:on --hints:on --nilseqs:off --multimethods:off --implicitStatic:on --profiler:off --styleCheck:hint $file"
#
#  # Maximum generated temporary intermediate code file size for the test.
#  maxcodesize: 500
#
#  # Timeout seconds to run the test. Fractional values are supported.
#  timeout: 0.1
#
#  # Targets to run the test into (C, C++, JavaScript, etc).
#  target: "c js"
#
#  # Conditions that will skip this test. Use of multiple "disabled" clauses
#  # is permitted.
#  #disabled: "bsd"   # Can disable OSes...
#  #disabled: "win"
#  #disabled: "32bit" # ...or architectures
#  #disabled: "i386"
#  #disabled: "azure" # ...or pipeline runners
#  #disabled: true    # ...or can disable the test entirely
#
#"""

#import nimprof
import bwap
from os import getAppFilename

#TODO: Remove me?
proc assertEmptyPositionalArgs[T](ap: T) =
  assert(ap.getPositionalArgs().getValues().len() == 0)
  assert(ap.getPositionalArgs().getNumValues() == 0)
  assert(ap.getPositionalArgs().getIsSet() == false)

proc testErrors() =
  doAssertRaises(BwapSubCommandNameError):
    discard newArgsParser("", "Arg parser help text.", leastSubCommands = 0, mostSubCommands = 4)

  let ap = newArgsParser(getAppFilename(), "Arg parser help text.", leastSubCommands = 0, mostSubCommands = 4)
  assert( ap.getExeName() == getAppFilename() )
  doAssertRaises(BwapUninitError):
    discard ap.getPositionalArgs()
  doAssertRaises(BwapLookupError):
    discard ap.getShortName('\0')
  doAssertRaises(BwapLookupError):
    discard ap.getLongName("")
  doAssertRaises(BwapLookupError):
    discard ap['\0']
  doAssertRaises(BwapLookupError):
    discard ap[""]
  assert(ap.getSubCommandsList.len() == 0)
  doAssertRaises(BwapRangeError):
    discard ap.newRequiredPositionalArgs("Positional args help text.", [], 6, 3)
  doAssertRaises(BwapRangeError):
    discard ap.newOptionalPositionalArgs("Positional args help text.", ["a", "b", "c"], [], 2)
  doAssertRaises(BwapChoicesError):
    discard ap.newOptionalPositionalArgs("Positional args help text.", ["a", "b", "c"], ["a"], 3)

  discard ap.newOptionalPositionalArgs("Positional args help text.", [], [], 2)

  doAssertRaises(BwapReinitError):
    discard ap.newOptionalPositionalArgs("Positional args help text.", [], [], 2)

  assertEmptyPositionalArgs(ap)
#  doAssertRaises(BwapRangeError):
#	ap.parseOptsSeq(@[])

  discard ap.newHelpArgs(longName = "help", shortName = 'h', helpText = "Help arg.", mostArgs = 3)

  assert( cast[pointer](ap['h']) == cast[pointer](ap["help"]) )

  doAssertRaises(BwapArgtypeError):
    discard ap['h'].getValue()

  doAssertRaises(BwapArgtypeError):
    discard ap['h'].getValues()

  doAssertRaises(BwapArgnameError):
    discard ap.newBoolArgs()

  doAssertRaises(BwapArgnameError):
    discard ap.newBoolArgs(shortName = 'h')

  doAssertRaises(BwapArgnameError):
    discard ap.newBoolArgs(longName = "help")

  #doAssertRaises(BwapArgnameError):
  #  discard ap.newBoolArgs(longName = "he")

  doAssertRaises(BwapArgnameError):
    discard ap.newBoolArgs(longName = "he=")

  doAssertRaises(BwapChoicesError):
    discard ap.newOptionalValuedArgs(shortName = 'o', longName = "optional-value", argChoices = ["a", "b", "c"], defaultArg = "e")

  discard ap.newOptionalValuedArgs(shortName = 'o', longName = "optional-value", argChoices = ["a", "b", "c", ""])
  ap.parseOptsSeq(@[])
  ap.parseOptsSeq(@["-o", "a"])
  ap.parseOptsSeq(@["-o", "a"])
  ap.parseOptsSeq(@["-o", "c"])
  ap.parseOptsSeq(@[])

  doAssertRaises(BwapChoicesError):
    discard ap.newOptionalValuedArgs(shortName = 'v', longName = "value", argChoices = ["a", "b", "c"], defaultArg = "e", mostArgs = 1)

  discard ap.newRequiredValuedArgs(shortName = 'v', longName = "value", argChoices = ["a", "b", "c"], mostArgs = 1)

  doAssertRaises(BwapChoicesError):
    ap.parseOptsSeq(@["--value", "e"])

  #ap.parseOptsSeq(@[])
  #echo "OOP"
  #ap.parseOptsSeq(@[])
  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@[])
  #echo "OOP"

  ap.parseOptsSeq(@["--value", "c"])
  ap.parseOptsSeq(@[])

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@["--value", "e"])

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@["--value", "c"])

  doAssertRaises(BwapRangeError):
    discard ap.newOptionalValuedListArgs(longName = "optionalList", argChoices = ["a", "b", "c"], defaultArgs = ["a", "b"], mostArgs = 1)

  doAssertRaises(BwapChoicesError):
    discard ap.newOptionalValuedListArgs( longName = "optionalList", argChoices = ["a", "b", "c"], defaultArgs = ["e"] )

  discard ap.newOptionalValuedListArgs( longName = "optionalList", argChoices = ["a", "b", "c"], defaultArgs = ["a"] )
  ap.parseOptsSeq(@[])
  ap.parseOptsSeq(@["--optionalList", "a"])
  ap.parseOptsSeq(@["--optionalList", "a"])
  ap.parseOptsSeq(@["--optionalList", "c"])
  ap.parseOptsSeq(@[])

  doAssertRaises(BwapChoicesError):
    ap.parseOptsSeq(@["--optionalList", "e"])

  doAssertRaises(BwapLookupError):
    ap.parseOptsSeq(@["--optionallist", "e"])

  doAssertRaises(BwapLookupError):
    ap.parseOptsSeq(@["--optional-list", "e"])

  doAssertRaises(BwapRangeError):
    discard ap.newOptionalValuedListArgs(shortName = 'l', longName = "value-list", argChoices = ["a", "b", "c"], defaultArgs = ["a", "b"], mostArgs = 1)

  doAssertRaises(BwapChoicesError):
    discard ap.newOptionalValuedListArgs(shortName = 'l', longName = "value-list", argChoices = ["a", "b", "c"], defaultArgs = ["e"], mostArgs = 1)

  discard ap.newRequiredValuedListArgs(shortName = 'l', longName = "value-list", argChoices = ["a", "b", "c"], mostArgs = 1)

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@[])

  doAssertRaises(BwapChoicesError):
    ap.parseOptsSeq(@["--value-list", "d"])

  ap.parseOptsSeq(@["--value-list", "c"])
  ap.parseOptsSeq(@[])

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@["--value-list", "c"])

  discard ap.newOptionalValuedListArgs(shortName = 'a', longName = "any")

  doAssertRaises(BwapUsageError):
    ap.parseOptsSeq(@["-abcd"])

  doAssertRaises(BwapUsageError):
    ap.parseOptsSeq(@["-ab"])

  ap.parseOptsSeq(@["-a", "-b"])

  ap.parseOptsSeq(@["-a", "-"])

  ap.parseOptsSeq(@["--any", "--optional-list"])

  ap.parseOptsSeq(@["--any", ""])

  doAssertRaises(BwapLookupError):
    ap.parseOptsSeq(@["--", "asdf"])
  doAssertRaises(BwapLookupError):
    ap.parseOptsSeq(@["---", "asdf"])
  doAssertRaises(BwapLookupError):
    ap.parseOptsSeq(@["--a", "asdf"])
  doAssertRaises(BwapUsageError):
    ap.parseOptsSeq(@["--help=--any"])
  doAssertRaises(BwapLookupError):
    ap.parseOptsSeq(@["--asdf", "asdf"])
  doAssertRaises(BwapLookupError):
    ap.parseOptsSeq(@["--asdf=asdf"])

  ap.parseOptsSeq(@["--any=--help"])
  ap.parseOptsSeq(@["--any", "--"])
  ap.parseOptsSeq(@["--any=--"])

  doAssertRaises(BwapUsageError):
    ap.parseOptsSeq(@["--any"])

  doAssertRaises(BwapArgtypeError):
    discard ap['o'].getValues()

  doAssertRaises(BwapArgtypeError):
    discard ap["value"].getValues()

  doAssertRaises(BwapArgtypeError):
    discard ap["optionalList"].getValue()

  doAssertRaises(BwapArgtypeError):
    discard ap['l'].getValue()

  doAssertRaises(BwapArgtypeError):
    discard ap['a'].getValue()

  assert(ap['o'].getValue() == "c")
  assert( ap['o'].getIsSet() )
  assert(ap['o'].getNumValues() == 3)

  assert(ap["value"].getValue == "c")
  assert( ap["value"].getIsSet() )
  assert(ap["value"].getNumValues() == 1)

  assert(ap["optionalList"].getValues() == @["a", "a", "c"])
  assert( ap["optionalList"].getIsSet() )
  assert(ap["optionalList"].getNumValues() == 3)

  assert(ap['a'].getValues() == @["-b", "-", "--optional-list", "", "--help", "--", "--"])
  assert( ap['a'].getIsSet() )
  assert(ap['a'].getNumValues() == 7)

  assert(ap['l'].getValues() == @["c"])
  assert( ap['l'].getIsSet() )
  assert(ap['l'].getNumValues() == 1)

  discard ap.newBoolArgs(longName = "bool", shortName = 'b')

  doAssertRaises(BwapArgtypeError):
    discard ap['b'].getValue()

  doAssertRaises(BwapArgtypeError):
    discard ap["bool"].getValues()

  assert(ap.getPositionalArgs().getValues() == @[])
  assert( not ap.getPositionalArgs().getIsSet() )
  assert( ap.getPositionalArgs().getNumValues() == 0 )

  assert( not ap['b'].getIsSet() )
  assert( ap['b'].getNumValues() == 0 )

#  doAssertRaises(BwapRangeError):
#	ap.parseOptsSeq(@["-bb", "asd", "a", "a"])
#
  ap.parseOptsSeq(@["-bb", "asd"])

  assert( ap['b'].getIsSet() )
  assert(ap['b'].getNumValues() == 2)

  assert(ap.getPositionalArgs().getValues() == @["asd"])
  assert( ap.getPositionalArgs().getIsSet() )
  assert( ap.getPositionalArgs().getNumValues() == 1 )

  ap.parseOptsSeq(@["a"])

  assert(ap.getPositionalArgs().getValues() == @["asd", "a"])
  assert( ap.getPositionalArgs().getIsSet() )
  assert( ap.getPositionalArgs().getNumValues() == 2 )

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@["c"])

  assert(ap.getPositionalArgs().getValues() == @["asd", "a"])
  assert( ap.getPositionalArgs().getIsSet() )
  assert( ap.getPositionalArgs().getNumValues() == 2 )

  let cmdOne = ap.newSubCommand("cmd1", "Subcommand 1", isRecursible = true)

  let cmdTwo = cmdOne.newSubCommand("cmd2", "Subcommand 1", isRecursible = true)

  let cmdOneAny = cmdOne.newOptionalValuedListArgs(shortName = 'a', longName = "anysub")

  assert( cast[pointer](cmdOneAny) == cast[pointer](cmdOne["anysub"]) )

  let cmdTwoPos = cmdTwo.newRequiredPositionalArgs(mostArgs = 1)

  assert( cast[pointer](cmdTwoPos) == cast[pointer]( cmdTwo.getPositionalArgs() ) )

  assert(ap.lookupSubCommands("cmd1") == cmdOne)
  assert(ap.lookupSubCommands("cmd1").lookupSubCommands("cmd2") == cmdTwo)

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@["cmd"])

  doAssertRaises(BwapSubCommandLookupError):
    discard ap.lookupSubCommands("asdf")

  doAssertRaises(BwapRangeError):
    discard cmdOne.newSubCommand("badcmd", leastUses = 5, mostUses = 1, isRecursible = true)

  doAssertRaises(BwapSubCommandNameError):
    discard ap.newSubCommand("cmd1", isRecursible = true)

  assert(ap.getSubCommandsList().len() == 0)

  ap.parseOptsSeq(@["cmd1"])

  assert(ap.getSubCommandsList().len() == 1)

  #doAssertRaises(BwapLookupError):
  #  ap.parseOptsSeq(@["--any", "asdf"])

  #doAssertRaises(BwapNoPositionalArgsError):
  #  ap.parseOptsSeq(@["asdf"])

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@["--anysub", "asdf", "cmd2", "asdfg", "asdf"])

  let scList = ap.getSubCommandsList()
  let scListTwo = scList[0].getSubCommandsList()

  assert(scList[0]['a'].getValues() == @["asdf"])
  assert( scList[0]['a'].getIsSet() )
  assert(scList[0]['a'].getNumValues() == 1)
  assert( cast[pointer](scList[0]) != cast[pointer](cmdOne) )
  assert( cast[pointer](scList[0]['a']) != cast[pointer](cmdOneAny) )

  assert(scListTwo[0].getPositionalArgs().getValues() == @["asdfg"])
  assert( scListTwo[0].getPositionalArgs().getIsSet() )
  assert(scListTwo[0].getPositionalArgs().getNumValues() == 1)
  assert( cast[pointer](scListTwo[0]) != cast[pointer](cmdTwo) )
  assert( cast[pointer]( scListTwo[0].getPositionalArgs() ) != cast[pointer](cmdTwoPos) )

  assert(scList.len() == 1)
  assert(scListTwo.len() == 1)
  assert(scListTwo[0].getSubCommandsList().len() == 0)

  ap.parseOptsSeq(@[])

  let cmdThree = ap.newSubCommand("cmd3", "Subcommand 3", leastUses = 1, mostUses = 2, isRecursible = true)
  let cmdThreePos = cmdThree.newRequiredPositionalArgs()

  assert(ap.getSubCommandsList().len() == 1)
  assert(ap.getSubCommandsList()[0].getSubCommandsList().len() == 1)
  assert(ap.getSubCommandsList()[0].getSubCommandsList()[0].getSubCommandsList().len() == 0)
  #assert(ap.getSubCommandsList()[0].getSubCommandsList()[0].getSubCommandsList()[0].getSubCommandsList().len() == 0)

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@[])

  var tmpScList = ap.getSubCommandsList()

  assert(tmpScList.len() == 1)

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@["cmd3"])

  tmpScList = ap.getSubCommandsList()
  assert(tmpScList.len() == 2)

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@[])

  assert(ap.getSubCommandsList().len() == 2)
  assert(ap.getSubCommandsList()[0].getSubCommandsList().len() == 1)
  assert(ap.getSubCommandsList()[0].getSubCommandsList()[0].getSubCommandsList().len() == 0)
  assert(ap.getSubCommandsList()[1].getSubCommandsList().len() == 0)

  #let cmdThreePos = cmdThree.newRequiredPositionalArgs()
  #doAssertRaises(BwapRangeError):
  #  ap.parseOptsSeq(@[])

  ap.parseOptsSeq(@["qwerp", "q", "cmd1", "--anysub", "asdf", "--anysub", "qpa", "-b", "-b"])

  let nextScList = ap.getSubCommandsList()
  let nextScListTwo = nextScList[0].getSubCommandsList()

  assert(nextScList.len() == 3)

  #echo nextScList[0]['a'].getValues()
  assert(nextScList[0]['a'].getValues() == @["asdf"])
  assert( nextScList[0]['a'].getIsSet() )
  assert(nextScList[0]['a'].getNumValues() == 1)
  assert( cast[pointer](nextScList[0]) != cast[pointer](cmdOne) )
  assert( cast[pointer](nextScList[0]['a']) != cast[pointer](cmdOneAny) )
  assert( cast[pointer](nextScList[0]) != cast[pointer](scList[0]) )
  assert( cast[pointer](nextScList[0]['a']) != cast[pointer](scList[0]['a']) )

  assert(nextScListTwo[0].getPositionalArgs().getValues() == @["asdfg"])
  assert( nextScListTwo[0].getPositionalArgs().getIsSet() )
  assert(nextScListTwo[0].getPositionalArgs().getNumValues() == 1)
  assert( cast[pointer](nextScListTwo[0]) != cast[pointer](cmdTwo) )
  assert( cast[pointer](nextScListTwo[0].getPositionalArgs()) != cast[pointer](cmdTwoPos) )
  assert( cast[pointer](nextScListTwo[0]) != cast[pointer](scList[0]) )
  assert( cast[pointer]( nextScListTwo[0].getPositionalArgs() ) != cast[pointer]( scListTwo[0].getPositionalArgs() ) )

  assert(nextScList[1].getPositionalArgs().getValues() == @["qwerp", "q"])
  assert( nextScList[1].getPositionalArgs().getIsSet() )
  assert(nextScList[1].getPositionalArgs().getNumValues() == 2)
  assert( cast[pointer](nextScList[1]) != cast[pointer](cmdThree) )
  assert( cast[pointer]( nextScList[1].getPositionalArgs() ) != cast[pointer](cmdThreePos) )

  assert(nextScList[2]['a'].getValues() == @["asdf", "qpa"])
  assert( nextScList[2]["anysub"].getIsSet() )
  assert(nextScList[2]["anysub"].getNumValues() == 2)
  assert( cast[pointer](nextScList[2]) != cast[pointer](cmdOne) )
  assert( cast[pointer]( nextScList[2]['a'] ) != cast[pointer](cmdOneAny) )

 # assert(scList[0] != scListTwo[0])
 # assert(scList[0][0] != scListTwo[0][0])
 # assert(scList[1] != scListTwo[1])

  assert( ap['b'].getIsSet() )
  assert(ap['b'].getNumValues() == 4)

  ap.parseOptsSeq(@["-h"])
  #assertEmptyPositionalArgs(ap)
  assert(ap['h'].getNumValues() == 1)
  assert(ap['h'].getIsSet() == true)

  ap.parseOptsSeq(@["--help"])
  #assertEmptyPositionalArgs(ap)
  assert(ap['h'].getNumValues() == 2)
  assert(ap['h'].getIsSet() == true)

  ap.parseOptsSeq(@["--help"])
  #assertEmptyPositionalArgs(ap)
  assert(ap['h'].getNumValues() == 3)
  assert(ap['h'].getIsSet() == true)

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@["--help"])

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@["NoRecurseCmd"])

  let noRecurseCmd = ap.newSubCommand("NoRecurseCmd", "Subcommand 1", leastSubCommands = 1, mostSubCommands = 1)
  let noRecurseCmdChil = noRecurseCmd.newSubCommand("chil", "Subcommand 1", isRecursible = true)

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@["norecursecmd"])

  ap.parseOptsSeq(@[])

  tmpScList = ap.getSubCommandsList()
  assert(tmpScList.len() == 3)

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@["NoRecurseCmd"])

  tmpScList = ap.getSubCommandsList()
  assert(tmpScList.len() == 4)
  assert( cast[pointer](tmpScList[3]) != cast[pointer](noRecurseCmd) )

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@["--bool"])

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@["-b"])

  doAssertRaises(BwapRangeError):
    ap.parseOptsSeq(@[])

  ap.parseOptsSeq(@["chil"])
  tmpScList = ap.getSubCommandsList()
  assert(tmpScList[3].getSubCommandsList()[0].getSubCommandsList.len() == 0)
  assert(tmpScList[3].getSubCommandsList().len() == 1)
  assert( cast[pointer]( tmpScList[3].getSubCommandsList()[0] ) != cast[pointer](noRecurseCmdChil) )

  doAssertRaises(BwapLookupError):
    ap.parseOptsSeq(@["--bool"])

  doAssertRaises(BwapLookupError):
    ap.parseOptsSeq(@["-b"])

  echo( ap.getArgsParserFullInfo() )


  #TODO: Subcommands
  #TODO: Range error if subcommand is not found.
  #TODO: Two nestings, some opts

when isMainModule:
  #setSamplingFrequency(100)
  testErrors()
