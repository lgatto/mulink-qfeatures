#!/usr/bin/env python3
#
# /// script
# requires-python = ">=3.14"
# dependencies = [
#    "mudata>=0.4.1",
#    "mulink>=0.0.1",
# ]
# ///

import mudata as md
import mulink

mdata = md.read_h5mu("../data/brunner2022.h5mu")

print(mdata)
