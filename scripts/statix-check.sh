#!/bin/bash
FILES=$(find . -name "*.nix")
RETVAL=0
for file in $FILES; do
    echo "Checking $file"
    nix-shell -p statix --run "statix check $file"
    if [ $? -ne 0 ]; then
        RETVAL=1
    fi
done
exit $RETVAL