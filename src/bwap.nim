#TODO: Find all &
#TODO: Raise multiple exceptions at once?
#TODO: Collapse container types
#TODO: New constructors, not naked objects
#TODO: Locking levels
#TODO: Compile time asserts to ensure we have at least one opt name
#TODO: Control repeatability of args
#TODO: Subcommands, make sure multiple sub commands can be run at once
#TODO: [] overload
#TODO: Rewrite isRequired
#TODO: Make sure no more function and variable names conflict
#TODO: Rewrite/alias commands
#TODO: addSubCommand, getSubCommandsList, incorporate into parser
#TODO: Fix all initializers
#TODO: More methods to block off with assert(false)
#TODO: Entire lists as options for ValuedListArgs
#TODO: Reimplement recursive functions
#TODO: Better exception types
#TODO: List choices for valued list
#TODO: Editable delimiters
#TODO: Format helptext.
#TODO: Reformat ArgsParser self-ref (apCtx and apUsedCtx) to allow ARC collector.
#TODO: Test for constructors.
#TODO: Extend, as in arbitrary arguments after flag, as opposed to one after each flag. Seems like something ideally handled by delimiters, though. Don't need every stupid feature everyone else has.

#type BwapError* = object of CatchableError
#type BwapChoicesError* = object of BwapError
#type BwapRangeError* = object of BwapError
#type BwapArgnameError* = object of BwapError
#type BwapReinitError* = object of BwapError
#type BwapUninitError* = object of BwapError
#type BwapLookupError* = object of BwapError
#type BwapUsageError* = object of BwapError
#type BwapArgtypeError* = object of BwapError
#type BwapSubCommandNameError* = object of BwapError
#type BwapSubCommandLookupError* = object of BwapError
#type BwapNoPositionalArgsError* = object of BwapError
#type AnyArgs* = ref object of RootObj
#type BoolArgs* = ref object of AnyArgs
#type HelpArgs* = ref object of BoolArgs
#type ValuedArgs* = ref object of AnyValuedArgs
#type ValuedListArgs* = ref object of AnyValuedArgs
#type ArgsParser* = ref object of RootObj
#type SubCommand* = ref object of ArgsParser
#proc getPositionalArgs*(ap: ArgsParser): ValuedListArgs =
#proc getShortName*(ap: ArgsParser; name: char): AnyArgs =
#proc `[]`*(ap: ArgsParser; name: char): AnyArgs =
#proc getLongName*(ap: ArgsParser; name: string): AnyArgs =
#proc `[]`*(ap: ArgsParser; name: string): AnyArgs =
#proc getSubCommandsList*(ap: ArgsParser): seq[ArgsParser] =
#proc lookupSubCommands*(ap: ArgsParser; name: string): ArgsParser =
#proc newArgsParser*( exeName: string; helpText: string = ""; leastSubCommands: Natural = 0; mostSubCommands: Natural = high(Natural) ): ArgsParser =
#proc newSubCommand*( ap: ArgsParser; exeName: string; helpText: string = ""; leastUses = 0; mostUses = high(Positive); isRecursible: bool = false; leastSubCommands: Natural = 0; mostSubCommands: Natural = high(Natural) ): SubCommand =
#proc getExeName*(ap: ArgsParser): string =
#proc getArgsName*(a: AnyArgs): string =
#proc getNumValues*(a: AnyArgs): Natural =
#proc getIsSet*(a: AnyArgs): bool =
#method getValues*(a: AnyArgs): seq[string] {.base.} =
#method getValue*(a: AnyArgs): string {.base.} =
#proc newBoolArgs*( ap: ArgsParser; longName: string = ""; shortName: char = '\0'; helpText: string = ""; leastArgs: Natural = 0; mostArgs: Positive = high(Positive) ): BoolArgs =
#proc newHelpArgs*( ap: ArgsParser; longName: string = ""; shortName: char = '\0'; helpText: string = ""; leastArgs: Natural = 0; mostArgs: Positive = high(Positive) ): HelpArgs =
#method getValue*(a: ValuedArgs): string =
#proc newRequiredValuedArgs*(ap: ArgsParser;
#                            longName: string = "";
#                            shortName: char = '\0';
#                            helpText: string = "";
#                            argChoices: openArray[string] = [];
#                            leastArgs: Positive = 1;
#                            mostArgs: Positive = high(Positive)
#                           ): ValuedArgs =
#proc newOptionalValuedArgs*(ap: ArgsParser;
#                            longName: string = "";
#                            shortName: char = '\0';
#                            helpText, defaultArg: string = "";
#                            argChoices: openArray[string] = [];
#                            mostArgs: Positive = high(Positive)
#                           ): ValuedArgs =
#method getValues*(a: ValuedListArgs): seq[string] =
#proc newOptionalValuedListArgs*(ap: ArgsParser;
#                                longName: string = "";
#                                shortName: char = '\0';
#                                helpText: string = "";
#                                defaultArgs, argChoices: openArray[string] = [];
#                                mostArgs: Positive = Positive.high()
#                               ): ValuedListArgs =
#proc newRequiredValuedListArgs*(ap: ArgsParser;
#                                longName: string = "";
#                                shortName: char = '\0';
#                                helpText: string = "";
#                                argChoices: openArray[string] = [];
#                                leastArgs: Positive = 1;
#                                mostArgs: Positive = Positive.high()
#                               ): ValuedListArgs =
#proc newOptionalPositionalArgs*(ap: ArgsParser;
#                                helpText: string = "";
#                                defaultArgs, argChoices: openArray[string] = [];
#                                mostArgs: Positive = Positive.high()
#                               ): ValuedListArgs =
#proc newRequiredPositionalArgs*(ap: ArgsParser;
#                                helpText: string = "";
#                                argChoices: openArray[string] = [];
#                                leastArgs: Positive = 1;
#                                mostArgs: Positive = Positive.high()
#                               ): ValuedListArgs =
#proc addArgsMutex*(ap: ArgsParser; a, b: string) =
#proc addPositionalArgsMutex*(ap: ArgsParser; a: string) =
#proc getArgsParserStatus*(ap: ArgsParser; indentTimes: Natural = 0; indentValue: string = "  "): string =
#proc getArgsParserDocumentation*(ap: ArgsParser; indentTimes: Natural = 0; indentValue: string = "  "): string =
#proc getArgsParserFullInfo*(ap: ArgsParser; indentTimes: Natural = 0; indentValue: string = "  "): string =
#proc parseOptsSeq*(ap: ArgsParser; args: seq[string]) =

