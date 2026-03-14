# Written By: Case, Harrison, and Joshua; CSE111

# Problem Statement:
# The Church of Jesus Christ of Latter-day Saints uses lots of computer technology to
# collect and store family history data, including data about individuals and marriages.
# Interestingly, the data about individuals must be stored separately from the data
# about marriages because some individuals get married multiple times. However, in order
# to make the data understandable to people, when a person views marriage data, a
# program must combine the marriage data and the individual data.

# Assignment:
# As a team, write a Python program that stores data about individuals in one dictionary
# and stores data about marriages in a different dictionary. Your program must combine
# the data in the two dictionaries and print the combined data so that it is
# understandable to a user. Start your program by downloading and saving the
# family_history.py Python file and then open it in VS Code and complete the Core
# Requirements.

# Core Requirements#
# > 1. Within your program, the print_death_age function must print the name and age at
# > death for each person in the people dictionary.
# > 2. The count_genders function must count and print the number of males and the number
# > of females in the people dictionary.
# > 3. The print_marriages function must print the following for each marriage in the
# > marriages dictionary:
# > > a. The name and age in the wedding year of the husband
# > > b. The year of the wedding
# > > c. The name and age in the wedding year of the wife

# Stretch Challenges#
# 1. Add code to the print_death_age function that prints the birth year and death year
# for each person.
# 2. Add to your program a function named count_marriages that counts and prints the
# number of marriages that each person had in his or her lifetime. According to the data,
# who married the most times?

# Each value in the people dictionary is a list. These
# are the indexes of the elements in those lists.
NAME_INDEX = 0
GENDER_INDEX = 1
BIRTH_YEAR_INDEX = 2
DEATH_YEAR_INDEX = 3

# Each value in the marriages dictionary is a list.
# These are the indexes of the elements in those lists.
HUSBAND_KEY_INDEX = 0
WIFE_KEY_INDEX = 1
WEDDING_YEAR_INDEX = 2


def main():
    people_dict = {
        # Each item in the people dictionary is a key value pair.
        # Each key is a unique identifier that begins with the
        # letter "P". Each value is a list of data about a person.
        # Each item in the dictionary is in this format:
        # person_key: [name, gender, birth_year, death_year]
        "P143": ["Lola Park", "F", 1663, 1706],
        "P338": ["Savanna Foster", "F", 1674, 1723],
        "P201": ["Tiffany Hughes", "F", 1689, 1747],
        "P203": ["Ignacio Torres", "M", 1693, 1758],
        "P128": ["Yasmin Li", "F", 1701, 1716],
        "P342": ["Trent Ross", "M", 1705, 1757],
        "P202": ["Samyukta Nguyen", "M", 1717, 1774],
        "P132": ["Joel Johnson", "M", 1724, 1800],
        "P445": ["Whitney Nelson", "F", 1757, 1823],
        "P318": ["Khalid Ali", "M", 1759, 1814],
        "P317": ["Davina Patel", "F", 1775, 1860],
        "P313": ["Enzo Ruiz", "M", 1782, 1782],
        "P475": ["Lauren Smith", "F", 1800, 1802],
        "P455": ["Lucas Ross", "M", 1800, 1853],
        "P435": ["Jamal Gray", "M", 1810, 1831],
        "P204": ["Fatima Soares", "F", 1812, 1898],
        "P206": ["Ephraim Foster", "M", 1831, 1885],
        "P500": ["Peter Price", "M", 1832, 1878],
        "P207": ["Rosalina Jimenez", "F", 1875, 1956],
        "P425": ["Rachel Johnson", "F", 1876, 1940],
        "P121": ["Vanessa Bennet", "F", 1880, 1960],
        "P152": ["Jose Castillo", "M", 1884, 1931],
        "P205": ["Liam Myers", "M", 1902, 1950],
        "P465": ["Isabella Lopez", "F", 1907, 1959],
        "P168": ["Megan Anderson", "F", 1909, 1945],
    }

    marriages_dict = {
        # Each item in the marriages dictionary is a key value pair.
        # Each key is a unique identifier that begins with the
        # letter "M". Each value is a list of data about a marriage.
        # Each item in the dictionary is in this format:
        # marriage_key: [husband_key, wife_key, wedding_year]
        "M48": ["P203", "P201", 1711],
        "M45": ["P342", "P338", 1722],
        "M36": ["P203", "P201", 1724],
        "M47": ["P202", "P445", 1774],
        "M21": ["P132", "P445", 1775],
        "M59": ["P132", "P317", 1792],
        "M63": ["P318", "P445", 1804],
        "M12": ["P318", "P317", 1808],
        "M54": ["P435", "P204", 1830],
        "M34": ["P455", "P204", 1853],
        "M55": ["P500", "P317", 1859],
        "M52": ["P206", "P204", 1875],
        "M78": ["P152", "P121", 1905],
        "M50": ["P152", "P425", 1917],
        "M64": ["P205", "P465", 1925],
        "M62": ["P152", "P207", 1925],
        "M70": ["P152", "P168", 1928],
    }

    # Call the print_death_age function to print
    # each person's name and age at death.
    print_death_age(people_dict)

    # Print a blank line.
    print()

    # Call the count_genders function to count
    # and print the number of males and females.
    count_genders(people_dict)

    # Print a blank line.
    print()

    # Call the print_marriages function to print
    # human readable data about the marriages.
    print_marriages(marriages_dict, people_dict)

    # Print a blank line.
    print()

    # Print count marriages (adds values to existing keys)
    count_marriages(marriages_dict, people_dict)


