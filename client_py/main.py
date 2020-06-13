import ibm_db

conn = ibm_db.connect('DATABASE=SAMPLE;'
                     'HOSTNAME=62.44.108.24;'  # 127.0.0.1 or localhost works if it's local
                     'PORT=50000;'
                     'PROTOCOL=TCPIP;'
                     'UID=db2admin;'
                     'PWD=db2admin;', '', '')

stmt = ibm_db.exec_immediate(conn, "SELECT * FROM FN45398.STAFF")
result = ibm_db.fetch_both(stmt)

while( result ):
    print(result['EGN']) # you get the idea
    result = ibm_db.fetch_both(stmt)
