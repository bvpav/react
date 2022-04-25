#!/bin/sh --

cd "$(dirname "$(dirname "$0")")" || exit
export PATH="$PATH:$PWD/node_modules/.bin"

TS=ts.tmp

mkdir -p $TS
find src/ -name '*.js' ! -path '*__tests__*' ! -path '*node_modules*' |
  while read -r file; do
    filename="${file#src/}"
    echo "$filename"
    new_file="$TS/$filename"
    mkdir -p "$(dirname "$new_file")"
    sed "1iimport React from 'react';type window = Window;type TimeoutID = ReturnType<typeof setTimeout>;" "$file" > "$new_file"
    flow-to-ts --write "$new_file"
    rm "$new_file"
  done

# wait
tsc

rm -rf ${TS:?}/
