# Problem Statement:
# The size of a car tire in the United States is represented with three numbers like this: 205/60R15.
# The first number is the width of the tire in millimeters.
# The second number is the aspect ratio.
# The third number is the diameter in inches of the wheel that the tire fits.
# The volume of space inside a tire can be approximated with this formula:
# v = (π * w2 * a * (w * a + 2,540 * d)) / 10,000,000,000
# v is the volume in liters,
# π is the constant PI, which is the ratio of the circumference of a circle divided by its diameter (use math.pi),
# w is the width of the tire in millimeters,
# a is the aspect ratio of the tire, and
# d is the diameter of the wheel in inches.

# Write a program that asks the user for the tire width, aspect ratio, and wheel diameter.
# The program should calculate the volume of the tire and display it in liters.
# The volume should be displayed with two decimal places.

# Example Output
# Please enter the tire width in millimeters: 205
# Please enter the aspect ratio: 60
# Please enter the wheel diameter in inches: 15
# The volume of the tire is 36.55 liters.

# Hints
# Use the input() function to get the user's input.
# Use the float() function to convert the user's input to a number.
# Use the math.pi constant to get the value of PI.
# Use the round() function to round the volume to two decimal places.

import math

# This is a loop that will allow the user to rerun the program, if they choose to do so.
while True:

    # This is a more fun and self-validating way to get the user's tire width. If they do not enter a number, it will ask for a number until they do.
    tire_width = input("Please enter the width of the tire in millimeters: ")
    while not tire_width.isdigit():
        tire_width = input(
            "Please enter the width of the tire in millimeters as a number: "
        )
    tire_width = int(tire_width)

    # This is will get the user's aspect ratio (for the tire, not their PC), using the same trick as above.
    aspect_ratio = input("Please enter the aspect ratio of the tire: ")
    while not aspect_ratio.isdigit():
        aspect_ratio = input("Please enter the aspect ratio of the tire as a number: ")
    aspect_ratio = int(aspect_ratio)

    # Finally, this will ask them for the diameter of their wheel, copying the previous two input's trick.
    wheel_diameter = input("Please enter the diameter of the wheel in inches: ")
    while not wheel_diameter.isdigit():
        wheel_diameter = input(
            "Please enter the diameter of the wheel in inches as a number: "
        )
    wheel_diameter = int(wheel_diameter)

    # This keeps us from accidentally imputing the wrong number of zeros.
    ten_billion = int(10000000000)

    # Now it should math correctly.
    volume = (
        math.pi
        * tire_width**2
        * aspect_ratio
        * (tire_width * aspect_ratio + 2540 * wheel_diameter)
    ) / ten_billion

    # Tells the user what the volume of their tire is in liters, rounded to two decimal places.
    print(f"The approximate volume is {round(volume, 2)} liters.")

    # This will ask the user if they want to run the program again, and validates if they put in a weird answer.
    while True:
        again = input("Would you like to calculate another tire volume? (yes/no): ")
        if again.lower() in ("yes", "no", "y", "n", "yup", "yeah", "sure", "nope"):
            break
        print("I don't understand. Please try again.")

    # If they want to run the program again, this will continue the loop.
    if again.lower() in ("yes", "y", "yup", "yeah", "sure"):
        continue
    # If they do not want to run the program again, this will break the loop.
    else:
        # This is the exit message for the loop.
        print("Thank you. Goodbye!")
        break
