# Created by Harrison Merrill 2025.03.29 - CSE 111

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
CRITICAL_EFFECTS = {}
CRITICAL_MULTIPLIERS = {"x2": 0, "x3": 1, "x4": 2}
CRITICAL_SEVERITY = {
    "minor": (0, 20),
    "moderate": (21, 30),
    "severe": (31, 40),
    "deadly": (41, 200),
}


# Function to read the critical effects from the CSV file
def build_critical_effects():
    """Read the critical effects from the CSV file and build a dictionary."""
    with open(CRITICAL_EFFECTS_FILE, "r") as file:
        reader = csv.reader(file)
        for row in reader:
            if row[0] not in CRITICAL_EFFECTS:
                CRITICAL_EFFECTS[row[0]] = []
            CRITICAL_EFFECTS[row[0]].append(row)
    return CRITICAL_EFFECTS


# Function to calculate the critical effect based on the attack roll and other parameters
def calculate_severity(
    critical_type, attack_roll, target_ac, critical_multiplier, confirmation_roll
):
    """Calculate the critical effect based on the attack roll and other parameters."""
    # Calculate the final roll
    final_roll = random.randint(1, 20)
    if critical_type == "fumble":
        final_roll += target_ac - attack_roll
    else:
        final_roll += attack_roll - target_ac
    if confirmation_roll == "y":
        final_roll += 20
    if critical_multiplier in CRITICAL_MULTIPLIERS:
        final_roll += CRITICAL_MULTIPLIERS[critical_multiplier] * 5

    # Determine the severity of the effect
    for severity, (min_value, max_value) in CRITICAL_SEVERITY.items():
        if min_value <= final_roll <= max_value:
            return severity

    print(severity)
    return severity


# Function to get the critical effects based on the weapon type and severity
def get_critical_effects(weapon_type, severity):
    """Get the critical effects based on the weapon type and severity."""
    if weapon_type in CRITICAL_EFFECTS:
        effects = CRITICAL_EFFECTS[weapon_type]
        return [effect for effect in effects if effect[SEVERITY_INDEX] == severity]
    return []


# Function to get a random critical effect based on the weapon type and severity
def get_random_critical_effect(weapon_type, severity):
    """Get a random critical effect based on the weapon type and severity."""
    effects = get_critical_effects(weapon_type, severity)
    if effects:
        return random.choice(effects)
    return None


# main function
def main():
    """Main function for the program."""
    # Build the critical effects dictionary
    build_critical_effects()
    # Get user input
    print("Welcome to the Critical Hit Calculator!")
    critical_type = input("Is this a critical or a fumble (crit/fumble)?: ")
    attack_roll = int(input("Enter your attack roll: "))
    target_ac = int(input("Enter the target's AC: "))
    critical_multiplier = input("Enter the critical multiplier (x2, x3, x4): ")
    weapon_type = input("Enter the weapon type (melee, ranged, natural): ")
    confirmation_roll = input(
        "Is this a critical smash (20) or catastrophe (1) (y/n)?: "
    )
    # Calculate the critical effect
    severity = calculate_severity(
        attack_roll, target_ac, critical_multiplier, weapon_type, confirmation_roll
    )
    # Get a random critical effect
    critical_effect = get_random_critical_effect(weapon_type, severity)
    if critical_effect:
        print(f"Critical Effect: {critical_effect[EFFECT_INDEX]}")
        print(f"Details: {critical_effect[DETAILS_INDEX]}")
    else:
        print("No critical effect found.")


# Standard Python boilerplate to run the main function
if __name__ == "__main__":
    # Check if the CSV file exists
    if not os.path.exists(CRITICAL_EFFECTS_FILE):
        print(f"Error: {CRITICAL_EFFECTS_FILE} not found.")
    else:
        main()
