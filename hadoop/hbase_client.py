from thrift.transport.TSocket import TSocket
from thrift.transport.TTransport import TBufferedTransport
from thrift.protocol import TBinaryProtocol
from hbase import Hbase
host = '10.70.130.52'
port = '9090'
CLIENT = None

def get_conn(host=host, port=port):
    global CLIENT
    if not CLIENT:
        transport = TBufferedTransport(TSocket(host, port))
        transport.open()
        protocol = TBinaryProtocol.TBinaryProtocol(transport)
        
        CLIENT = Hbase.Client(protocol)
    return CLIENT

def create_table(table, cfs):
    '''Create htable
    table: table name
    cfs: column family
    '''
    client.createTable(table, cfs)

## Test
if __name__ == '__main__':
   import pdb
   pdb.set_trace()
   client = get_conn()
   print client.getTableNames()
