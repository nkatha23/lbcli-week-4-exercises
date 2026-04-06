#!/bin/bash
transaction="01000000000101c8b0928edebbec5e698d5f86d0474595d9f6a5b2e4e3772cd9d1005f23bdef772500000000ffffffff0276b4fa0000000000160014f848fe5267491a8a5d32423de4b0a24d1065c6030e9c6e000000000016001434d14a23d2ba08d3e3edee9172f0c97f046266fb0247304402205fee57960883f6d69acf283192785f1147a3e11b97cf01a210cf7e9916500c040220483de1c51af5027440565caead6c1064bac92cb477b536e060f004c733c45128012102d12b6b907c5a1ef025d0924a29e354f6d7b1b11b5a7ddff94710d6f0042f3da800000000"

#  1: get txid from the given transaction
TXID=$(bitcoin-cli -regtest decoderawtransaction "$transaction" \
  | grep -oP '"txid":\s*"\K[^"]+' | head -1)

#  2: convert the message to hex
# OP_RETURN requires the data in hex format, not plain text
# xxd -p converts text to hex
# tr -d '\n' removes any newline characters xxd might add
MESSAGE="btrust builder 2026"
MESSAGE_HEX=$(echo -n "$MESSAGE" | xxd -p | tr -d '\n')
# echo -n → print without adding a newline at the end
# xxd -p → plain hex dump (no formatting, just hex characters)
# tr -d '\n' → delete any newline characters from the output

#  3: createrawtransaction with TWO outputs:
# output 1: the actual payment of 0.20000000 BTC
# output 2: "data" key with our hex message → becomes OP_RETURN output
# OP_RETURN outputs have 0 BTC value — they are unspendable data carriers
bitcoin-cli -regtest createrawtransaction \
  "[{\"txid\":\"$TXID\",\"vout\":0},{\"txid\":\"$TXID\",\"vout\":1}]" \
  "[{\"2MvLcssW49n9atmksjwg2ZCMsEMsoj3pzUP\":0.20000000},{\"data\":\"$MESSAGE_HEX\"}]"]





# echo "hello" | xxd -p   # outputs: 68656c6c6f0a - has 0a (newline) at end!
# echo -n "hello" | xxd -p # outputs: 68656c6c6f    - clean, no newline
# The -n flag stops echo from adding a newline — important for exact hex encoding.