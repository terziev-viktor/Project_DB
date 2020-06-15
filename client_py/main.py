import ibm_db

conn = ibm_db.connect('DATABASE=SAMPLE;'
                     'HOSTNAME=62.44.108.24;'
                     'PORT=50000;'
                     'PROTOCOL=TCPIP;'
                     'UID=db2admin;'
                     'PWD=db2admin;', '', '')

owners = []
free_zones = []

def apply_on_row(query, f):
    stmt = ibm_db.exec_immediate(conn,query)
    result = ibm_db.fetch_both(stmt)

    while(result):
        f(result)
        result = ibm_db.fetch_both(stmt) 

def fetch():
    print("fetching Owners")

    def fill(c):
        return lambda row: c.append(row)
    
    apply_on_row("SELECT * FROM FN45398.OWNERS", fill(owners))
    apply_on_row("SELECT * FROM FN45398.ZONES z WHERE z.ZONE_ID NOT IN (SELECT c.ZONE_ID FROM FN45398.CONTRACTS c WHERE CURRENT TIMESTAMP > c.STDATE  AND CURRENT timestamp < c.ENDATE);", fill(free_zones))

def add_new_contr(): 
    print("Add new contract\n 1. Choose owner: ")
    print([owner["NAME"] for owner in owners])

    input_name = input()
    if len([name for name in owners if name["NAME"] == input_name]) == 0: 
        print("name of owner not found")
        return 
    owner_id = [owner["OWNER_ID"] for owner in owners if owner["NAME"] == input_name][0]

    print("Choose zone's id: ")
    print(free_zones)
    input_zone = int(input())
    if len([zone for zone in free_zones if zone["ZONE_ID"] == input_zone]) == 0:
        print("zone id not found")
        return

    ibm_db.exec_immediate(conn,"INSERT INTO FN45398.CONTRACTS (price, owner, zone_id, stdate, endate) VALUES (1001.99, "+ str(owner_id) +", "+ str(input_zone) +", CURRENT timestamp, CURRENT timestamp + 1 YEAR);")

def main():

    fetch()
    ch = "Y"

    while ch == "Y":
        add_new_contr()
        print("if you want to add ne contr pres Y")
        ch = input()

if __name__ == "__main__":
    main()