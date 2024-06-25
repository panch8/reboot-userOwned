#/bin/bash
CANISTER_ID=tupvb-paaaa-aaaao-a3o2q-cai

balance=$(dfx canister --network ic status $CANISTER_ID | grep Balance: | sed 's/[^0-9]//g')  
myBalance=$(expr $balance + 0)

#echo "Canister balance: $myBalance"

if [ 5000000000000 -gt "$myBalance" ]; then
  echo "Pool balance is less with $myBalance cycles, top up the wallet with 5T cycles."
else
  echo "Pool balance is good with $myBalance cycles."
fi
