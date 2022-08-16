#!/bin/sh
find ./src ./tests -name '*.h' -exec wc -l {} \; > lines.txt
find ./src ./tests -name '*.cpp' -exec wc -l {} \; >> lines.txt
find ./src ./tests -name '*.c' -exec wc -l {} \; >> lines.txt
find ./src ./tests -name 'CMakeLists.txt' -exec wc -l {} \; >> lines.txt
find ./src ./tests -name 'Makefile' -exec wc -l {} \; >> lines.txt
find ./src ./tests -name 'makefile' -exec wc -l {} \; >> lines.txt
cat lines.txt | awk 'BEGIN{SUM=0}{SUM=SUM+$1}END{print SUM}'
rm lines.txt
