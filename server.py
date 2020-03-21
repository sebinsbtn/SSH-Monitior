import socket 
from thread import *
import threading 
import json
import logging
import mysql.connector
from mysql.connector import Error
from mysql.connector import errorcode

  
# thread fuction 
def threaded(c,addr): 
    while True:
    	try:
    		data = c.recv(1024) 
    		print(data)
    		if not data:
    			print('Bye')
    			break
    	except Exception as e:
    		print(e)
	# print(addr[0])
    c.close()
    
def insertintotable(addr):
    try:
		connection = mysql.connector.connect(host='127.0.0.1',
                                         port='3307',
                                         database='logindetails',
                                         user='sshuser',
                                         password='Password@1')
		
		mySql_insert_query = """INSERT INTO ssh_logins (IP, Attempts) VALUES (%s ,%s ) ON DUPLICATE KEY UPDATE Attempts = Attempts + 1; """
		recordTuple = (addr,'1')
		cursor = connection.cursor()
		cursor.execute(mySql_insert_query,recordTuple)
		connection.commit()
		print(cursor.rowcount, "Record inserted successfully")
		cursor.close()

    except mysql.connector.Error as error:
		print("Failed to insert record {}".format(error))
    finally:
		if (connection.is_connected()):
			connection.close()
		print("MySQL connection is closed")


def Main(): 
    host = "" 
  
    port = 1492
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 
    s.bind((host, port)) 
    logging.basicConfig(filename='./access.log',
                            filemode='a',
                            format='%(asctime)s,%(msecs)d %(name)s %(levelname)s %(message)s',
                            datefmt='%H:%M:%S',
                            level=logging.DEBUG)
    logging.info("socket binded to port 1492 ")
    print("socket binded to port", port) 
  
    s.listen(50) 
    print("socket is listening") 
    while True: 
  
        c, addr = s.accept() 
        print('Connected to :', addr[0], ':', addr[1]) 
        insertintotable(addr[0])
        c.close()
        # start_new_thread(threaded, (c,addr)) 
    s.close() 
  
  
if __name__ == '__main__': 
    Main() 