def print_death_age(people_dict):
    """For each person in the people dictionary,
    print the person's name and age at death."""
    print("Ages at Death:")
    for person in people_dict.values():
        name = person[NAME_INDEX]
        birth_year = person[BIRTH_YEAR_INDEX]
        death_year = person[DEATH_YEAR_INDEX]
        age_at_death = death_year - birth_year
        print(
            f"{name}: Born {birth_year}, died {death_year} at ~{age_at_death} years old."
        )
    pass


def count_genders(people_dict):
    """Count and print the number of males
    and females in the people dictionary.
    """
    males = 0
    females = 0
    for person in people_dict.values():
        gender = person[GENDER_INDEX]
        if gender == "M":
            males += 1
        elif gender == "F":
            females += 1

    print(f"There are {males} males and {females} females in this record.")
    pass


def print_marriages(marriages_dict, people_dict):
    """For each marriage in the marriages dictionary, print
    the husband's name, his age at wedding, the wedding year,
    the wife's name, and her age at wedding.
    """
    print("Marriages:")
    for marriage in marriages_dict.values():
        husband_key = marriage[HUSBAND_KEY_INDEX]
        wife_key = marriage[WIFE_KEY_INDEX]
        wedding_year = marriage[WEDDING_YEAR_INDEX]

        husband = people_dict[husband_key]
        wife = people_dict[wife_key]

        husband_name = husband[NAME_INDEX]
        husband_birth_year = husband[BIRTH_YEAR_INDEX]
        husband_marriage_age = wedding_year - husband_birth_year

        wife_name = wife[NAME_INDEX]
        wife_birth_year = wife[BIRTH_YEAR_INDEX]
        wife_marriage_age = wedding_year - wife_birth_year

        print(
            f"Mr. {husband_name} (age: {husband_marriage_age}) and Mrs. {wife_name} (age: {wife_marriage_age}) were married in {wedding_year}."
        )
    pass


def count_marriages(marriages_dict, people_dict):
    # adds a marriage count for each person in the dictionary
    for person in people_dict:
        people_dict[person].append(0)

    # Counts marriages for each person
    for marriage in marriages_dict.values():
        husband_key = marriage[HUSBAND_KEY_INDEX]
        wife_key = marriage[WIFE_KEY_INDEX]

        # iterates for each person in dictionary, based on gender (for optimization at scale)
        if husband_key in people_dict and people_dict[husband_key][GENDER_INDEX] == "M":
            people_dict[husband_key][-1] += 1
        if wife_key in people_dict and people_dict[wife_key][GENDER_INDEX] == "F":
            people_dict[wife_key][-1] += 1

    # max is used to find the highest value, [-1] means to check the last element of the x[1] list IE people_dict
    most_married_person = max(people_dict.items(), key=lambda x: x[1][-1])

    print(
        f"The person with the most marriages is: {most_married_person[1][NAME_INDEX]} with {most_married_person[1][-1]} marriages"
    )


if __name__ == "__main__":
    main()
