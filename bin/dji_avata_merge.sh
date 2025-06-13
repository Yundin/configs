#!/usr/bin/env bash

: '
exiftool required
mp4_merge required: https://github.com/gyroflow/mp4-merge/

Нужно указать путь до флешки: `dji_merge /Volumes/O3_Unit`
Сохраняет результат в текущую директорию
'

set -e

outputFile() {
    local FILE_FST=$1
    local FST_NO_EXT=$(basename "${FILE_FST%.*}")
    if [[ $# == 1 ]]; then
        echo "$DST_DIR/${FST_NO_EXT}_merged.MP4"
    else
        local FILE_LAST=${@: -1}
        local LAST_NO_EXT=$(basename "${FILE_LAST%.*}")
        echo "$DST_DIR/${FST_NO_EXT}-${LAST_NO_EXT}_merged.MP4"
    fi
}

mergeParts() {
    OUTPUT_FILE=$(outputFile ${@})
    mp4_merge ${@} --out $OUTPUT_FILE
}

DST_DIR=$(pwd)
SD_PATH=$1
VIDEO_PATH=$1/DCIM/DJI_001
NEXT_PART_TIME=0

PARTS=()

for VIDEO in $VIDEO_PATH/*.MP4; do
    EXIF_DATA=$(exiftool "$VIDEO" -d "%s" -t)
    CREATE_DATE=$(echo "$EXIF_DATA" | grep "^Create Date" | cut -f2)
    RAW_DURATION=$(echo "$EXIF_DATA" | grep "^Duration" | cut -f2)
    DURATION_SECONDS=$(date -jf "%FT%k:%M:%S %z" "1970-01-01T$RAW_DURATION +0000" "+%s")
    DIFF_NOT_ABS=$(($NEXT_PART_TIME - $CREATE_DATE))
    DIFF=$(echo $DIFF_NOT_ABS | sed 's/-//')
    if [[ $NEXT_PART_TIME != 0 && $DIFF -gt 5 ]]; then
        mergeParts ${PARTS[@]}
        PARTS=()
    fi
    PARTS+=($VIDEO)
    NEXT_PART_TIME=$(($CREATE_DATE + $DURATION_SECONDS))
done
mergeParts ${PARTS[@]}
