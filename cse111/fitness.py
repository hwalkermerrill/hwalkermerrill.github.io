# Written 1/22/25 by Harrison and Case, CSE111

# Problem Statement:
# Health professionals who are helping a client achieve a healthy body weight,
# sometimes use two computed measures named body mass index and basal metabolic rate.
# >
# From the U.S. Centers for Disease Control and Prevention we read:
# Body mass index (BMI) is a person’s weight in kilograms divided by the square of their height in meters.
# BMI can be used to screen for weight categories such as underweight, normal, overweight, and obese that
# may lead to health problems. However, BMI is not diagnostic of the body fatness or health of an individual.
# The formula for computing BMI is:
# >  bmi = (10,000 * weight) / height2
# >  where weight is in kilograms and height is in centimeters.
# >
# Basal metabolic rate (BMR) is the minimum number of calories required daily to keep your body functioning at rest.
# BMR is different for women and men and changes with age. The revised Harris-Benedict formulas for computing BMR are:
# >  (women)  bmr = 447.593 + 9.247 * weight + 3.098 * height − 4.330 * age
# >  (men)  bmr = 88.362 + 13.397 * weight + 4.799 * height − 5.677 * age
# >  where weight is in kilograms and height is in centimeters.

# Assignment:
# Work as a team to write a Python program named fitness.py that does the following:
# Asks the user to enter four values:
# >  1. gender
# >  2. birthdate in this format: YYYY-MM-DD
# >  3. weight in U.S. pounds
# >  4. height in U.S. inches
# Converts the weight from pounds to kilograms (1 lb = 0.45359237 kg).
# Converts inches to centimeters (1 in = 2.54 cm).
# Calculates age, BMI, and BMR.
# Prints age, weight in kg, height in cm, BMI, and BMR.

# Asks user to enter information
# First part inputs and validates users biological gender
while True:
    gender = input("Enter your Biological Gender (male/female): ")
    if gender.lower() in (
        "male",
        "female",
        "girl",
        "boy",
        "man",
        "women",
        "m",
        "f",
        "g",
        "b",
        "dude",
        "chick",
    ):
        break
    print("I don't understand. Please enter Male or Female (m/f): ")
if gender.lower() in ("male, b, man, m, boy, dude"):
    gender_male = True
else:
    gender_male = False

# Second part inputs and validates user's birthdate
from datetime import datetime

today = datetime.today()
while True:
    birthdate = input("Enter your Birthdate (YYYY-MM-DD): ")
    birthdate = datetime.strptime(birthdate, "%Y-%m-%d")
    age = (
        today.year
        - birthdate.year
        - ((today.month, today.day) < (birthdate.month, birthdate.day))
    )
    if age > 0:
        break
    print(
        "I don't understand. Are you a time traveler? Please enter a past birthdate: "
    )

# Third part asks user to enter their height and weight
weight_lb = int(input("Enter your Weight in U.S. Pounds: "))
height_in = int(input("Enter your Height in U.S. Inches: "))

# Converts weight and height from imperial to metric
weight_kg = weight_lb * 0.45359237
height_cm = height_in * 2.54

# Calculates BMI
bmi = (10000 * weight_kg) / (height_cm**2)

# Calculates BMR
if gender_male == True:
    bmr = 88.362 + 13.397 * weight_kg + 4.799 * height_cm - 5.677 * age
else:
    bmr = 447.593 + 9.247 * weight_kg + 3.098 * height_cm - 4.330 * age

# Prints results
if gender_male == True:
    print(f"Sir, your BMI is: {bmi:.2f} and your BMR is: {bmr:.2f}")
    print(
        f"This was calculated using your age ({age}), weight ({weight_kg:.1f}kg), and height ({height_cm:.1f}cm)"
    )
else:
    print(f"SMa'am, your BMI is: {bmi:.2f} and your BMR is: {bmr:.2f}")
    print(
        f"This was calculated using your age ({age}), weight ({weight_kg:.1f}kg), and height ({height_cm:.1f}cm)"
    )