# Imports
from sets import OrderedSet, len, items, contains, init, incl
from strutils import replace, join, repeat, toUpperAscii, split
from tables import OrderedTable, contains, `[]`, initOrderedTable, `[]=`, values, pairs, len
from sequtils import toSeq, zip
from algorithm import reversed
# End imports

# Exceptions
# TODO: MOre consistent capitalization of compound words?
type BwapError* = object of CatchableError
type BwapChoicesError* = object of BwapError
type BwapRangeError* = object of BwapError
type BwapArgnameError* = object of BwapError
type BwapReinitError* = object of BwapError
type BwapUninitError* = object of BwapError
type BwapLookupError* = object of BwapError
type BwapUsageError* = object of BwapError
type BwapArgtypeError* = object of BwapError
type BwapSubCommandNameError* = object of BwapError
type BwapSubCommandLookupError* = object of BwapError
type BwapNoPositionalArgsError* = object of BwapError

template newBwapException(parserName: string; exceptn: typedesc; message: string): untyped =
  newException(exceptn, "'" & parserName & "' : " & message)
# End exceptions

# Helpers
# TODO: prettify this
proc renderIterableToString[T](i: T; startCap, startItem, sep, endItem, endCap, replaceIn, replaceOut: string; writeEmpty: bool): string =
  var needSep = false
  result = startCap
  for v in i:
    let toWrite = ($v).replace(replaceIn, replaceOut)
    if writeEmpty or toWrite != "":
      if needSep:
        result &= sep
        needSep = false
      result &= startItem & toWrite & endItem
      needSep = true
  result &= endCap

proc renderStringIterable[T](i: T): string =
  renderIterableToString(i, "[", "\"", ", ", "\"", "]", "\"", "\\\"", true)
# End helpers

# ArgsParser type and methods
type AnyArgs* = ref object of RootObj
  longName: string
  shortName: char
  helpText: string
  parentName: string
  leastArgs: Natural
  mostArgs: Positive
  numArgs: Natural

type BoolArgs* = ref object of AnyArgs

type HelpArgs* = ref object of BoolArgs

type AnyValuedArgs = ref object of AnyArgs
  choices: OrderedSet[string]

type ValuedArgs* = ref object of AnyValuedArgs
  value: string
  defaultValue: string

type ValuedListArgs* = ref object of AnyValuedArgs
  valuesList: seq[string]
  defaultValues: seq[string]

type ArgsParser* = ref object of RootObj
  subCommandsLookup: OrderedTable[string, ArgsParser] #TODO: Should this be SubCommand
  subCommandsList: seq[ArgsParser] #TODO: Should this be SubCommand
  subCommandsUses: OrderedTable[string, Natural] #TODO: Should this be SubCommand
  leastSubCommands: Natural
  mostSubCommands: Natural
  shortLookup: OrderedTable[char, AnyArgs]
  longLookup: OrderedTable[string, AnyArgs]
  allArgs: seq[AnyArgs]
  positionalArgs: ValuedListArgs
  positionalArgsInited: bool
  helpArgsInited: bool
  helpText: string
  exeName: string
  # CTX INFO
  expectingValue: bool
  expectingArg: AnyArgs
  apCtx: ArgsParser
  apStack: seq[ArgsParser]
  usedApCtx: ArgsParser
  apStackIdx: int

type SubCommand* = ref object of ArgsParser
  parent: ArgsParser
  leastUses: Natural
  mostUses: Positive
  isRecursible: bool

## Exported
proc getExeName*(ap: ArgsParser): string =
  result = ap.exeName

method getIsRecursible(ap: ArgsParser): bool {.base.} =
  result = true

method getIsRecursible(ap: SubCommand): bool =
  result = ap.isRecursible

proc hasOpts(ap: ArgsParser): bool =
  result = ap.allArgs.len() > 0

method getArgsParserName(ap: ArgsParser): string {.base.} =
  result = ap.exeName.replace(" ", "\\ ")

method getParentArgsParser(ap: ArgsParser): ArgsParser {.base.} =
  result = ap

method getParentArgsParser(ap: SubCommand): ArgsParser =
  result = ap.parent

method getArgsParserName(ap: SubCommand): string =
  result = ""
  var names: seq[string] = @[] #TODO: Avoid seq
  var c: ArgsParser = ap
  while c of SubCommand:
    names.add( c.exeName.replace(" ", "\\ ") )
    c = c.getParentArgsParser()
  names.add( c.exeName.replace(" ", "\\ ") )
  result = names.reversed().join(" ")

proc renderRange(least: Natural; most: Positive): string =
  var mostStr = "MAX"
  if most != Positive.high():
    mostStr = $most
  if most == least:
    result = mostStr
  else:
    result = $least & " - " & mostStr & " (inclusive)"
    #TODO: Values/value/value(s)

method getUsesRange(ap: ArgsParser): string {.base.} =
  assert(false)
  result = renderRange( 0, Positive.high() )

method getUsesRange(ap: SubCommand): string =
  result = renderRange(ap.leastUses, ap.mostUses)

## Exported
proc getPositionalArgs*(ap: ArgsParser): ValuedListArgs =
  if not ap.positionalArgsInited:
    raise newBwapException(ap.getArgsParserName(), BwapUninitError, "Argparser positional args are not set.")
  result = ap.positionalArgs

## Exported
proc getShortName*(ap: ArgsParser; name: char): AnyArgs =
  if not ap.shortLookup.contains(name):
    raise newBwapException(ap.getArgsParserName(), BwapLookupError, "Argparser does not contain short argument of '" & $name & "'.")
  result = ap.shortLookup[name]

