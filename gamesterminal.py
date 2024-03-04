#!/usr/bin/python3

# Import the required libraries
from tkinter import *
import getpass
import subprocess
import os
from datetime import date

# Create an instance of tkinter frame or window
win=Tk()

# Configure window
win.geometry("700x350")
win.title("GamesTerminal")
win.minsize(500, 350)
win.configure(background="black")

# Gets initial directory
working_directory = os.getcwd()

# Creates scrollbar
scrollbar = Scrollbar(win, orient="vertical")
scrollbar.pack(side=RIGHT, fill='x')

# Creates prompt result and append it with the scrollbar
prompt_result = Text(win, state=DISABLED, foreground="white", background="black", yscrollcommand=scrollbar.set, borderwidth=0)
scrollbar.config(command=prompt_result.yview)
prompt_result.place(relx=0, rely=0, relwidth=1, relheight=.9)

def manage_prompt_result(option):
   if(option == "disabled"):
      prompt_result.configure(state=DISABLED)
   else:
      prompt_result.configure(state=NORMAL)

def delete_prompt_result_info():
   manage_prompt_result("normal")
   prompt_result.delete(1.0, END)
   manage_prompt_result("disabled")

def insert_prompt_result_info(text):
   manage_prompt_result("normal")
   prompt_result.insert(END, text)
   manage_prompt_result("disabled")

# Create pre_prompt_info
pre_prompt_info = Label(win, foreground="white", background="black", text=f"{working_directory}@{getpass.getuser()} ~")
pre_prompt_info.place(relx=0, rely=0.9)

# Create command prompt
prompt = Entry(win, borderwidth=0, foreground="white", background="black")
prompt.focus_set()
prompt.place(relx=0, rely=0.95, relwidth=1, relheight=.05)

def dir_file_exists(path):
   return os.path.exists(path)

def apply_theme(theme):
   if theme == "shell":
      prompt_result.configure(foreground="white", background="black")
      pre_prompt_info.configure(foreground="white", background="black")
      prompt.configure(foreground="white", background="black")
      win.configure(background="black")
   elif theme == "valorant":
      prompt_result.configure(foreground="#2CEE9C", background="#0F1A27")
      pre_prompt_info.configure(foreground="#FF004C", background="#0F1A27")
      prompt.configure(foreground="#2CEE9C", background="#0F1A27")
      win.configure(background="#0F1A27")
   elif theme == "minecraft":
      prompt_result.configure(foreground="#2CEE9C", background="#331800")
      pre_prompt_info.configure(foreground="#8D8D8D", background="#331800")
      prompt.configure(foreground="#5BC3FF", background="#331800")
      win.configure(background="#331800")

def execute_command(event):
   command = prompt.get()
   working_directory = os.getcwd()
   global theme_config_directory
   
   if command.find("cd") != -1:
      try:
         if command == "cd":
            working_directory = f"/home/{getpass.getuser()}"
            os.chdir(working_directory)
            pre_prompt_info.configure(text=f"{working_directory}@{getpass.getuser()} ~")
            prompt.delete(0, END)
            return
         elif command == "cd ..":
            os.chdir(os.pardir)
            working_directory = os.getcwd()
            pre_prompt_info.configure(text=f"{working_directory}@{getpass.getuser()} ~")
            prompt.delete(0, END)
            return
         else:
            os.chdir(command[3:])
            working_directory = os.getcwd()
            pre_prompt_info.configure(text=f"{working_directory}@{getpass.getuser()} ~")
            prompt.delete(0, END)
            return
      except:
         insert_prompt_result_info("Error: cd not used properly or dir does not exist\n")
         prompt.delete(0, END)
         return
   elif command == "clear":
      delete_prompt_result_info()
      prompt.delete(0, END)
      return
   elif command == "date":
      insert_prompt_result_info(f"Today's date: {date.today()}\n")
      prompt.delete(0, END)
      return
   elif command.find("theme") != -1:
      if command == "theme valorant":
         apply_theme("valorant")
         prompt.delete(0, END)
         return
      elif command == "theme minecraft":
         apply_theme("minecraft")
         prompt.delete(0, END)
         return
      elif command == "theme shell":
         apply_theme("shell")
         prompt.delete(0, END)
         return
      elif command == "theme":
         insert_prompt_result_info("Available themes:\n- valorant\n- minecraft\n- shell\n")
         insert_prompt_result_info("Example: theme (valorant|minecraft|shell)\n")
         prompt.delete(0, END)
         return
      else:
         insert_prompt_result_info("That theme does not exist!")
         prompt.delete(0, END)
         return
   try:
      resultado = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT, text=True)
      prompt.delete(0, END)
      insert_prompt_result_info(f"{resultado}\n")
   except subprocess.CalledProcessError as e:
      insert_prompt_result_info(f"Error: {e.output}\n")
      prompt.delete(0, END)

win.bind('<Return>', execute_command)

win.mainloop()
