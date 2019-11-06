#/bin/bash

echo -n $1 | iconv -t utf16le | openssl md4