## Exported
proc `[]`*(ap: ArgsParser; name: char): AnyArgs =
  result = ap.getShortName(name)

## Exported
proc getLongName*(ap: ArgsParser; name: string): AnyArgs =
  if not ap.longLookup.contains(name):
    raise newBwapException(ap.getArgsParserName(), BwapLookupError, "Argparser does not contain long argument of '" & name & "'.")
  result = ap.longLookup[name]

## Exported
proc `[]`*(ap: ArgsParser; name: string): AnyArgs =
  result = ap.getLongName(name)

## Exported
proc getSubCommandsList*(ap: ArgsParser): seq[ArgsParser] =
  result = deepCopy(ap.subCommandsList)

## Exported
proc lookupSubCommands*(ap: ArgsParser; name: string): ArgsParser =
  if not ap.subCommandsLookup.contains(name):
    raise newBwapException(ap.getArgsParserName(), BwapSubCommandLookupError, "Argparser does not contain sub command named '" & name & "'.")
  result = ap.subCommandsLookup[name]
  assert(result of SubCommand)

proc initArgsParser(ap: ArgsParser; exeName, helpText: string; leastSubCommands: Natural; mostSubCommands: Natural) =
  #TODO: Why in the actual motherfuck does this need to be its own function?
  ap.subCommandsLookup = initOrderedTable[string, ArgsParser]()
  ap.subCommandsList = @[]
  ap.subCommandsUses = initOrderedTable[string, Natural]()
  if exeName == "":
    #TODO: New exception.
    raise newBwapException( ap.getArgsParserName(), BwapSubCommandNameError, "The name of a command cannot be empty.")
  ap.exeName = exeName
  if leastSubCommands > mostSubCommands:
    raise newBwapException( ap.getArgsParserName(), BwapRangeError, "The specified minimum number of subCommands for " & ap.exeName & " of " & $leastSubCommands & " is less than the maximum of " & $mostSubCommands & ".")
  ap.leastSubCommands = leastSubCommands
  ap.mostSubCommands = mostSubCommands
  ap.shortLookup = initOrderedTable[char, AnyArgs]()
  ap.longLookup = initOrderedTable[string, AnyArgs]()
  ap.allArgs = @[]
  ap.positionalArgsInited = false
  ap.helpArgsInited = false
  ap.helpText = helpText
  ap.expectingValue = false
  ap.apCtx = ap
  ap.apStack = @[]
  ap.usedApCtx = ap
  ap.apStackIdx = 0

## Exported
proc newArgsParser*( exeName: string; helpText: string = ""; leastSubCommands: Natural = 0; mostSubCommands: Natural = high(Natural) ): ArgsParser =
  result = new(ArgsParser)
  initArgsParser(result, exeName, helpText, leastSubCommands, mostSubCommands)

proc addSubCommand(ap: ArgsParser; sc: SubCommand) =
  if ap.subCommandsLookup.contains(sc.exeName):
    raise newBwapException(ap.getArgsParserName(), BwapSubCommandNameError, "The argparser already contains a subcommand named '" & sc.exeName & "'.")
  ap.subCommandsLookup[sc.exeName] = sc
  ap.subCommandsUses[sc.exeName] = 0

## Exported
proc newSubCommand*( ap: ArgsParser; exeName: string; helpText: string = ""; leastUses = 0; mostUses = high(Positive); isRecursible: bool = false; leastSubCommands: Natural = 0; mostSubCommands: Natural = high(Natural) ): SubCommand =
  result = new(SubCommand)
  initArgsParser(result, exeName, helpText, leastSubCommands, mostSubCommands)
  result.parent = ap
  if leastUses > mostUses:
    raise newBwapException( result.getArgsParserName(), BwapRangeError, "The specified minimum number of values for " & result.exeName & " of " & $leastUses & " is less than the maximum of " & $mostUses & ".")
  result.leastUses = leastUses
  result.mostUses = mostUses
  result.isRecursible = isRecursible
  ap.addSubCommand(result)

proc addArg(ap: ArgsParser; a: AnyArgs) =
  if a.shortName == '\0' and a.longName == "":
    raise newBwapException(ap.getArgsParserName(), BwapArgnameError, "A non-positional argument may not be nameless.")
  if a.shortName != '\0':
    if ap.shortLookup.contains(a.shortName):
      raise newBwapException(ap.getArgsParserName(), BwapArgnameError, "The argparser already contains an argument with the short-name of '" & $a.shortName & "'.")
    ap.shortLookup[a.shortName] = a
  if a.longName != "":
    if ap.longLookup.contains(a.longName):
      raise newBwapException(ap.getArgsParserName(), BwapArgnameError, "The argparser already contains an argument with the long-name of '" & a.longName & "'.")
    ap.longLookup[a.longName] = a
  if not ap.allArgs.contains(a):
    ap.allArgs.add(a)
# End ArgsParser type and methods

# AnyArgs, base type.
## Exported
proc getNumValues*(a: AnyArgs): Natural =
  result = a.numArgs

proc getIsRequired(a: AnyArgs): bool =
  result = a.leastArgs > 0

proc isValueInRange(least, v, most: Natural): bool =
  result = least <= v and v <= most

proc isValueInRange(a: AnyArgs; v: Natural): bool =
  result = isValueInRange(a.leastArgs, v, a.mostArgs)
  #result = a.leastArgs <= v and v <= a.mostArgs

proc isAnotherValueInRange(a: AnyArgs): bool =
  result = isValueInRange(a, a.getNumValues() + 1)

proc getChoicesRange(a: AnyArgs): string =
  result = renderRange(a.leastArgs, a.mostArgs)

proc getArgsName*(a: AnyArgs): string =
  result = ""
  if a.longName != "":
    result &= "--" & a.longName
    if a.shortName != '\0': #TODO: Readable macro for shortName
      result &= "/-" & $a.shortName
  elif a.shortName != '\0': #TODO: Readable macro for shortName
    result &= "-" & $a.shortName
  else:
    result &= "POSITIONAL"

