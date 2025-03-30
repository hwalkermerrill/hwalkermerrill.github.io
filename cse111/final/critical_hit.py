# Created by Harrison Merrill 2025.03.21 - CSE 111

# The purpose of this program is to read data from critical_effects.csv and convert that
# csv file into a dictionary. The dictionary will be used to calculate the effect of
# a critical hit or critical fumble that occurs when a player confirms a crit or fumble.

# The program takes users input of their attack roll, the target's AC, the critical
# multiplier of the weapon (defaulting to x2), and the weapon type (melee, ranged, or
# natural), with it defaulting to melee. The program will also allow the player to input
# if the confirmation roll was a 20 or a 1 , resulting in either a critical smash or a
# catastrophe respectively. The program will them choose a random number from 1 to 20
# and add it to the attack roll minus the target's AC, with an additional +20 if crit or
# fumble was a smash or a catastrophe, and a +5/+10 if the weapon is a x3/x4 weapon.
# Using this final sum, the program will determine if the crit effect is minor (0-20),
# moderate (21-30), severe (31-40), or deadly (41+). The program will then filter the
# critical_effects dictionary for the weapon type and the severity of the effect, and
# return a list of the effects that are associated with that severity. The program will
# then randomly select one of the effects from the list and return it to the user.


# Imports
import csv
import random
import math
import tkinter as tk
from tkinter import Frame, Label, Button

# from number_entry import FloatEntry
import os


# Indexes for the critical effects CSV file
MASTER_INDEX = 0
VALUE_INDEX = 1
TYPE_INDEX = 2
EFFECT_INDEX = 3
SEVERITY_INDEX = 4
DETAILS_INDEX = 5
TITLE_INDEX = 6

# Constants
CRITICAL_EFFECTS_FILE = "crit_effects.csv"
CRITICAL_MULTIPLIERS = {"x2": 2, "x3": 3, "x4": 4}
CRITICAL_SEVERITY = {
    "minor": (1, 19),
    "moderate": (20, 32),
    "serious": (33, 44),
    "deadly": (45, 60),
}

# Global Variables
CRITICAL_EFFECTS = {}
critical_is_serious = False
critical_is_lethal = False
critical_is_explosive = False


# Function to read the critical effects from the CSV file
def build_critical_effects():
    """
    Build the CRITICAL_EFFECTS dictionary by reading entries from CRITICAL_EFFECTS_FILE.

    The key for this dictionary will be the effect's value (severity level: "minor", "moderate", etc.).
    Each entry's fields (such as the 'type', 'severity', and 'title' columns) are split on " | "
    so that they can later be filtered. Effect entries that apply to a particular severity level
    are stored in a list under that key.

    Returns:
            dict: Global CRITICAL_EFFECTS dictionary where keys are severity values
                      (minor, moderate, severe, deadly) and each entry is a list of effect dictionaries.
    """
    global CRITICAL_EFFECTS
    CRITICAL_EFFECTS = {}  # Reset (if needed)

    with open(CRITICAL_EFFECTS_FILE, "r", newline="") as file:
        reader = csv.reader(file)
        header = next(reader, None)  # Skip header row (if present)

        for row in reader:
            if len(row) < 7:
                continue  # or raise an error if the CSV format is critical

            # The 'value' in the CSV indicates the critical effect severity (e.g., "minor")
            crit_value = row[VALUE_INDEX].strip()

            # Split the fields that include multiple alternative entries.
            # For 'type', 'severity' (additional flavor – not the same as crit_value), and 'title':
            types = [t.strip() for t in row[TYPE_INDEX].split("|")]
            effect_text = row[EFFECT_INDEX].strip()
            severity_info = [s.strip() for s in row[SEVERITY_INDEX].split("|")]
            details = row[DETAILS_INDEX].strip()
            titles = [title.strip() for title in row[TITLE_INDEX].split("|")]

            # Create a dictionary for this effect entry.
            effect_entry = {
                "index": row[
                    MASTER_INDEX
                ].strip(),  # if you need the master index later
                "value": crit_value,
                "types": types,
                "effect": effect_text,
                "severity": severity_info,  # additional flavor/duration info from CSV
                "details": details,
                "titles": titles,
            }

            # Add the entry under the corresponding crit_value key.
            if crit_value not in CRITICAL_EFFECTS:
                CRITICAL_EFFECTS[crit_value] = []
            CRITICAL_EFFECTS[crit_value].append(effect_entry)

    return CRITICAL_EFFECTS


def get_random_bonus(bonus_override=None):
    """Returns a random integer between 1 and 20 unless an override is provided."""
    if bonus_override is not None:
        return bonus_override
    else:
        return random.randint(1, 20)


