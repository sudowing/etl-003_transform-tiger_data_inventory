from datetime import date
import sys
import time

from etl_utils import get_logger, write_file

from requirements import required_fields

# Set environment variables
message = '/tmp/SOURCE_HAS_REQUIRED_FIELDS'
write_file(message, 'valid')

logger = get_logger(log_level='DEBUG')

Map = lambda fun, iter: list(map(fun, iter))

def validate(filename, table_name):
    fields_raw = fline=open(filename).readline().rstrip().split('\t')
    fields = set(Map(lambda s: s.lower(),fields_raw))
    missing_fields = required_fields - fields
    filename_chunks = filename.split('.')
    filename_ext = filename_chunks[len(filename_chunks) -1]


    if len(missing_fields):
        # print(missing_fields)
        name_chunks = table_name.split('_')
        record = [
            date.today().strftime("%Y-%m-%d")
            ,'V101'
            ,'"missing required fields [{}]"'.format(','.join(missing_fields))
            ,'0'
            ,str(int(time.time()))
            ,name_chunks[0]
            ,name_chunks[1]
            ,name_chunks[2]
            ,name_chunks[3]
            ,filename_ext
            ,filename.replace('input/', '') + '\n'
        ]
        write_file(message, ','.join(record))

if __name__ == "__main__":
    filename = sys.argv[1]
    table_name = sys.argv[2]
    validate(filename, table_name)
