import jaydebeapi
driver = 'org.apache.phoenix.jdbc.PhoenixDriver'
url = 'jdbc:phoenix:bd-52:2181/hbase'
client_jar = '/var/tmp/phoenix-4.9.0-cdh5.9.1-client.jar'
conn = jaydebeapi.connect(driver, [url, '', ''], client_jar)
curs = conn.cursor()
curs.execute('select * from hbase_ddbaseservice limit 10')
