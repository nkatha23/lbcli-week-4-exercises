#to whoever is reading this, i have added comments for my own understanding, please ignore them, they are not part of the solution, they're just for my easy reference, thank you.


#!/bin/bash
# createwallet makes a new wallet named "btrustwallet"
# 2>/dev/null silences the error if wallet already exists
# || means "if that fails, try loadwallet instead"
bitcoin-cli -regtest createwallet "btrustwallet" 2>/dev/null \
  || bitcoin-cli -regtest loadwallet "btrustwallet"
