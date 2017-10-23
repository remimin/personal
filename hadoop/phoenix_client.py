import phoenixdb
import phoenixdb.cursor

db_url = 'http://10.70.130.52:8765'
conn=phoenixdb.connect(db_url, autocommit=True)
cursor = conn.cursor()
cursor.execute("select * from hb_ddbaseservice limit 10")