proc ensureRangeSatisfied(a: AnyArgs) =
  if not isValueInRange( a, a.getNumValues() ):
    raise newBwapException(a.parentName, BwapRangeError, a.getArgsName() & " has only " & $a.getNumValues() & " specified, but the requirement is " & a.getChoicesRange() )

proc getArgTypeRequiredString(a: AnyArgs): string =
  result = "OPTIONAL"
  if a.getIsRequired():
    result = "REQUIRED"

method getArgTypeNameString(a: AnyArgs): string {.base.} =
  result = "GENERIC ARG"

proc getArgTypeString(a: AnyArgs): string =
  result = a.getArgTypeRequiredString() & " " & a.getArgTypeNameString()

proc getArgHelpText(a: AnyArgs; indent: string): string =
  result = ""
  if a.helpText != "":
    result = "\p" & indent & a.helpText

method getArgHelp(a: AnyArgs; indent: string): string {.base.} =
  result = indent & a.getArgsName() & " (" & a.getArgTypeString() & ")" &
           a.getArgHelpText(indent) &
           "\p" & indent & "Choices: " & a.getChoicesRange() & " values"

## Exported
proc getIsSet*(a: AnyArgs): bool =
  result = a.numArgs > 0

## Exported
method getValues*(a: AnyArgs): seq[string] {.base.} =
  raise newBwapException(a.parentName, BwapArgtypeError, "Only valued list args can have value lists retrieved from them. " & a.getArgsName() & " is not one of them.") #TODO: Explain type

## Exported
method getValue*(a: AnyArgs): string {.base.} =
  raise newBwapException(a.parentName, BwapArgtypeError, "Only valued args can have value strings retrieved from them. " & a.getArgsName() & " is not one of them.") #TODO: Explain type

method addValue(a: AnyArgs; v: string) {.base, locks: "unknown".} =
  assert(false)

proc initAnyArgs(a: AnyArgs; ap: ArgsParser; longName: string; shortName: char; helpText: string; leastArgs: Natural; mostArgs: Positive) =
  if longName.len() > 0 and longName.len() < 2:
    raise newBwapException(ap.getArgsParserName(), BwapArgnameError, "The long name of an argument must be 2 or more characters in length. '" & longName & "' was provided.")
  if '=' in longName:
    raise newBwapException(ap.getArgsParserName(), BwapArgnameError, "The long name of an argument must not contain '='. '" & longName & "' was provided.")
  a.longName = longName
  a.shortName = shortName
  if leastArgs > mostArgs:
    raise newBwapException( ap.getArgsParserName(), BwapRangeError, "The specified minimum number of values for " & $a.getArgsName() & " of " & $leastArgs & " is less than the maximum of " & $mostArgs & ".")
  a.helpText = helpText
  a.parentName = ap.getArgsParserName()
  a.leastArgs = leastArgs
  a.mostArgs = mostArgs
  a.numArgs = 0
# End AnyArgs, base type

# BoolArgs, child of AnyArgs
method addValue(a: BoolArgs; v: string) {.locks: "unknown".} =  #TODO: Should we have a special stringless method?
  assert(v == "")
  if not a.isAnotherValueInRange():
    raise newBwapException( a.parentName, BwapRangeError, "There are currently " & $a.getNumValues() & " choices for " & a.getArgsName() & " The value must remain " & a.getChoicesRange() )
  else:
    a.numArgs += 1

method getArgTypeNameString(a: BoolArgs): string =
  result = "FLAG"

## Exported
proc newBoolArgs*( ap: ArgsParser; longName: string = ""; shortName: char = '\0'; helpText: string = ""; leastArgs: Natural = 0; mostArgs: Positive = high(Positive) ): BoolArgs =
  result = new(BoolArgs)
  initAnyArgs(result, ap, longName, shortName, helpText, leastArgs, mostArgs)
  ap.addArg(result)
# End BoolArgs, child of AnyArgs

# HelpArgs, child of BoolArgs
method getArgTypeNameString(a: HelpArgs): string =
  result = "HELP"

## Exported
proc newHelpArgs*( ap: ArgsParser; longName: string = ""; shortName: char = '\0'; helpText: string = ""; leastArgs: Natural = 0; mostArgs: Positive = high(Positive) ): HelpArgs =
  result = new(HelpArgs)
  initAnyArgs(result, ap, longName, shortName, helpText, leastArgs, mostArgs)
  ap.addArg(result)
# End HelpArgs, child of BoolArgs

# AnyValuedArgs, child of AnyArgs
proc hasChoices(a: AnyValuedArgs): bool =
  result = a.choices.len() > 0

proc isValidChoice(a: AnyValuedArgs; v: string): bool =
  result = not (a.hasChoices() and v notin a.choices)

proc getChoices(a: AnyValuedArgs): string =
  result = "ANY"
  if a.hasChoices():
    result = renderStringIterable(a.choices)

method getArgTypeNameString(a: AnyValuedArgs): string =
  result = "GENERIC VALUED ARG"

method getDefaultText(a: AnyValuedArgs; indent: string): string {.base.} =
  result = ""

method getArgHelp(a: AnyValuedArgs; indent: string): string =
  result = indent & a.getArgsName() & " (" & a.getArgTypeString() & ")" &
           a.getArgHelpText(indent) &
           a.getDefaultText(indent) &
           "\p" & indent & "Choices: " & a.getChoices() & " (" & a.getChoicesRange() & " values)"

proc initChoices(a: AnyValuedArgs; argChoices: openArray[string]) =
  a.choices.init()
  for c in argChoices:
    a.choices.incl(c)

proc testDefaultArg(a: AnyValuedArgs; defaultArg: string) =
  if not a.isValidChoice(defaultArg):
    raise newBwapException( a.parentName, BwapChoicesError, "Default value of '" & defaultArg & "' is not a valid choice for " & a.getArgsName() & " Valid choices are: " & a.getChoices() )
# End AnyValuedArgs, child of AnyArgs

