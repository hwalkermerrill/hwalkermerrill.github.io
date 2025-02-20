# Written By: Case, Harrison, and Joshua; CSE111

# Assignment:
# As a team, write a Python program named random_numbers.py that creates a list of
# numbers, appends more numbers onto the list, and prints the list. The program must
# have two functions named main and append_random_numbers as follows:

# def main():
# > Has no parameters
# > Creates a list named numbers like this: numbers = [16.2, 75.1, 52.3]
# > Prints the numbers list
# > Calls the append_random_numbers function with only one argument to add
# one number to numbers
# > Prints the numbers list
# > Calls the append_random_numbers function again with two arguments to add
# three numbers to numbers
# > Prints the numbers list

# def append_random_numbers(numbers_list, quantity=0):
# > Has two parameters: a list named numbers_list and an integer named quantity.
# The parameter quantity has a default value of 1
# > Computes quantity pseudo random numbers by calling the random.uniform function.
# > Rounds the quantity pseudo random numbers to one digit after the decimal.
# > Appends the quantity pseudo random numbers onto the end of the numbers_list.

# At the bottom of your program, write an if statement that calls the main function.
# Then run your program and verify that your program works correctly.

# Stretch Challenges
# Add a function named append_random_words that meets the following criteria:
# > Has two parameters: a list named words_list and an integer named quantity.
# The parameter quantity has a default value of 1
# > Randomly selects quantity words from a list of words and appends the selected
# words at the end of words_list.


# Imported modules here
import random


# appends random numbers to numbers list
def append_random_numbers(numbers_list, quantity=1):
    for _ in range(quantity):
        random_number = round(random.uniform(0, 100), 1)
        numbers_list.append(random_number)


def append_random_words(words_list, quantity=1):
    available_words = [
        "chicken tortilla soup",
        "enchiladas",
        "pizza",
        "smoked ribs",
        "bao",
        "burgers",
        "sushi",
        "roasted baked potatoes",
        "cesar salad",
        "twinkies",
        "shrimp fettucini alfredo",
        "smoked corn",
        "mashed potatoes",
        "garlic bread",
        "steak and fries",
        "mango sago",
        "lemon yogurt",
        "sweet and sour chicken",
        "yakiniku (japanese bbq)",
        "cinnamon churros",
        "taco rice",
        "fried chicken",
    ]
    for _ in range(quantity):
        random_word = random.choice(available_words)
        words_list.append(random_word)


# main function for proof
def main():
    numbers = [16.2, 75.1, 52.3]
    words = ["I want to eat: "]
    # print("Initial numbers list:", numbers)

    # append_random_numbers(numbers)
    # print("After adding one random number:", numbers)

    # append_random_numbers(numbers, 3)
    # print("After adding three random numbers:", numbers)

    append_random_words(words, 3)
    print("After adding some random food words:", words)


if __name__ == "__main__":
    main()
