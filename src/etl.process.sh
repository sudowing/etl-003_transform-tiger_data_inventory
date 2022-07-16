#!/bin/bash
. ../log.sh;

log info 'TRANSFORM [START]';

FILE=/tmp/batch.txt
ZIP_FILE_QUEUE=file_queue_zip.txt
SHP_FILE_QUEUE=file_queue_shp.txt

if [ -f "$FILE" ]; then
    log info "TRANSFORM [SURVEY]: process files provided in /tmp/batch.txt";
    cat $FILE | grep '.zip' > $ZIP_FILE_QUEUE;
else
    log info "TRANSFORM [SURVEY]: survey files provided in input input directory";
    ls -H input/ | grep '.zip' > $ZIP_FILE_QUEUE;
fi

TIMESTAMP=$(date +%s)

# for each file provided as input -- load as a table in sqlite
while read ZIP_FILENAME; do

    log info "TRANSFORM [unzip]: $ZIP_FILENAME";

    rm -Rf temp/ \
        1>> $ETL_LOG_STDOUT 2>> $ETL_LOG_STDERR;

    unzip input/$ZIP_FILENAME -d temp \
        1>> $ETL_LOG_STDOUT 2>> $ETL_LOG_STDERR;

    # derive table name
    TIGER_RECORD_TYPE=$(echo $ZIP_FILENAME | cut -d '-' -f 1 | cut -d '.' -f 3 | tr '[A-Z]' '[a-z]');

    # survey for shapefiles
    ls -H temp/ | grep '.shp$' > $SHP_FILE_QUEUE;

    # process each found shapefile
    while read SHP_FILENAME; do

        log info "TRANSFORM [shp2pgsql:ddl]: $SHP_FILENAME";


        # create ddl for table to hold records
        shp2pgsql -p -I \
            temp/$SHP_FILENAME public.$TIGER_RECORD_TYPE \
                | sed 's|CREATE TABLE|CREATE TABLE IF NOT EXISTS|g' \
                | sed 's|\\N||g' \
                1> output/901T.$TIMESTAMP.ddl.$TIGER_RECORD_TYPE.sql \
                2> $ETL_LOG_STDERR;

        log info "TRANSFORM [shp2pgsql:records]: $SHP_FILENAME";

        # transform shapefiles via shp2pgsql
        shp2pgsql -a -D \
            temp/$SHP_FILENAME public.$TIGER_RECORD_TYPE \
            | sed 's|\\N||g' | gzip -cf \
                    1> output/901T.$TIMESTAMP.records.$SHP_FILENAME.sql.gz \
                    2> $ETL_LOG_STDERR;

    done <$SHP_FILE_QUEUE;

done <$ZIP_FILE_QUEUE;


publish_json_logs;
log info 'TRANSFORM [COMPLETE]';