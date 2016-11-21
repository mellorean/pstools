#!/bin/bash

# Copyright (C) 2016 by Migg Ellorean
# Distributed under the GNU GPL v2.0
#
# v0.9.0 - 21 November 2016

echo -e '<pages>\n<page l="100" t="100" w="800" h="600">'
echo
sed -n '/<path/ { s/^.*d=" *M *\([^"]*\)".*/\1/; p }' $1 \
| while read line; do
    a=( ${line// [CL] / } )
    case "$line" in
        *" L "*) echo -n '<ln pts="';;
        *" C "*) echo -n '<bc pts="';;
        *) continue;;
    esac
    for fn in "${a[@]}"; do
        if [[ "$fn" =~ ([0-9]+)\.(0*([0-9]*)) ]]; then
            v=${BASH_REMATCH[1]}
            d=${BASH_REMATCH[2]}
            i=${BASH_REMATCH[3]}
            if [ ${#d} -lt 2 ]; then
                echo -n "$v${d}0 "
            elif [ $v -eq 0 ]; then
                echo -n "$((($i + (10 ** (${#d}-2))/2)/(10 ** (${#d} - 2)))) "
	    else
                echo -n "$((($v$d + (10 ** (${#d}-2))/2)/(10 ** (${#d} - 2)))) "
            fi
        else
            echo -n "${fn}00 "
        fi
    done
    echo '" col="0"/>'
done \
| sed 's/ " \+col=/" col=/'
echo
echo -e '</page>\n</pages>'