# ValuedArgs, child of AnyValuedArgs
method getArgTypeNameString(a: ValuedArgs): string =
  result = "VALUE"

method getDefaultText(a: ValuedArgs; indent: string): string =
  result = ""
  if not a.getIsRequired():
    result = "\p" & indent & "Default: \"" & a.defaultValue & "\""
  else:
    assert(a.defaultValue == "")

method addValue(a: ValuedArgs; v: string) {.locks: "unknown".} =
  #TODO: Refactor
  if not a.isAnotherValueInRange():
    raise newBwapException( a.parentName, BwapRangeError, "There are currently " & $a.getNumValues() & " choices for " & a.getArgsName() & " The value must remain " & a.getChoicesRange() )
  elif not a.isValidChoice(v):
    raise newBwapException( a.parentName, BwapChoicesError, "'" & v & "' is not a valid choice for " & a.getArgsName() & " Valid choices are: " & a.getChoices() )
  else:
    a.value = v
    a.numArgs += 1

## Exported
method getValue*(a: ValuedArgs): string =
  if a.getIsSet():
    result = a.value
  else:
    result = a.defaultValue

proc initValuedArgs(a: ValuedArgs;
                    ap: ArgsParser;
                    longName: string;
                    shortName: char;
                    helpText, defaultArg: string;
                    argChoices: openArray[string];
                    leastArgs: Natural;
                    mostArgs: Positive;
                   ) =
  initAnyArgs(a, ap, longName, shortName, helpText, leastArgs, mostArgs)
  a.initChoices(argChoices)
  #TODO: This has got to be a bug. Kludging it.
  #a.values.choices = toOrderedSet(argChoices)
  if not a.getIsRequired():
    a.testDefaultArg(defaultArg)
  else:
    assert(defaultArg == "")
  a.defaultValue = defaultArg

## Exported
proc newRequiredValuedArgs*(ap: ArgsParser;
                            longName: string = "";
                            shortName: char = '\0';
                            helpText: string = "";
                            argChoices: openArray[string] = [];
                            leastArgs: Positive = 1;
                            mostArgs: Positive = high(Positive)
                           ): ValuedArgs =
  result = new(ValuedArgs)
  initValuedArgs(result, ap, longName, shortName, helpText, "", argChoices, leastArgs, mostArgs)
  ap.addArg(result)

## Exported
proc newOptionalValuedArgs*(ap: ArgsParser;
                            longName: string = "";
                            shortName: char = '\0';
                            helpText, defaultArg: string = "";
                            argChoices: openArray[string] = [];
                            mostArgs: Positive = high(Positive)
                           ): ValuedArgs =
  result = new(ValuedArgs)
  initValuedArgs(result, ap, longName, shortName, helpText, defaultArg, argChoices, 0, mostArgs)
  ap.addArg(result)
# End ValuedArgs, child of AnyValuedArgs

# ValuedListArgs, child of AnyValuedArgs
proc getDefaultArgs(a: ValuedListArgs): string =
  result = renderStringIterable(a.defaultValues)

method getArgTypeNameString(a: ValuedListArgs): string =
  result = "LIST"

method getDefaultText(a: ValuedListArgs; indent: string): string =
  result = ""
  if not a.getIsRequired():
    result = "\p" & indent & "Default: " & a.getDefaultArgs()
  else:
    assert(a.defaultValues.len() == 0)

## Exported
method getValues*(a: ValuedListArgs): seq[string] =
  if a.getIsSet():
    result = a.valuesList
  else:
    result = a.defaultValues.toSeq()

#method getValue*(a: ValuedListArgs): string =
#  #TODO: Refactor
#  if a.getIsSet():
#    result = renderStringIterable(a.valuesList)
#  else:
#    result = renderStringIterable(a.defaultValues)

method addValue(a: ValuedListArgs; v: string) =
  if not a.isAnotherValueInRange():
    raise newBwapException( a.parentName, BwapRangeError, "There are currently " & $a.getNumValues() & " choices for " & a.getArgsName() & " The value must remain " & a.getChoicesRange() )
  elif not a.isValidChoice(v):
    raise newBwapException( a.parentName, BwapChoicesError, "'" & v & "' is not a valid choice for " & a.getArgsName() & " Valid choices are: " & a.getChoices() )
  else:
    a.valuesList.add(v)
    a.numArgs += 1

proc initValuedListArgs(a: ValuedListArgs;
                        ap: ArgsParser;
                        longName: string;
                        shortName: char;
                        helpText: string;
                        defaultArgs, argChoices: openArray[string];
                        leastArgs: Natural;
                        mostArgs: Positive
                       ) =
  initAnyArgs(a, ap, longName, shortName, helpText, leastArgs, mostArgs)
  a.valuesList = @[]
  #TODO: This has got to be a bug. Kludging it.
  #a.values.choices = toOrderedSet(argChoices)
  a.initChoices(argChoices)
  for da in defaultArgs:
    a.testDefaultArg(da)
  if not a.getIsRequired() and not a.isValueInRange( defaultArgs.len() ):
    raise newBwapException( ap.getArgsParserName(), BwapRangeError, "The number of specified default args " & renderStringIterable(defaultArgs) & " is " & $defaultArgs.len() & ". This does not fall in specified range of " & a.getChoicesRange() & "." )
  a.defaultValues = defaultArgs.toSeq()

## Exported
proc newOptionalValuedListArgs*(ap: ArgsParser;
                                longName: string = "";
                                shortName: char = '\0';
                                helpText: string = "";
                                defaultArgs, argChoices: openArray[string] = [];
                                mostArgs: Positive = Positive.high()
                               ): ValuedListArgs =
  result = new(ValuedListArgs)
  initValuedListArgs(result, ap, longName, shortName, helpText, defaultArgs, argChoices, 0, mostArgs)
  ap.addArg(result)

## Exported
proc newRequiredValuedListArgs*(ap: ArgsParser;
                                longName: string = "";
                                shortName: char = '\0';
                                helpText: string = "";
                                argChoices: openArray[string] = [];
                                leastArgs: Positive = 1;
                                mostArgs: Positive = Positive.high()
                               ): ValuedListArgs =
  result = new(ValuedListArgs)
  initValuedListArgs(result, ap, longName, shortName, helpText, [], argChoices, leastArgs, mostArgs)
  ap.addArg(result)

