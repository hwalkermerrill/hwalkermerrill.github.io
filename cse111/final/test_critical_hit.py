# Created by Harrison Merrill 2025.03.30 - CSE 111

# imports
import pytest
import csv
import random

from critical_hit import (
    get_random_bonus,
    calculate_severity,
    build_critical_effects,
    search_critical_effects,
    get_available_filters,
)

# Indexes from file
MASTER_INDEX = 0
VALUE_INDEX = 1
TYPE_INDEX = 2
EFFECT_INDEX = 3
SEVERITY_INDEX = 4
DETAILS_INDEX = 5
TITLE_INDEX = 6

# Constants from file
CRITICAL_EFFECTS_FILE = "crit_effects.csv"
CRITICAL_EFFECTS = {}
CRITICAL_MULTIPLIERS = {"x2": 2, "x3": 3, "x4": 4}
CRITICAL_SEVERITY = {
    "minor": (0, 19),
    "moderate": (20, 34),
    "serious": (35, 44),
    "deadly": (45, 60),
}


# Verify the rest_random_bonus function works correctly.
def test_random_bonus():

    # Call the get_random_bonus function and verify that it returns an int.
    bonus = get_random_bonus()
    assert isinstance(bonus, int), (
        "get_random_bonus function must return a number: "
        f" expected a number but found a {type(bonus)}"
    )

    # Call the get_random_bonus function ten times and use an assert statement to verify
    # that the number returned by is between 1 and 20 each time.
    for _ in range(10):
        bonus = get_random_bonus()
        assert 1 <= bonus <= 20, f"bonus must be between 1 and 20: {bonus}"

    # Test that the override argument works correctly
    override = 1
    while override <= 20:
        bonus = get_random_bonus(override)
        assert bonus == override, f"bonus must be {override}: {bonus}"
        override += 1


# Verify the calculate_severity function works correctly.


# Call the main function that is part of pytest so that the
# computer will execute the test functions in this file.
pytest.main(["-v", "--tb=line", "-rN", __file__])
