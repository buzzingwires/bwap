# Package

version       = "1.0.0"
author        = "buzzingwires"
description   = "Versatile runtime command line parser"
license       = "GPL-3.0-only"
srcDir        = "src"


# Dependencies

requires "nim >= 1.6.12"


# Targets

bin = @["bwap_example"]
installExt = @["nim"]