# Function to calculate the critical effect based on the attack roll and other parameters
def calculate_severity(
    attack_roll,
    target_ac,
    critical_multiplier,
    critical_type="crit",
    is_serious=None,
    random_bonus_override=None,
):
    """
    Calculate the severity of a critical hit or fumble.

    Parameters:
        attack_roll (int): The attack roll value.
        target_ac (int): The target's Armor Class.
        critical_multiplier (str): The weapon's critical multiplier ("x2", "x3", or "x4").
        critical_type (str, optional): "crit" (default) or "fumble".
        is_serious (bool, optional): True if the hit/fumble is particularly serious (a smash or catastrophe).

    Returns:
        str: A severity level ("minor", "moderate", "severe", or "deadly") based on the final calculated total.
    """

    # Use Global Variables if no override is given
    if is_serious == None:
        is_serious = critical_is_serious

    # Add a random integer between 1 and 20 (or override)
    bonus = get_random_bonus(random_bonus_override)
    running_total = bonus

    # Add bonus if this crit/fumble is particularly serious.
    if is_serious:
        running_total += 20

    # Special rule: if the crit is serious and bonus is 20, immediately return "deadly".
    if is_serious and bonus == 20:
        print("Lethal!!!")
        global critical_is_lethal
        critical_is_lethal = True
        print("Critical Severity: deadly")
        return "deadly"

    # Base calculation depending on whether it's a crit or a fumble.
    if critical_type.lower() == "fumble":
        running_total += target_ac - attack_roll
    else:  # default is "crit"
        running_total += attack_roll - target_ac

    # Add bonus based on critical multiplier.
    if critical_multiplier == 3:
        running_total += 5
    elif critical_multiplier == 4:
        running_total += 10

    # print number for debug purposes
    print("Running Total:", running_total)

    # Check for no effect.
    if running_total <= 0:
        print("No Effect")
        return None

    # If running_total is greater than or equal to 46, return deadly immediately.
    if running_total >= 45:
        severity = "deadly"
        print("Critical Severity:", severity)
        return severity

    # Compare the running_total to the defined CRITICAL_SEVERITY ranges.
    for severity, (min_val, max_val) in CRITICAL_SEVERITY.items():
        if min_val <= running_total <= max_val:
            print("Critical Severity:", severity)
            return severity

    # If no matching range is found, return minor.
    print("Critical Severity: minor")
    return "minor"


def lower_severity(severity):
    """
    Returns severity one level lower, based on ordering defined by the CRITICAL SEVERITY
    If current_severity is already the lowest (e.g., "minor"), then it returns "minor".
    """
    # Order the severity levels by their lower bound value
    ordered_severity_levels = sorted(
        CRITICAL_SEVERITY.keys(), key=lambda s: CRITICAL_SEVERITY[s][0]
    )

    try:
        idx = ordered_severity_levels.index(severity.lower())
    except ValueError:
        # If current_severity isn't found, default to the lowest severity.
        return ordered_severity_levels[0]

    # If already at the lowest level, return it.
    if idx == 0:
        return ordered_severity_levels[0]
    else:
        return ordered_severity_levels[idx - 1]


def explosive_critical(severity, lethal=None, serious=None):
    """
    Determine if an explosive critical adjustment should be made.

    Parameters:
        severity (str): The original severity level
        lethal (bool, optional): Allows forcing the lethal flag
        serious (bool, optional): Allows forcing the serious flag

    Behavior:
        - First, it imports global variables if no override has been given
        - Then, if the global critical_is_lethal flag is True, sets the global
          critical_is_explosive flag to True, and returns the original severity.
        - Otherwise, calls get_random_bonus to get a bonus roll.
          * If that bonus is 20, sets the global critical_is_explosive flag to True
            and returns the severity at one level lower (with a floor of "minor").
          * If the bonus is 1 and the global critical_is_serious flag is False, returns
            the severity one level lower.
          * Otherwise, returns the current severity unchanged.

    Returns:
        str: The (possibly modified) severity level.
    """
    global critical_is_explosive
    if lethal is None:
        lethal = critical_is_lethal
    if serious is None:
        serious = critical_is_serious

    # Priority check: If already lethal, mark explosive and return current severity.
    if lethal:
        critical_is_explosive = True
        return severity

    # Get the random bonus roll.
    bonus = get_random_bonus()

    # Check the bonus outcomes:
    if bonus == 20:
        critical_is_explosive = True
        return lower_severity(severity)
    elif bonus == 1:
        # Lower severity on a roll of 1 if not 'serious'
        if not serious:
            return lower_severity(severity)
        else:
            return severity
    else:
        return severity