## Exported
proc newOptionalPositionalArgs*(ap: ArgsParser;
                                helpText: string = "";
                                defaultArgs, argChoices: openArray[string] = [];
                                mostArgs: Positive = Positive.high()
                               ): ValuedListArgs =
  if ap.positionalArgsInited:
    raise newBwapException(ap.getArgsParserName(), BwapReinitError, "The argparser's positional args can only be initialized once.")
  result = new(ValuedListArgs)
  initValuedListArgs(result, ap, "", '\0', helpText, defaultArgs, argChoices, 0, mostArgs)
  ap.positionalArgs = result
#  ap.positionalArgs = newOptionalValuedListArgs*(ap,
#												 "",
#												 '\0',
#												 helpText,
#												 defaultArgs,
#												 argChoices,
#												 mostArgs
#												)
  ap.positionalArgsInited = true

## Exported
proc newRequiredPositionalArgs*(ap: ArgsParser;
                                helpText: string = "";
                                argChoices: openArray[string] = [];
                                leastArgs: Positive = 1;
                                mostArgs: Positive = Positive.high()
                               ): ValuedListArgs =
  if ap.positionalArgsInited:
    raise newBwapException(ap.getArgsParserName(), BwapReinitError, "The argparser's positional args can only be initialized once.")
  result = new(ValuedListArgs)
  initValuedListArgs(result, ap, "", '\0', helpText, [], argChoices, leastArgs, mostArgs)
  ap.positionalArgs = result
#  ap.positionalArgs = newRequiredValuedListArgs*(ap,
#												 "",
#												 '\0',
#												 helpText,
#												 argChoices,
#												 leastArgs,
#												 mostArgs
#												)
  ap.positionalArgsInited = true
# End ValuedListArgs, child of AnyValuedListArgs

# ArgsParser
proc hasRequiredOpts(ap: ArgsParser): bool =
  #TODO: Roll this into a template
  result = false
  for a in ap.allArgs:
    if a.getIsRequired():
      result = true
      break

method isValueInRange(ap: ArgsParser; v: Natural): bool {.base.} =
  assert(false)
  result = true

method isValueInRange(ap: SubCommand; v: Natural): bool =
  result = isValueInRange(ap.leastUses, v, ap.mostUses)

#method getIsRequired(ap: ArgsParser): bool {.base.} =
#  assert(false)
#  result = false

#method getIsRequired(ap: SubCommand): bool =
#  result = ap.leastUses > 0

proc ensureAllRangesSatisfied(ap: ArgsParser; helpArgsInited: bool) =
  if not helpArgsInited:
    for a in ap.allArgs:
      a.ensureRangeSatisfied()
    if ap.positionalArgsInited:
      ap.positionalArgs.ensureRangeSatisfied()
    if not isValueInRange(ap.leastSubCommands, ap.subCommandsList.len(), ap.mostSubCommands):
      raise newBwapException( ap.getArgsParserName(), BwapRangeError, "Sub commands count of " & $ap.subCommandsList.len() & " for '" & ap.exeName & "' does not fall in the necessary range of " & renderRange(ap.leastSubCommands, ap.mostSubCommands) )
    for sc in ap.subCommandsLookup.values():
      if not sc.isValueInRange(ap.subCommandsUses[sc.exeName]): #TODO: Should I terate lookup instead?
        raise newBwapException( sc.getArgsParserName(), BwapRangeError, "Uses count of " & $ap.subCommandsUses[sc.exeName] & " for '" & sc.exeName & "' does not fall in the necessary range of " & sc.getUsesRange() )
  #var usageCounts = initOrderedTable[string, Natural]()
  #for sc in ap.subCommandsList:
  #  if not usageCounts.contains(ap.exeName):
  #    usageCounts[ap.exeName] = 1
  #  else:
  #    usageCounts[ap.exeName] += 1
  #  sc.ensureAllRangesSatisfied()
  for sc in ap.subCommandsList:
    sc.ensureAllRangesSatisfied(helpArgsInited)
  #for sc in ap.subCommandsLookup.values():
  #  if usageCounts.contains(sc.exeName):
  #    if not sc.isValueInRange(usageCounts[sc.exeName]):
  #      raise newBwapException( sc.getArgsParserName(), BwapRangeError, "Uses count of " & $usageCounts[sc.exeName] & " does not fall in the necessary range of " & sc.getUsesRange() )
  #  elif sc.getIsRequired():
  #    raise newBwapException( sc.getArgsParserName(), BwapRangeError, "Never used once, even though necessary uses range is " & sc.getUsesRange() )

proc getSubCommandsHelp(ap: ArgsParser): string =
  #TODO: How should this be organized?
  result = ""
  if ap.subCommandsLookup.len() > 0:
    var startCap = '['
    var name = "SUBCOMMAND"
    var endCap = ']'
    var endDots = ""
    for sc in ap.subCommandsLookup.values:
        if sc.isValueInRange(2):
          endDots = "..."
        if not sc.isValueInRange(0):
          startCap = '<'
          endCap = '>'
          break
    if ap.leastSubCommands > 0:
      startCap = '<'
      endCap = '>'
    if ap.subCommandsLookup.len() > 1:
      endDots = "..."
    result = $startCap & name & $endCap & endDots

proc getPositionalArgsHelp(ap: ArgsParser): string =
  result = ""
  if ap.positionalArgsInited:
    var startCap = '['
    var endCap = ']'
    var endDots = "..."
    #var helpText = ap.positionalArgs.helpText
    if ap.positionalArgs.getIsRequired():
      startCap = '<'
      endCap = '>'
    if ap.positionalArgs.mostArgs == 1:
      endDots = ""
    #if helpText == "":
    #  helpText = "POSITIONAL"
    result = $startCap & "POSITIONAL" & $endCap & endDots
    #result = $startCap & helpText & $endCap & endDots & $' (' & ap.positionalArgs.getChoicesRange() & $')'

