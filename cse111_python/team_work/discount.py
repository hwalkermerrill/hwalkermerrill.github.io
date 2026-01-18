# Problem Statement:
# You work for a retail store that wants to increase sales on Tuesday and Wednesday,
# which are the store’s slowest sales days. On Tuesday and Wednesday, if a customer’s subtotal is $50 or greater,
# the store will discount the customer’s subtotal by 10%.

# Assignment:
# Work as a team to write a Python program named discount.py that gets a customer’s subtotal as input
# and gets the current day of the week from your computer’s operating system. Your program must not ask the user to enter
# the day of the week. Instead, it must get the day of the week from your computer’s operating system.
# If the subtotal is $50 or greater and today is Tuesday or Wednesday, your program must subtract 10% from the subtotal.
# Your program must then compute the total amount due by adding sales tax of 6% to the subtotal.
# Your program must print the discount amount if applicable, the sales tax amount, and the total amount due.

# This lets math do math and time do time, as they should. Without, they do not.
# import math
# This time, no real math is needed so import math is removed for CPU resource preservation :(
from datetime import datetime

# This makes time do time, as it should.
current_date = datetime.now()
day_of_week = current_date.weekday()

# Creates discount and tax variables for later use.
discount_10 = 0.10
tax_6 = 0.06

# Asks customer for subtotal
subtotal = float(input("Please enter the subtotal: "))

# Checks if the subtotal is greater than or equal to $50 and if it is Tuesday or Wednesday.
if subtotal >= 50 and (day_of_week == 1 or day_of_week == 2):
    discount = subtotal * discount_10
else:
    discount = 0

pre_tax_total = subtotal - discount

# Calculates the sales tax
sales_tax = pre_tax_total * tax_6

# Calculates the total amount due
total_amount_due = pre_tax_total + sales_tax

# Prints the discount amount, sales tax amount, and total amount due
print(f"Discount amount: ${discount:.2f}")
print(f"Sales tax amount: ${sales_tax:.2f}")
print(f"Total amount due: ${total_amount_due:.2f}")
