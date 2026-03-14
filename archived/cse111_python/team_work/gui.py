# Written By: Case, Harrison, and Joshua; CSE111 2025.03.27

# Problem Statement:
# Almost all of the programs that you wrote for this course receive input from and
# print results to a terminal window. However, most users prefer to interact with a
# program through a graphical user interface (GUI) that contains icons, text fields,
# drop-down lists, buttons, etc. Within a GUI, the individual components (icons,
# text fields, etc.) are called widgets. Most libraries for creating GUIs use object
# oriented programming because each widget is an object with attributes and methods.

# Assignment:
# As a team, write a Python program named gui.py that gets user input from a GUI,
# performs a simple calculation, and displays the result in a GUI.

# Imports
import tkinter as tk
import math

# from math import pi
from tkinter import Frame, Label, Button
from number_entry import FloatEntry


def main():
    # Create the Tk root object.
    root = tk.Tk()

    # Create the main window. In tkinter,
    # a window is also called a frame.
    frm_main = Frame(root)
    frm_main.master.title("Pendulum Swing Time")
    frm_main.pack(padx=4, pady=3, fill=tk.BOTH, expand=1)

    # Call the populate_main_window function, which will add
    # labels, text entry boxes, and buttons to the main window.
    populate_main_window(frm_main)

    # Start the tkinter loop that processes user events
    # such as key presses and mouse button clicks.
    root.mainloop()


# The controls in a graphical user interface (GUI) are called widgets,
# and each widget is an object. Because a GUI has many widgets and
# each widget is an object, the code to make a GUI usually has many
# variables to store the many objects. Because there are so many
# variable names, programmers often adopt a naming convention to help
# a programmer keep track of all the variables. One popular naming
# convention is to type a three letter prefix in front of the names
# of all variables that store GUI widgets, according to this list:
# >    frm: a frame (window) widget
# >    lbl: a label widget that displays text for the user to see
# >    ent: an entry widget where a user will type text or numbers
# >    btn: a button widget that the user will click


def populate_main_window(frm_main):
    """Populate the main window of this program. In other words, put
    the labels, text entry boxes, and buttons into the main window.

    Parameter
        frm_main: the main frame (window)
    Return: nothing
    """
    # Entry Line Labels
    lbl_length = Label(frm_main, text="Pendulum Length (m):")
    ent_length = FloatEntry(frm_main, width=4, lower_bound=1, upper_bound=10)
    lbl_length_units = Label(frm_main, text="m")

    # Display Line Labels
    lbl_time = Label(frm_main, text="Pendulum Time (s):")
    lbl_time_value = Label(frm_main, text="")
    lbl_time_units = Label(frm_main, text="sec")

    lbl_frequency = Label(frm_main, text="Pendulum Frequency (f):")
    lbl_frequency_value = Label(frm_main, text="")
    lbl_frequency_units = Label(frm_main, text="Hz")

    # Create the Clear button.
    btn_clear = Button(frm_main, text="Clear")

    # Layout all the labels, entry boxes, and buttons in a grid.
    lbl_length.grid(row=0, column=0, padx=3, pady=3)
    ent_length.grid(row=0, column=1, padx=3, pady=3)
    lbl_length_units.grid(row=0, column=2, padx=0, pady=3)

    lbl_time.grid(row=1, column=0, padx=(30, 3), pady=3)
    lbl_time_value.grid(row=1, column=1, padx=3, pady=3)
    lbl_time_units.grid(row=1, column=2, padx=3, pady=3)

    lbl_frequency.grid(row=2, column=0, padx=3, pady=3)
    lbl_frequency_value.grid(row=2, column=1, padx=0, pady=3)
    lbl_frequency_units.grid(row=2, column=2, padx=0, pady=3)

    btn_clear.grid(row=3, column=0, padx=3, pady=3, columnspan=4, sticky="w")

    # This function will be called each time the user releases a key.
    def calculate(event):
        """Compute and display the user's slowest
        and fastest beneficial heart rates.
        """
        try:
            # Get the length of the pendulum from the user.
            length = ent_length.get()

            # Calculate the swing time of a pendulum
            time = 2 * math.pi * math.sqrt(length / 9.81)
            frequency = 1 / time

            # Display the pendulum swing time for user
            lbl_time_value.config(text=f"{time:.2f}")
            lbl_frequency_value.config(text=f"{frequency:.2f}")

        except ValueError:
            # When the user deletes all the digits in the age
            # entry box, clear the slowest and fastest labels.
            lbl_time_value.config(text="")
            lbl_frequency_value.config(text="")

    # This function will be called each time
    # the user presses the "Clear" button.
    def clear():
        """Clear all the inputs and outputs."""
        btn_clear.focus()
        ent_length.clear()
        lbl_time_value.config(text="")
        lbl_frequency_value.config(text="")
        ent_length.focus()

    # Bind the calculate function to the age entry box so
    # that the computer will call the calculate function
    # when the user changes the text in the entry box.
    ent_length.bind("<KeyRelease>", calculate)

    # Bind the clear function to the clear button so
    # that the computer will call the clear function
    # when the user clicks the clear button.
    btn_clear.config(command=clear)

    # Give the keyboard focus to the age entry box.
    ent_length.focus()


# Conventional call of main function
if __name__ == "__main__":
    main()
