#!/bin/bash

SrcDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$SrcDirPath"

echo "- Formatting..."

# Seems broken
# prettier --write "$SrcDirPath"

swiftlint autocorrect --quiet --path "$SrcDirPath" --config "$SrcDirPath/.swiftlint.yml"
if [ $? -ne 0 ]; then
   exit $?
fi
# swiftlint lint --quiet --path "$SrcDirPath" --config "$SrcDirPath/.swiftlint.yml"

echo "- Done!"
