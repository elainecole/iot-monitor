# File contains all tools for sending emails
# Usage:
# 1) call init with the password passed by user
# 2) call send email with the offending ip address

import os
import smtplib
import ssl

# Global variables
password = ""
sendAddr = "sudormrf569@gmail.com"
recvAddr = "j.millburg@wustl.edu"


# initServer
def initServer(pw):
    global sendAddr

    with smtplib.SMTP_SSL("smtp.gmail.com") as server:
        server.login(sendAddr, pw)
        # If here then we good?
        global password
        password = pw

# send email
def sendEmail(ipAddr):
    global sendAddr
    global password
    if (password == ""):
        return False

    message = "TWEET TWEET!! THE BOTS ARE ON YOUR NETWORK"
    
    # sender = global sendAddr
    # recipient = global recvAddr

    # Start connection and send email
    with smtplib.SMTP_SSL("smtp.gmail.com") as server:
        server.login(sendAddr, password)
        # Send email
        server.sendmail(sendAddr, recvAddr, message)

    