def get_available_filters(critical_type="crit", weapon_type="melee"):
    """
    Determine the available filter types based on the current context.

    Parameters:
        critical_type (str, optional): Either "crit" or "fumble" (defaults to "crit").
        weapon_type (str, optional): One weapon type (defaults to "melee").

    Returns:
        dict: A dictionary with keys for different filter groups.
    """
    # Always available filters.
    general_filters = ["condition", "effect"]

    # Normalize the critical type to either "crit" or "fumble" (defaulting to "crit").
    crit = (
        critical_type.lower() if critical_type.lower() in ["crit", "fumble"] else "crit"
    )

    # Normalize weapon type (defaulting to "melee")
    weapon = (
        weapon_type.lower()
        if weapon_type.lower() in ["melee", "ranged", "natural"]
        else "melee"
    )

    # Combined conditional filters for crit type (c/f): weapon type
    conditional_filter = f"{'c' if crit == 'crit' else 'f'}:{weapon}"

    # For the "critical" group, include both the general label (e.g., "crit") and the specialized filter.
    critical_filters = [crit, conditional_filter]

    available_filters = {
        "general": general_filters,
        "critical": critical_filters,
        "weapon": [weapon()],
    }

    return available_filters


def search_critical_effects(severity, critical_type="crit", weapon_type="melee"):
    """
    Filter and select a critical effect based on severity and current context.

    Parameters:
        severity (str): One of "minor", "moderate", "serious", or "deadly".
        critical_type (str, optional): "crit" or "fumble" (defaults to "crit").
        weapon_type (str, optional): One weapon type.

    Returns:
        tuple: (selected_title, effect_text, selected_secondary, details)
               or a "No Critical Effect" tuple if no match is found or severity is None
    """

    # Check if severity is None or not in the defined ranges.
    if severity is None or severity not in CRITICAL_SEVERITY:
        print("No Critical Effect")
        return "(No Critical Effect, " ", " ", " ")"

    # Get the available filters (e.g., general: ["condition", "effect"],
    # critical: ["crit", "c:ranged"] if critical_type="crit" and weapon_type="ranged").
    avail_filters = get_available_filters(critical_type, weapon_type)

    # Combine the general and critical filters into one set for matching.
    allowed_types = set(
        item.lower() for item in (avail_filters["general"] + avail_filters["critical"])
    )

    # Retrieve the list of effects for the given severity.
    effects = CRITICAL_EFFECTS.get(severity, [])

    # Filter effects: we include an effect if any of its type tags (lowercased) are in our allowed set.
    filtered_effects = [
        effect
        for effect in effects
        if set(e_type.lower() for e_type in effect["types"]).intersection(allowed_types)
    ]

    if not filtered_effects:
        print("No matching effect found for the given severity and filters.")
        return None

    # Randomly choose one effect from the filtered list.
    chosen_effect = random.choice(filtered_effects)

    # Randomly select one title from the chosen effect's list of titles.
    selected_title = random.choice(chosen_effect["titles"])

    # Randomly select one secondary flavor (or duration info, etc.) from the "severity" field.
    selected_secondary = random.choice(chosen_effect["severity"])

    # Also retrieve the main effect text and details.
    effect_text = chosen_effect["effect"]
    details = chosen_effect["details"]

    # Return the assembled information.
    return (selected_title, effect_text, selected_secondary, details)


# main function
def main():
    """Main function for the program."""


# Standard Python boilerplate to run the main function
if __name__ == "__main__":
    build_critical_effects()
    # print(CRITICAL_EFFECTS)

    # test severity calculator:
    example_attack_roll = get_random_bonus()  # Simulate an attack roll
    example_target_ac = 0
    example_critical_multiplier = 3
    example_critical_type = "crit"  # Can be "crit" or "fumble"
    example_is_serious = False  # Represents a smash or catastrophe

    severity = calculate_severity(
        example_attack_roll,
        example_target_ac,
        example_critical_multiplier,
        example_critical_type,
        example_is_serious,
        random_bonus_override=None,  # Example for override testing
    )
    print("Returned Severity:", severity)

    # test get_available_filters:
    print(
        get_available_filters()
    )  # Defaults to critical: ["crit", "c:melee"], weapon: ["melee"]
    print(
        get_available_filters("fumble", "ranged")
    )  # Should return critical: ["fumble", "f:ranged"], weapon: ["Ranged"]
    # main()

    # print blank line
    print()

    # test search_critical_effects:
    print(
        search_critical_effects(
            severity,
            critical_type="crit",
            weapon_type="melee",
        )
    )
