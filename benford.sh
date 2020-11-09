#!/bin/bash
#################################################################################
# MIT License
# 
# Copyright (c) 2020 Jia Lihong
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#################################################################################
#
# Usage: $(basename $0) CSDN_ID     # check csdn blog view count
#        $(basename $0) -r FILE     # check local raw data
# Check whether the data meets Benford's law.
#

display_help() {
    echo "Usage: $(basename "$0") CSDN_ID     # check csdn blog view count"
    echo "       $(basename "$0") -r FILE     # check local raw data"
    echo "Check whether the data meets Benford's law."
}

benford() {
    local -r RAW_DATA=$*
    local -r DIST=$(echo "${RAW_DATA}" | awk '/[1-9]/ {print $1}' | sort | cut -c1 | uniq -c)

    if [[ "${DIST}" == "" ]]; then
        echo "Empty data"
        return
    fi

    local -r PERCENT=$(echo "${DIST}" | awk 'BEGIN { TOTAL=0; for (i=1; i<=9; i++) arr[i]=0; } { arr[$2]=$1; TOTAL+=$1 } END { for (i in arr) print i, arr[i]/TOTAL*100 }')
    echo "${PERCENT}" | awk '{ ACTUALS=sprintf("%-*s", $2, ""); gsub(" ", "=", ACTUALS); STD=100*log((NR+1)/NR)/log(10); STDS=sprintf("%-*s", STD, ""); gsub(" ", "+", STDS); printf("%-2s%6.2f%% %s\n%-2s%6.2f%% %s\n", "", STD, STDS, $1, $2, ACTUALS)}'
}

csdn_data() {
    local -r ID=$1
    echo "csdn id: ${ID}" >&2
    local -r URL_PREFIX="https://blog.csdn.net/${ID}/article/list/"
    echo "url prefix: ${URL_PREFIX}" >&2
    local -r HTML="$(curl -s "${URL_PREFIX}")"
    local -r PAGE_SIZE="$(echo "${HTML}" | grep "pageSize" | grep -E -o "[0-9]+")"
    echo "page size: ${PAGE_SIZE}" >&2
    local -r LIST_TOTAL="$(echo "${HTML}" | grep "listTotal" | grep -E -o "[0-9]+")"
    echo "list total: ${LIST_TOTAL}" >&2
    
    if (( LIST_TOTAL == 0 || PAGE_SIZE == 0 )); then
        echo ""
        return
    fi
    
    local -r PAGE_COUNT="$(( (LIST_TOTAL - 1) / PAGE_SIZE + 1 ))"
    echo "page count: ${PAGE_COUNT}" >&2
    
    local -r RAW_DATA=$(curl "${URL_PREFIX}{$(seq -s, 1 ${PAGE_COUNT})}" | grep "read-num" | grep "readCountWhite.png" | awk -F'[<>]' '{ print $5 }')
    
    echo "${RAW_DATA}"
}

main() {
    DISPLAY_HELP="false"
    RAW_FILE=""

    while getopts "hr:" opt
    do
        case "$opt" in
        h) DISPLAY_HELP="true" ;;
        r) RAW_FILE="${OPTARG}" ;;
        *) echo "Unknown option $opt"; exit 1 ;;
        esac
    done

    if [[ "${DISPLAY_HELP}" == "true" ]]; then
        display_help
        exit 0
    fi

    if [[ "${RAW_FILE}" == "" ]]; then
        shift $(( OPTIND - 1))

        IDS="imred"

        if [ -n "$1" ]; then
            IDS="$*"
        fi

        for CSDN_ID in ${IDS}; do
            echo "===================="
            RAW_DATA=$(csdn_data "${CSDN_ID}")
            benford "${RAW_DATA}"
        done
    else
        if ! [ -e "${RAW_FILE}" ]; then
            echo "File doesn't exist: ${RAW_FILE}"
            exit 1
        fi
            
        RAW_DATA=$(cat "${RAW_FILE}")
        benford "${RAW_DATA}"
    fi
}

main "$@"
