"""
When you physically exercise to strengthen your heart, you
should maintain your heart rate within a range for at least 20
minutes. To find that range, subtract your age from 220. This
difference is your maximum heart rate per minute. Your heart
simply will not beat faster than this maximum (220 - age).
When exercising to strengthen your heart, you should keep your
heart rate between 65% and 85% of your heart’s maximum rate.
"""

# This program ask's the user for their age and then calculates and prints their target exercise heart rate.

# This uses int(input()) instead of input() so user's input is stored as a number instead of a string. Not doing this means it can't math correctly.
# age = int(input("Please enter your age: "))

# This is a more fun and self-validating way to get the user's age. If they do not enter a number, it will ask for a number until they do.
age = input("Please enter your age: ")
while not age.isdigit():
    age = input("Please enter your age as a number: ")
age = int(age)

# Now it math's correctly.
max_heart_rate = 220 - age
low_target = max_heart_rate * 0.65
high_target = max_heart_rate * 0.85

# Tells the user what their target heart rate is so they get the most from their workout and don't hurt themselves.
print(
    f"When you exercise to strengthen your heart, you should keep your heart rate between {low_target} and {high_target} beats per minute."
)
