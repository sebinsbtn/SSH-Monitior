import socket 
from thread import *
import threading 
import json
import logging
  

def threaded(c): 
    while True:
    	arr = []
    	try:
    		data = c.recv(1024) 
    		print(data)
    		if not data:
    			print('Bye')
    			break

    	except Exception as e:
    		print(e)
    c.close() 

def Main(): 
    host = "" 
  
    port = 1492
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 
    s.bind((host, port)) 
    logging.basicConfig(filename='/home/ubuntu/access.log',
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
  
        start_new_thread(threaded, (c,)) 
    s.close() 
  
  
if __name__ == '__main__': 
    Main() 