proc getOptsHelp(ap: ArgsParser): string =
  result = ""
  if ap.hasOpts():
    var endDots = ""
    var startCap = '['
    var endCap = ']'
    if ap.allArgs.len() > 1:
      endDots = "..."
    if ap.hasRequiredOpts():
      startCap = '<'
      endCap = '>'
    result = startCap & "OPTION" & endCap & endDots

proc getArgsParserUsage(ap: ArgsParser): string =
  let outputItems = [ap.getArgsParserName(), ap.getSubCommandsHelp(), ap.getOptsHelp(), ap.getPositionalArgsHelp()]
  result = renderIterableToString(outputItems, "Usage: ", "", " ", "", "", "", "", false)

## Exported
proc getArgsParserStatus*(ap: ArgsParser; indentTimes: Natural = 0; indentValue: string = "  "): string =
  var indent = repeat(indentValue, indentTimes)
  result = ""
  var toRes = indent & ap.getArgsParserUsage() & "\p"
  var use = false
  indent &= indentValue
  if not isValueInRange(ap.leastSubCommands, ap.subCommandsList.len(), ap.mostSubCommands):
    toRes &= indent & "Error: Sub commands count of " & $ap.subCommandsList.len() & " for '" & ap.exeName & "' does not fall in the necessary range of " & renderRange(ap.leastSubCommands, ap.mostSubCommands) & "\p"
    use = true
  for sc in ap.subCommandsLookup.values():
    if not sc.isValueInRange(ap.subCommandsUses[sc.exeName]): #TODO: Should I terate lookup instead?
      toRes &= indent & $'\'' & sc.getArgsParserName() & "' error: Uses count of " & $ap.subCommandsUses[sc.exeName] & " for '" & sc.exeName & "' does not fall in the necessary range of " & sc.getUsesRange() & "\p"
      use = true
  if ap.positionalArgsInited:
    if ap.positionalArgs.getIsSet():
      toRes &= indent & ap.positionalArgs.getArgsName() & " set to " & renderStringIterable( ap.positionalArgs.getValues() ) & "\p"
      use = true
    try:
      ap.positionalArgs.ensureRangeSatisfied()
    except:
      toRes &= indent & ap.positionalArgs.getArgsName() & " error: " & getCurrentExceptionMsg() & "\p"
      use = true
  for a in ap.allArgs:
    var valueString: string
    if a of ValuedListArgs:
      valueString = renderStringIterable( a.getValues() )
    elif a of ValuedArgs:
      valueString = '"' & a.getValue().replace("\"", "\\\"") & '"'
    else:
      valueString = ( $a.getIsSet() ).toUpperAscii()
    toRes &= indent & a.getArgsName() & " set to " & valueString & "\p"
    use = true
    try:
      a.ensureRangeSatisfied()
    except:
      toRes &= indent & a.getArgsName() & " error: " & getCurrentExceptionMsg() & "\p"
      use = true
  for sc in ap.subCommandsList:
    let scRes = getArgsParserStatus(sc, indentTimes + 1, indentValue)
    if scRes != "":
      toRes &= "\p" & scRes
      use = true
  if use:
    result &= toRes

## Exported
proc getArgsParserDocumentation*(ap: ArgsParser; indentTimes: Natural = 0; indentValue: string = "  "): string =
  var indent = repeat(indentValue, indentTimes)
  result = indent & ap.getArgsParserUsage() & "\p" & indent & ap.helpText & "\p\p"
  indent &= indentValue
  if ap.positionalArgsInited:
    result &= ap.positionalArgs.getArgHelp(indent) & "\p\p"
  for a in ap.allArgs:
    result &= a.getArgHelp(indent) & "\p\p"
  for v in ap.subCommandsLookup.values:
    result &= "\p" & getArgsParserDocumentation(v, indentTimes + 1, indentValue)

## Exported
proc getArgsParserFullInfo*(ap: ArgsParser; indentTimes: Natural = 0; indentValue: string = "  "): string =
  result = getArgsParserStatus(ap, indentTimes, indentValue) & "\p\p" & getArgsParserDocumentation(ap, indentTimes, indentValue)

proc parseOptsBoolArgsList(ap: ArgsParser; args: string) =
  for c in args:
    var foundArg = ap.getShortName(c)
    if foundArg of BoolArgs:
      #TODO: Refactor
      if foundArg of HelpArgs:
        ap.helpArgsInited = true
      foundArg.addValue("")
    else:
      raise newBwapException(ap.getArgsParserName(), BwapUsageError, "'" & c & "' is not a flag name.")

## Exported
#type ArgsParserCtx = ref object of RootObj
#  expectingValue: bool
#  expectingArg: AnyArgs
#  ap: ArgsParser
#  apStack: seq[ArgsParser]

proc handleFoundArg(ap: ArgsParser; foundArg: AnyArgs) =
  if foundArg of BoolArgs:
    #TODO: Refactor
    if foundArg of HelpArgs:
      ap.apCtx.helpArgsInited = true
    foundArg.addValue("")
  elif foundArg of AnyValuedArgs:
    ap.expectingValue = true
    ap.expectingArg = foundArg
  else:
    assert(false)

proc trimApStack(ap: ArgsParser) =
  while ap.apStack.len() - 1 > ap.apStackIdx:
    discard ap.apStack.pop() #TODO: Optimize

proc resetApStackPos(ap: ArgsParser) =
  ap.usedApCtx = ap.apCtx
  ap.apStackIdx = ap.apStack.len() - 1

proc getNextApStackPos(ap: ArgsParser): ArgsParser =
  result = ap.apStack[ap.apStackIdx]

proc recurseApStackPos(ap: ArgsParser): bool =
  result = false
  if ap.apStackIdx >= 0:
    let pos = ap.getNextApStackPos()
    if pos.getIsRecursible():
      ap.usedApCtx = pos
      ap.apStackIdx -= 1
      result = true

