# Written By: Case, Harrison, and Joshua; CSE111

# Problem Statement:
# A common task for many knowledge workers is to use a number, key, or ID to find
# information about a person. For example, a knowledge worker may use a phone number
# or e-mail address as a key to find (or look up) additional information about a
# customer. During this activity, your team will write a Python program that uses a
# student’s I-Number to look up the student’s name.

# Assignment
# As a team, write a Python program named students.py that has at least two functions
# named main and read_dictionary. You must write the read_dictionary function with one
# of the following two headers and documentation strings. Choose the header that makes
# the most sense to you.

# Core Requirements:
# Your program must do the following:
# 1. Open the students.csv file for reading, skip the first line of text in the file
# because it contains only headings, and read the other lines of the file into a
# dictionary. The program must store each student I-Number as a key and each I-Number
# name pair or each name as a value in the dictionary.
# 2. Get an I-Number from the user, use the I-Number to find the corresponding student
# name in the dictionary, and print the name.
# 3. If a user enters an I-Number that doesn’t exist in the dictionary, your program
# must print the message, "No such student" (without the quotes).

# Imports
import csv


def read_dictionary(filename):
    """Read the contents of a CSV file into a
    dictionary and return the dictionary.

    Parameters
        filename: the name of the CSV file to read.
    Return: a dictionary that contains
            the contents of the CSV file.
    """
    students = {}

    with open(filename, "r") as file:
        # skip first line
        next(file)

        for line in file:
            # remove whitespace, split i-number and ame on comma
            parts = line.strip().split(",")
            i_number = parts[0].strip()
            name = parts[1].strip()

            # Create key-value pair in students dictionary
            students[i_number] = name

    return students


def main():
    # Read filename into read_dictionary function
    filename = "students.csv"
    student_dict = read_dictionary(filename)

    # Prompt for an I-number
    i_number = input("Please enter an I-number: ").strip()

    # Validation
    if not i_number.isdigit() or len(i_number) != 9:
        print("Invalid I_Number")
        return

    if i_number in student_dict:
        print(f"Student Name: {student_dict[i_number]}")
    else:
        print("No such Student")


if __name__ == "__main__":
    main()
