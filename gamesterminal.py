# Import the required libraries
from tkinter import *
import getpass
import subprocess, sys
import os

# Create an instance of tkinter frame or window
win=Tk()

# Configure window
win.geometry("700x350")
win.title("test")
win.minsize(500, 350)
win.configure(background="black")

working_directory = os.getcwd()

# Create pre_prompt_info
pre_prompt_info = Label(win, foreground="white", background="black", text=f"{working_directory}@{getpass.getuser()} ~")
pre_prompt_info.place(relx=0, rely=0.9)

# Create command prompt
prompt = Entry(win, borderwidth=0, foreground="white", background="black")
prompt.focus_set()
prompt.place(relx=0, rely=0.95, relwidth=1, relheight=.05)

win.mainloop()