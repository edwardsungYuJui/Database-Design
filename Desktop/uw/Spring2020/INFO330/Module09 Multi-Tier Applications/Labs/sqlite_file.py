import sqlite3  # this imports code from the SQLite module of PySQLite!

# Functions -----------------------------------------------------
def create_connection(db_file):
    try:
        con = sqlite3.connect(db_file)  # This opens OR creates the database
        print('Connected! - SQLite Version is: ', sqlite3.version)
    except Exception as e:
        print(e.__str__())
    return con

# Main body of the script------------------------------------------
db_con = create_connection('~/Desktop/Datafiles/test.db')  
db_con.close()  # Always close the connection when your done
import sqlite3

# Functions ----------------------------------------------------
def create_connection(db_file):
    try:
        con = sqlite3.connect(db_file)  # This opens OR creates the database
    except Exception as e:
        raise e
    return con


def create_demo_table(con):
    try:
        csr = con.cursor()  # A cursor object allows you to submit commands
        csr.execute("Create Table Demo (ID [integer], Name [text]);")  
        csr.close()  # Always close the cursor when your done
    except Exception as e:
        raise e


# Main body of the script ------------------------------------
db_con = None

try:  # Connecting
    db_con = create_connection('test.db')
    print("Connected!")
except Exception as e:
    print(e)

try:  # Creating
    create_demo_table(db_con)
    print("Table created!")
except Exception as e:
    print(e)
