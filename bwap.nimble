# Package

version       = "1.0.0"
author        = "buzzingwires"
description   = "Versatile runtime command line parser"
license       = "GPL-3.0-only"
srcDir        = "src"


# Dependencies

requires "nim >= 1.6.12"


# Targets
task build_examples, "Build examples":
  withDir "examples":
    exec "nim c bwap_example.nim"
