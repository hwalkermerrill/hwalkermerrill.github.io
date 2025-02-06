# Written By: Case, Harrison, and Joshua; CSE111

# Problem Statement:
# Most people around the world today have at least two names, a family name and a given name.
# In the United States, we usually write a person’s given name followed by his family name.
# However, when a computer lists names in alphabetical order, it is convenient to list the family name
# first and then the given name like this:
# >
# Toussaint; Marie
# Toussaint; Olivier
# Washington; George
# Washington; Martha

# When writing a program that alphabetizes names, it is often helpful to have the following three functions.
# >
# make_full_name - Combines a person’s given name and family name into one string with the family name first
# extract_family_name - Extracts a person’s family name from his full name
# extract_given_name - Extracts a person’s given name from his full name
# A programmer has already written those three functions.
# However, there are mistakes in at least two of the three functions.

# Assignment:
# As a team, write three test functions named test_make_full_name, test_extract_family_name, and
# test_extract_given_name. Each of the test functions will test one of three previously written program functions.
# Use pytest to run the test functions and find and fix the mistakes, if any, that are in program functions.

# Import required modules
from names import make_full_name, extract_family_name, extract_given_name
import pytest


def test_make_full_name():
    """Verify that the full_name function works correctly.
    Parameters: none
    Return: nothing
    """
    # Call the full_name function and verify that it returns a string.
    big_name = make_full_name("sally", "brown")
    assert isinstance(big_name, str), "full_name function must return a string"

    # Call the full_name function ten times and use an assert
    # statement to verify that the string returned by the
    # full_name function is correct each time.
    assert make_full_name("sally", "brown") == "Brown; Sally"
    assert make_full_name("harrison", "merrill") == "Merrill; Harrison"
    assert make_full_name("case", "robertson") == "Robertson; Case"
    assert make_full_name("joshua", "romero") == "Romero; Joshua"
    assert make_full_name("happy", "funny") == "Funny; Happy"
    assert make_full_name("cat", "dog") == "Dog; Cat"
    assert make_full_name("bird", "mouse") == "Mouse; Bird"
    assert make_full_name("jump", "joy") == "Joy; Jump"
    assert make_full_name("upBeat", "depressed") == "Depressed; Upbeat"
    assert make_full_name("TONY", "STARK") == "Stark; Tony"


def test_extract_given_name():
    """Verify that the full_name function works correctly.
    Parameters: none
    Return: nothing
    """
    # Call the full_name function and verify that it returns a string.
    f_name = extract_given_name("Brown; Sally")
    assert isinstance(f_name, str), "f_name function must return a string"

    # Call the full_name function ten times and use an assert
    # statement to verify that the string returned by the
    # full_name function is correct each time.
    assert extract_given_name("Brown; Sally") == "Sally"
    assert extract_given_name("Merrill; Harrison") == "Harrison"
    assert extract_given_name("Robertson; Case") == "Case"
    assert extract_given_name("Romero; Joshua") == "Joshua"
    assert extract_given_name("Funny; Happy") == "Happy"
    assert extract_given_name("Dog; Cat") == "Cat"
    assert extract_given_name("Mouse; Bird") == "Bird"
    assert extract_given_name("Joy; Jump") == "Jump"
    assert extract_given_name("Depressed; Upbeat") == "Upbeat"
    assert extract_given_name("Stark; Tony") == "Tony"


def test_extract_family_name():
    """Verify that the full_name function works correctly.
    Parameters: none
    Return: nothing
    """
    # Call the full_name function and verify that it returns a string.
    l_name = extract_family_name("Brown; Sally")
    assert isinstance(l_name, str), "full_name function must return a string"

    # Call the full_name function ten times and use an assert
    # statement to verify that the string returned by the
    # full_name function is correct each time.
    assert extract_family_name("Brown; Sally") == "Brown"
    assert extract_family_name("Merrill; Harrison") == "Merrill"
    assert extract_family_name("Robertson; Case") == "Robertson"
    assert extract_family_name("Romero; Joshua") == "Romero"
    assert extract_family_name("Funny; Happy") == "Funny"
    assert extract_family_name("Dog; Cat") == "Dog"
    assert extract_family_name("Mouse; Bird") == "Mouse"
    assert extract_family_name("Joy; Jump") == "Joy"
    assert extract_family_name("Depressed; Upbeat") == "Depressed"
    assert extract_family_name("Stark; Tony") == "Stark"


# Call the main function that is part of pytest so that the
# computer will execute the test functions in this file.
pytest.main(["-v", "--tb=line", "-rN", __file__])