proc handlePositional(ap: ArgsParser; v: string) =
  var handled = false
  ap.resetApStackPos()
  while not handled:
    try:
      if ap.usedApCtx.subCommandsLookup.contains(v):
        let found = deepCopy(ap.usedApCtx.subCommandsLookup[v])
        let uses = ap.usedApCtx.subCommandsUses[v]
        if found.isValueInRange(uses + 1): #TODO: Make this its own method?
          if isValueInRange(ap.usedApCtx.leastSubCommands, ap.usedApCtx.subCommandsList.len() + 1, ap.usedApCtx.mostSubCommands):
            ap.usedApCtx.subCommandsList.add(found)
            ap.usedApCtx.subCommandsUses[v] += 1
            ap.trimApStack()
            ap.apStack.add(ap.usedApCtx)
            ap.apCtx = found
            handled = true
            break
          else:
            raise newBwapException( ap.usedApCtx.getArgsParserName(), BwapRangeError, "Sub commands count of " & $(ap.usedApCtx.subCommandsList.len() + 1) & " for '" & v & "' does not fall in the necessary range of " & renderRange(ap.usedApCtx.leastSubCommands, ap.usedApCtx.mostSubCommands) )
        else:
          raise newBwapException( ap.usedApCtx.getArgsParserName(), BwapRangeError, "Uses count of " & $uses & " for '" & v & "' does not fall in the necessary range of " & found.getUsesRange() )
      elif not ap.recurseApStackPos():
        break
    except BwapError:
      if not ap.recurseApStackPos():
        raise getCurrentException()
  ap.resetApStackPos()
  while not handled:
    try:
      if ap.usedApCtx.positionalArgsInited:
        ap.usedApCtx.positionalArgs.addValue(v)
        break
      else:
        raise newBwapException(ap.usedApCtx.getArgsParserName(), BwapNoPositionalArgsError, "Cannot add positional args '" & v & "'. There are no positional args.")
    except BwapError:
      if not ap.recurseApStackPos():
        raise getCurrentException()

#proc handlePositional(ctx: ArgsParserCtx; v: string) =
#  if ctx.ap.subCommandsLookup.contains(v):
#    let found = deepCopy(ctx.ap.subCommandsLookup[v])
#    ctx.ap.subCommandsList.add(found)
#    ctx.apStack.add(ctx.ap)
#    ctx.ap = found
#  else:
#    #TODO Refactor out this pattern
#    while true:
#      try:
#        if ctx.ap.positionalArgsInited:
#          ctx.ap.positionalArgs.addValue(v)
#          break
#        else:
#          raise newBwapException(ctx.ap.getArgsParserName(), BwapNoPositionalArgsError, "Cannot add positional args '" & v & "'. There are no positional args.")
#      except BwapError:
#        ctx.recurseSubCommands( getCurrentException() )

## Exported
proc parseOptsSeq*(ap: ArgsParser; args: seq[string]) =
  for v in args:
    if ap.expectingValue:
      #if v.len() >= 2 and v[0] == '-':
      #  raise newBwapException(ctx.ap.getArgsParserName(), BwapUsageError, "Expected a value for " & ctx.expectingArg.getArgsName() & " but got new arg instead '" & v & "'.")
      #assert('=' notin v)
      ap.expectingValue = false
      ap.expectingArg.addValue(v)
    else:
      if v.len() <= 1:
        ap.handlePositional(v)
      elif v.len() == 2 and v[0] == '-':
        #TODO Refactor out this pattern
        ap.resetApStackPos()
        while true:
          try:
            handleFoundArg( ap, ap.usedApCtx.getShortName(v[1]) )
            break
          except BwapError:
            if not ap.recurseApStackPos():
              raise getCurrentException()
      #elif v.len() == 3:
      #  if v[0] == '-':
      #    #if v[1] == '-':
      #    #  raise newBwapException(ctx.ap.getArgsParserName(), BwapUsageError, "'" & v & "' is not a valid long argname. They must be at least two characters long.")
      #    #else:
      #    #  ctx.ap.parseOptsBoolArgsList(v[1..2])
      #    ap.apCtx.parseOptsBoolArgsList(v[1..2])
      #  else:
      #    ap.handlePositional(v)
      elif v[0] == '-':
        if v[1] == '-':
          let nameParts = v[2..len(v) - 1].split('=', 1)
          var foundArg: AnyArgs
          #TODO Refactor out this pattern
          ap.resetApStackPos()
          while true:
            try:
              foundArg = ap.usedApCtx.getLongName(nameParts[0])
              break
            except BwapError:
              if not ap.recurseApStackPos():
                raise getCurrentException()
          assert(1 <= len(nameParts) and len(nameParts) <= 2)
          if len(nameParts) < 2:
            handleFoundArg(ap, foundArg)
          else:
            if foundArg of BoolArgs:
              raise newBwapException(ap.apCtx.getArgsParserName(), BwapUsageError, "'" & foundArg.getArgsName() & "' is a flag, so a value cannot be specified using '=', as in '" & v & "'.")
            elif foundArg of AnyValuedArgs:
              #if nameParts[1].len() >= 2 and nameParts[1][0] == '-':
              #  raise newBwapException(ctx.ap.getArgsParserName(), BwapUsageError, "Expected a value for " & foundArg.getArgsName() & " but got new arg instead '" & nameParts[1] & "'.")
              foundArg.addValue(nameParts[1])
            else:
              assert(false)
        else:
          ap.apCtx.parseOptsBoolArgsList(v[1..len(v) - 1])
      else:
        ap.handlePositional(v)
  if ap.expectingValue:
    ap.expectingValue = false
    raise newBwapException(ap.apCtx.getArgsParserName(), BwapUsageError, "Expected a value for " & ap.expectingArg.getArgsName() & " but none was ever provided.")
  ap.ensureAllRangesSatisfied(ap.helpArgsInited)
# End ArgsParser

# TODO
# Add positional options
# Get option short
# Get option long
# Parse opts seq
# rewrite container type functions to just use container types
# Write opt help
# Write parser help
# Write all help
# Parser exename field
