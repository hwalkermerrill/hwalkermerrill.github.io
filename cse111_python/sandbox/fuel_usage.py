# Problem Statement:
# Many vehicle owners record the fuel efficiency of their vehicles as a way to track the health of the vehicle.
# If the fuel efficiency of a vehicle suddenly drops, there is probably something wrong with the engine or drive
# train of the vehicle. In the United States, fuel efficiency for gasoline powered vehicles is calculated as
# miles per gallon. In most other countries, fuel efficiency is calculated as liters per 100 kilometers.

# Formulas for the Assignment:
# The formula for computing fuel efficiency in miles per gallon is the following:
# >  mpg =
# >  end − start (where start and end are both odometer values in miles and gallons is a fuel amount in U.S. gallons)
# >  gallons
# The formula for converting miles per gallon to liters per 100 kilometers is the following:
# >  lp100k =
# >  235.215
# >  mpg

# Assignment
# Write a Python program that asks the user for three numbers:
# >  1. A starting odometer value in miles
# >  2. An ending odometer value in miles
# >  3. An amount of fuel in gallons
# Your program must calculate and print fuel efficiency in both miles per gallon and liters per 100 kilometers.
# Your program must have three functions named as follows:
# >  main
# >  miles_per_gallon
# >  lp100k_from_mpg
# Note: All user input and printing must be in the main function. In other words, the miles_per_gallon
# and lp100k_from_mpg functions must not call the the input or print functions.


# This is the main function that will call the other functions
def main():
    odometer_start = float(input("Please enter the starting odometer value in miles: "))
    odometer_end = float(input("Please enter the ending odometer value in miles: "))
    if odometer_end <= odometer_start:
        print(
            "The ending odometer value must be greater than the starting odometer value."
        )
        return
    fuel_amount = float(input("Please enter the amount of fuel used in US gallons: "))
    if fuel_amount <= 0:
        print("The fuel amount must be greater than zero.")
        return

    # Call the below functions using validated user input.
    mpg = miles_per_gallon(odometer_start, odometer_end, fuel_amount)
    lp100k = lp100k_from_mpg(mpg)

    # Prints the results.
    print(f"The US fuel efficiency is {mpg:.1f} miles per gallon.")
    print(f"The Metric fuel efficiency is {lp100k:.2f} liters per 100 kilometers.")

    pass


# This function computes and returns the average mpg of the user.
def miles_per_gallon(start_miles, end_miles, amount_gallons):
    # This is the formula for computing fuel efficiency in miles per gallon:
    return (end_miles - start_miles) / amount_gallons


def lp100k_from_mpg(mpg):
    # This is the formula for converting miles per gallon to liters per 100 kilometers:
    return 235.215 / mpg


# Call the main function so that
# this program will start executing.
main()
