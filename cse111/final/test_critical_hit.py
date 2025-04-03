# Created by Harrison Merrill 2025.03.30 - CSE 111

# imports
import pytest
import csv
import random

from critical_hit import (
    build_critical_effects,
    get_random_bonus,
    calculate_severity,
    lower_severity,
    explosive_critical,
    get_available_filters,
    search_critical_effects,
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
CRITICAL_MULTIPLIERS = {"x2": 2, "x3": 3, "x4": 4}
CRITICAL_SEVERITY = {
    "minor": (1, 20),
    "moderate": (21, 30),
    "serious": (31, 40),
    "deadly": (41, 90),
}

# Global Variables from file
CRITICAL_EFFECTS = {}
critical_is_serious = False
critical_is_lethal = False
critical_is_explosive = False


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
def test_calculate_severity():
    """
    Run multiple tests of the calculate_severity function:

    1. Call calculate_severity and verify that it returns a string
    2. Check that severity returned is within expected ranges
    3. Test critical is serious flag
    4. Check that severity returns no effect if negative or 0 is encountered
    5. Test critical multiplier effect on severity
    6. Test critical type "fumble" changes the calculation correctly
    7. Test special critical_is_lethal rule
    """

    # define variables for testing
    attack_roll = 10
    target_ac = 10
    critical_multiplier = 2
    critical_type = "crit"
    is_serious = False
    random_bonus_override = 1
    global CRITICAL_SEVERITY
    global critical_is_lethal

    # Call calculate_severity and verify that it returns a string:
    severity = calculate_severity(
        attack_roll,
        target_ac,
        critical_multiplier,
        critical_type,
        is_serious,
        random_bonus_override,
    )
    assert isinstance(severity, str), (
        "calculate_severity function must return a string: "
        f" expected a string but found a {type(severity)}"
    )

    # Check that severity returned is within expected ranges:
    while random_bonus_override <= 60:
        severity = calculate_severity(
            attack_roll,
            target_ac,
            critical_multiplier,
            critical_type,
            is_serious,
            random_bonus_override,
        )
        running_total = (attack_roll - target_ac) + random_bonus_override
        expected = None
        for sev, (lower, upper) in CRITICAL_SEVERITY.items():
            if lower <= running_total <= upper:
                expected = sev
                break

        assert (
            severity == expected
        ), f"Severity test failed. Expected {expected} but got {severity}"

        random_bonus_override += 1

    # reset random_bonus override for next test
    random_bonus_override = 1

    # Test critical is serious flag
    while random_bonus_override < 20:
        severity = calculate_severity(
            attack_roll,
            target_ac,
            critical_multiplier,
            critical_type,
            is_serious=True,
            random_bonus_override=random_bonus_override,
        )
        running_total = 20 + (attack_roll - target_ac) + random_bonus_override
        expected = None
        for sev, (lower, upper) in CRITICAL_SEVERITY.items():
            if lower <= running_total <= upper:
                expected = sev
                break

        assert (
            severity == expected
        ), f"critical_is_serious test failed. Expected {expected} but got {severity}"

        random_bonus_override += 1

    # reset random_bonus override for next test
    random_bonus_override = 1

    # Check that severity returns no effect if negative or 0 is encountered:
    target_ac = 20
    while attack_roll < 20:
        severity = calculate_severity(
            attack_roll,
            target_ac,
            critical_multiplier,
            critical_type,
            is_serious,
            random_bonus_override,
        )

        assert severity is None, f"Expected None for no effect, got {severity}"

        attack_roll += 1

    # reset target_ac, attack_roll, and global critical_is_lethal flag for next test
    attack_roll = 10
    target_ac = 10

    # Test critical multiplier effect on severity
    random_bonus_override = 20
    for multiplier, extra in [(2, 0), (3, 5), (4, 10)]:
        severity = calculate_severity(
            attack_roll,
            target_ac,
            critical_multiplier,
            critical_type,
            is_serious,
            random_bonus_override,
        )
        val = (attack_roll - target_ac) + random_bonus_override + extra
        expected = None
        for sev, (lower, upper) in CRITICAL_SEVERITY.items():
            if lower <= val <= upper:
                expected = sev
                break

        assert (
            severity == expected
        ), f"Critical multiplier was supposed to change the severity"

        critical_multiplier += 1

    # reset critical multiplier and random bonus
    critical_multiplier = 2
    random_bonus_override = 1

    # Test critical type "fumble" changes the calculation correctly
    critical_type = "fumble"
    target_ac = 20
    severity = calculate_severity(
        attack_roll,
        target_ac,
        critical_multiplier,
        critical_type,
        is_serious,
        random_bonus_override,
    )
    expected = None
    for sev, (lower, upper) in CRITICAL_SEVERITY.items():
        if lower <= 1 <= upper:
            expected = sev
            break
    assert (
        severity == expected
    ), f"Fumble test failed. Expected {expected}, but got {severity}"

    # reset target_ac and critical_is_lethal global flag for next test
    target_ac = 10
    critical_is_lethal = False

    # Test special critical_is_lethal rule
    severity = calculate_severity(
        attack_roll,
        target_ac,
        critical_multiplier,
        critical_type,
        is_serious=True,
        random_bonus_override=20,
    )
    expected = None
    for sev, (lower, upper) in CRITICAL_SEVERITY.items():
        expected = upper
        break
    assert severity == "deadly", f"Expected {expected} for special rule, got {severity}"


def test_lower_severity():
    # Standard cases: severity should go down one step
    assert (
        lower_severity("deadly") == "serious"
    ), "Expected 'serious' when lowering 'deadly'"
    assert (
        lower_severity("serious") == "moderate"
    ), "Expected 'moderate' when lowering 'serious'"
    assert (
        lower_severity("moderate") == "minor"
    ), "Expected 'minor' when lowering 'moderate'"

    # Minor severity is minimum, and an input of minor or unknown should default to minor.
    assert lower_severity("minor") == "minor", "Expected 'minor' to remain 'minor'"
    assert (
        lower_severity("unknown") == "minor"
    ), "Expected unknown severity to default to 'minor'"


def test_explosive_critical():
    """
    Run multiple tests of the explosive_critical function:

    1. If lethal is True, it returns the original severity and sets critical_is_explosive True.
    2. If bonus equals 20 (with serious False), it lowers the severity and sets the explosive flag.
    3. If bonus equals 1 with serious False, it lowers the severity.
    4. If bonus equals 1 with serious True, it leaves severity unchanged.
    5. If bonus is neither 1 nor 20, it leaves severity unchanged.
    """
    # Reset the function's __globals__:
    explosive_critical.__globals__["critical_is_lethal"] = False
    explosive_critical.__globals__["critical_is_explosive"] = False
    explosive_critical.__globals__["critical_is_serious"] = False

    # If lethal is True, it returns the original severity and sets critical_is_explosive True.
    severity_orig = "moderate"
    result = explosive_critical(
        severity_orig, random_bonus_override=10, lethal=True, serious=False
    )
    assert (
        result == severity_orig
    ), "When lethal is True, explosive_critical should return the original severity."
    assert (
        explosive_critical.__globals__["critical_is_explosive"] is True
    ), "When lethal is True, critical_is_explosive must be set to True."

    # Reset the function's __globals__:
    explosive_critical.__globals__["critical_is_lethal"] = False
    explosive_critical.__globals__["critical_is_explosive"] = False
    explosive_critical.__globals__["critical_is_serious"] = False

    # If bonus equals 20 (with serious False), it lowers the severity and sets the explosive flag.
    severity_orig = "serious"
    expected = lower_severity(severity_orig)
    result = explosive_critical(
        severity_orig, random_bonus_override=20, lethal=False, serious=False
    )
    assert (
        result == expected
    ), f"For bonus=20 (serious False), expected {expected} but got {result}."
    assert (
        explosive_critical.__globals__["critical_is_explosive"] is True
    ), "For bonus=20, critical_is_explosive should be set True."

    # Reset the function's __globals__:
    explosive_critical.__globals__["critical_is_lethal"] = False
    explosive_critical.__globals__["critical_is_explosive"] = False
    explosive_critical.__globals__["critical_is_serious"] = False

    # If bonus equals 1 with serious False, it lowers the severity.
    severity_orig = "moderate"
    expected = lower_severity(severity_orig)
    result = explosive_critical(
        severity_orig, random_bonus_override=1, lethal=False, serious=False
    )
    assert (
        result == expected
    ), f"For bonus=1 (serious False), expected {expected} but got {result}."
    assert (
        explosive_critical.__globals__["critical_is_explosive"] is False
    ), "For bonus=1 and serious False, critical_is_explosive should remain False."

    # Reset the function's __globals__:
    explosive_critical.__globals__["critical_is_lethal"] = False
    explosive_critical.__globals__["critical_is_explosive"] = False
    explosive_critical.__globals__["critical_is_serious"] = False

    # If bonus equals 1 with serious True, it leaves severity unchanged.
    severity_orig = "moderate"
    result = explosive_critical(
        severity_orig, random_bonus_override=1, lethal=False, serious=True
    )
    assert (
        result == severity_orig
    ), f"When bonus=1 and serious is True, expected severity to remain {severity_orig}, but got {result}."
    assert (
        explosive_critical.__globals__["critical_is_explosive"] is False
    ), "For bonus=1 and serious True, critical_is_explosive should remain False."

    # Reset the function's __globals__:
    explosive_critical.__globals__["critical_is_lethal"] = False
    explosive_critical.__globals__["critical_is_explosive"] = False
    explosive_critical.__globals__["critical_is_serious"] = False

    # If bonus is neither 1 nor 20, it leaves severity unchanged.
    explosive_critical.__globals__["critical_is_lethal"] = False
    explosive_critical.__globals__["critical_is_explosive"] = False
    severity_orig = "serious"
    result = explosive_critical(
        severity_orig, random_bonus_override=10, lethal=False, serious=False
    )
    assert (
        result == severity_orig
    ), f"For bonus not equal to 1 or 20, expected {severity_orig} but got {result}."
    assert (
        explosive_critical.__globals__["critical_is_explosive"] is False
    ), "For bonus 10, critical_is_explosive should remain False."

    # Reset the function's __globals__:
    explosive_critical.__globals__["critical_is_lethal"] = False
    explosive_critical.__globals__["critical_is_explosive"] = False
    explosive_critical.__globals__["critical_is_serious"] = False


def test_search_critical_effects():
    # When severity is None:
    result = search_critical_effects(None)
    expected_no_effect = "(No Critical Effect, " ", " ", " ")"
    assert (
        result == expected_no_effect
    ), f"Expected {expected_no_effect} for severity None, got {result}"
    # Also try an invalid severity string.
    result = search_critical_effects("invalid")
    assert (
        result == expected_no_effect
    ), f"Expected {expected_no_effect} for invalid severity, got {result}"

    # Clear any existing data and create our own test effects.
    CRITICAL_EFFECTS.clear()
    CRITICAL_EFFECTS["moderate"] = [
        {
            "index": "1",
            "value": "moderate",
            "types": ["condition", "effect"],
            "effect": ["Stunned", "Dizzy"],
            "quality": ["1 round", "2 rounds"],
            "details": "Test details for stunned/ dizzy",
            "titles": ["Crippling Impact", "Forceful Strike"],
        }
    ]
    CRITICAL_EFFECTS["serious"] = [
        {
            "index": "2",
            "value": "serious",
            "types": ["nonexistent"],
            "effect": "Knocked Unconscious",
            "quality": ["1 round"],
            "details": "Unconscious condition details",
            "titles": ["Crushing Blow"],
        }
    ]

    # Test when no matching effect is found
    result_none = search_critical_effects("serious")
    assert (
        result_none is None
    ), "Expected None when no matching effect is found for 'serious'."

    # Test when a matching result is found
    result = search_critical_effects("moderate")
    assert isinstance(result, tuple), f"Expected tuple, got {type(result)}"
    assert len(result) == 4, f"Expected tuple length 4, got length {len(result)}"

    selected_title, effect_options, selected_quality, details = result

    # Verify that the returned components come from our test data and not elsewhere.
    test_effect = CRITICAL_EFFECTS["moderate"][0]
    assert (
        selected_title in test_effect["titles"]
    ), f"Selected title {selected_title} not found in {test_effect['titles']}"
    assert (
        effect_options in test_effect["effect"]
    ), f"Effect option {effect_options} not in expected list {test_effect['effect']}"
    assert (
        selected_quality in test_effect["quality"]
    ), f"Selected quality {selected_quality} not in {test_effect['quality']}"
    assert (
        details == test_effect["details"]
    ), f"Details {details} do not match expected {test_effect['details']}"


# Call the main function that is part of pytest so that the
# computer will execute the test functions in this file.
pytest.main(["-v", "--tb=line", "-rN", __file__])
