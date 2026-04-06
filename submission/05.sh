#!/bin/bash
transaction="0200000001d54e767769b3c3b8707115f748c88f7323def5b78147628aa071fdcf2fdf7379000000006a47304402207883e621fb279d18902986836e89ebe77c13b39e7c9141d0c8b81274a98245d502204d3ffc75ae16b8d3e5918f078075cb2afb180828d910f0feaf090cd74d805ca4012103fdee3ce1c3ca71b5e9eb846147ff5d26f499ef2f12f84b34de46b3dcf228df55fdffffff0180e0d211010000001976a914d5391484579a9760f87c9772035248325aabe01f88ac00000000"

# vin = inputs array
# each input has a scriptSig field = the UNLOCKING script
# "hex" inside scriptSig is the raw hex of the unlocking script
# python3 extracts vin[0].scriptSig.hex
bitcoin-cli -regtest decoderawtransaction "$transaction" | python3 -c "
import sys, json
data = json.load(sys.stdin)
# vin is the list of inputs
# [0] gets the first input
# scriptSig is the unlocking script object
# hex is the raw hex encoding of the script
print(data['vin'][0]['scriptSig']['hex'])
"

# Why vout[0] vs vin[0]?
# Transaction structure:
# ├── vin (inputs)  - each has scriptSig  = UNLOCKING script
# └── vout (outputs) - each has scriptPubKey = LOCKING script