#!/usr/bin/env bash

: '
sqlite3 required
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

DST_DIR=$(pwd)
SD_PATH=$1
VIDEO_PATH=$1/DCIM/100MEDIA
DB_PATH=$1/MISC/default_sensor_name.db

PARTS=()

for VIDEO in $VIDEO_PATH/*.MP4; do
    PARTS+=($VIDEO)
    FILENAME=$(basename $VIDEO)
    SELECT_COMMAND="SELECT video_info_table.wb_count FROM gis_info_table INNER JOIN video_info_table ON gis_info_table.video_index + 1 = video_info_table.ID WHERE gis_info_table.file_name LIKE '%$FILENAME'"
    SQLITE_RES=$(sqlite3 "$DB_PATH" "$SELECT_COMMAND")
    if [[ $SQLITE_RES == 0 || -z $SQLITE_RES ]]; then
        # got the last part
        OUTPUT_FILE=$(outputFile ${PARTS[@]})
        mp4_merge ${PARTS[@]} --out $OUTPUT_FILE
        PARTS=()
    fi
done
