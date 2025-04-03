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
from tkinter import Frame, Label, Button, ttk, StringVar, IntVar, font

# Indexes for the critical effects CSV file
MASTER_INDEX = 0
VALUE_INDEX = 1
TYPE_INDEX = 2
EFFECT_INDEX = 3
QUALITY_INDEX = 4
DETAILS_INDEX = 5
TITLE_INDEX = 6

# Constants
CRITICAL_EFFECTS_FILE = "crit_effects.csv"
CRITICAL_MULTIPLIERS = {"x2": 2, "x3": 3, "x4": 4}
CRITICAL_SEVERITY = {
    "minor": (1, 20),
    "moderate": (21, 30),
    "serious": (31, 40),
    "deadly": (41, 90),
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
                continue  # or raise an error

            # The 'value' in the CSV indicates the critical effect severity (e.g., "minor")
            crit_value = row[VALUE_INDEX].strip()

            # Split the fields that include multiple alternative entries.
            # For 'type', effect, 'quality', and 'title':
            types = [t.strip() for t in row[TYPE_INDEX].split("|")]
            effect_options = [option.strip() for option in row[EFFECT_INDEX].split("|")]
            quality_options = [q.strip() for q in row[QUALITY_INDEX].split("|")]
            details = row[DETAILS_INDEX].strip()
            titles = [title.strip() for title in row[TITLE_INDEX].split("|")]

            # Create a dictionary for this effect entry.
            effect_entry = {
                "index": row[MASTER_INDEX].strip(),
                "value": crit_value,
                "types": types,
                "effect": effect_options,
                "quality": quality_options,
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
        is_serious (bool, optional): Optional override for smash / catastrophe.
        random_bonus_override (int, optional): optional override for random number.

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
    if running_total >= 41:
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


def explosive_critical(severity, random_bonus_override=None, lethal=None, serious=None):
    """
    Determine if an explosive critical adjustment should be made.

    Parameters:
        severity (str): The original severity level
        random_bonus_override (int, optional): optional override for random number.
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

    # Priority check: If severity = none, return current severity.
    if severity is None:
        return None

    # Priority check: If already lethal, mark explosive and return current severity.
    if lethal:
        critical_is_explosive = True
        return severity

    # Get the random bonus roll.
    bonus = get_random_bonus(random_bonus_override)

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
        "weapon": [weapon],
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
        tuple: (selected_title, effect_options, selected_secondary, details)
               or a "No Critical Effect" tuple if no match is found or severity is None
    """

    # Check if severity is None or not in the defined ranges.
    if severity is None or severity not in CRITICAL_SEVERITY:
        print("No Critical Effect")
        return "(No Critical Effect, " ", " ", " ")"

    # Get the available filters (e.g., general: ["condition", "effect"],
    # critical: ["crit", "c:ranged"] if critical_type="crit" and weapon_type="ranged").
    available_filters = get_available_filters(critical_type, weapon_type)

    # Combine the general and critical filters into one set for matching.
    allowed_types = set(
        item.lower()
        for item in (available_filters["general"] + available_filters["critical"])
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

    # Randomly select one title and one quality from the chosen effect's list.
    selected_title = random.choice(chosen_effect["titles"])
    selected_quality = random.choice(chosen_effect["quality"])

    # Checks if the chosen effect has multiple options
    if isinstance(chosen_effect["effect"], list):
        effect_options = random.choice(chosen_effect["effect"])
    else:
        effect_options = chosen_effect["effect"]

    # Also retrieve the details text to explain potential confusions to the user.
    details = chosen_effect["details"]

    # Return the assembled information.
    return (selected_title, effect_options, selected_quality, details)


# main function copied from gui.py teamwork
def main():

    # Build or rebuild the master dictionary of critical effects
    build_critical_effects()

    # Create the Tk root object.
    root = tk.Tk()

    # Create the main window. In tkinter, a window is also called a frame.
    frm_main = Frame(root)
    frm_main.master.title("Critical Hit Calculator")
    frm_main.pack(padx=4, pady=3, fill=tk.BOTH, expand=1)

    # Call the populate_main_window function, which will add
    # labels, text entry boxes, and buttons to the main window.
    populate_main_window(frm_main)

    # Start the tkinter loop that processes user events
    # such as key presses and mouse button clicks.
    root.mainloop()


def populate_main_window(frm_main):
    """
    This function creates the interactive gui, as we learned about last week. It is
    separated based on fields for readability. Then the function uses user input to
    call the other defined functions (starting with calculate_severity). Finally, it
    creates a results box that can display the results for the user.
    """

    # Import Global Variables
    global CRITICAL_MULTIPLIERS
    global critical_is_serious
    global critical_is_lethal
    global critical_is_explosive

    # Variables
    attack_roll_var = StringVar()
    target_ac_var = StringVar()
    weapon_type_var = StringVar(value="melee")
    critical_type_var = StringVar(value="crit")
    critical_multiplier_var = IntVar(value=CRITICAL_MULTIPLIERS["x2"])
    is_serious_var = IntVar(value=0)  # 0 = unchecked, 1 = checked

    # --- Attack Roll Entry ---
    lbl_attack_roll = tk.Label(frm_main, text="Attack Roll:")
    lbl_attack_roll.grid(row=0, column=0, padx=5, pady=5, sticky="w")
    attack_roll_var.set("")
    ent_attack_roll = tk.Entry(frm_main, textvariable=attack_roll_var)
    ent_attack_roll.grid(row=0, column=1, columnspan=3, padx=5, pady=5)
    ent_attack_roll.focus_set()  # Focus here on default

    # --- Target AC Entry ---
    lbl_target_ac = tk.Label(frm_main, text="Target AC:")
    lbl_target_ac.grid(row=1, column=0, padx=5, pady=5, sticky="w")
    target_ac_var.set("10")
    ent_target_ac = tk.Entry(frm_main, textvariable=target_ac_var)
    ent_target_ac.grid(row=1, column=1, columnspan=3, padx=5, pady=5)

    # --- Weapon Type Dropdown ---
    lbl_weapon_type = tk.Label(frm_main, text="Weapon Type:")
    lbl_weapon_type.grid(row=2, column=0, padx=5, pady=5, sticky="w")
    cmb_weapon_type = ttk.Combobox(frm_main, textvariable=weapon_type_var)
    cmb_weapon_type["values"] = ["melee", "ranged", "natural"]
    cmb_weapon_type.state(["readonly"])  # Make dropdown read-only
    cmb_weapon_type.grid(row=2, column=1, columnspan=3, padx=5, pady=5)

    # --- Critical Type Radial Menu ---
    lbl_critical_type = tk.Label(frm_main, text="Critical Type:")
    lbl_critical_type.grid(row=3, column=0, padx=5, pady=5, sticky="w")
    rbtn_crit = tk.Radiobutton(
        frm_main, text="Crit", variable=critical_type_var, value="crit"
    )
    rbtn_crit.grid(row=3, column=1, padx=5, pady=2, sticky="w")
    rbtn_fumble = tk.Radiobutton(
        frm_main, text="Fumble", variable=critical_type_var, value="fumble"
    )
    rbtn_fumble.grid(row=3, column=2, columnspan=3, padx=5, pady=2, sticky="w")

    # --- Critical Multiplier Radial Menu ---
    lbl_critical_multiplier = tk.Label(frm_main, text="Critical Multiplier:")
    lbl_critical_multiplier.grid(row=4, column=0, padx=5, pady=5, sticky="w")

    # Create radio buttons for each multiplier option (e.g., "x2", "x3", "x4")
    col = 1
    for key, value in CRITICAL_MULTIPLIERS.items():
        rbtn_multiplier = tk.Radiobutton(
            frm_main, text=key, variable=critical_multiplier_var, value=value
        )
        rbtn_multiplier.grid(row=4, column=col, padx=5, pady=2, sticky="w")
        col += 1

    # --- Serious Checkbox ---
    chk_serious = tk.Checkbutton(
        frm_main,
        text="Critical is Serious? (Smash/Catastrophe)",
        variable=is_serious_var,
    )
    chk_serious.grid(row=5, column=0, columnspan=3, padx=5, pady=5, sticky="w")

    # --- Create a Text widget for output display ---
    lbl_output = tk.Label(frm_main, text="Results:")
    lbl_output.grid(row=8, column=0, padx=5, pady=5, sticky="w")
    txt_output = tk.Text(frm_main, wrap=tk.WORD, height=10, width=40)
    txt_output.grid(row=9, column=0, columnspan=4, padx=5, pady=5, sticky="ew")

    # Define tags for text formatting
    txt_output.tag_configure("bold", font=("TkDefaultFont", 10, "bold"))
    txt_output.tag_configure("italic", font=("TkDefaultFont", 10, "italic"))
    txt_output.tag_configure("normal", font=("TkDefaultFont", 10, "normal"))

    # --- Buttons ---
    def calculate():
        global critical_is_serious
        global critical_is_lethal
        global critical_is_explosive
        # Validate inputs and run the correct functions
        try:
            # Force attack rolls and target AC to be non-negative int
            try:
                attack_roll = int(attack_roll_var.get())
                if attack_roll < 0 or not int:
                    raise ValueError
            except ValueError:
                attack_roll_var.set("0")
                attack_roll = 0
            try:
                target_ac = int(target_ac_var.get())
                if target_ac < 0 or not int:
                    raise ValueError
            except ValueError:
                target_ac_var.set("0")
                target_ac = 0

            # Get remaining values from gui input
            critical_type = critical_type_var.get()
            critical_multiplier = critical_multiplier_var.get()
            weapon_type = weapon_type_var.get()
            critical_is_serious = bool(is_serious_var.get())

            # Calculate severity based on inputs
            severity = calculate_severity(
                attack_roll,
                target_ac,
                critical_multiplier,
                critical_type,
            )

            # Check if crit is explosive
            explosive_severity = explosive_critical(severity)

            # Get effect tuple
            effect_tuple = search_critical_effects(
                explosive_severity, critical_type, weapon_type
            )

            # Gets effect tuple again if crit is explosive!
            if critical_is_explosive:
                double_tuple = search_critical_effects(
                    explosive_severity, critical_type, weapon_type
                )

            # Clear any existing results
            txt_output.delete("1.0", tk.END)

            # Check and output additional text and formatting depending on critical flags
            if critical_is_lethal:
                txt_output.insert(
                    "1.0", f"Lethal {critical_type.capitalize()}!!!\n", "bold"
                )
                txt_output.insert(
                    tk.END,
                    f"{severity.capitalize()} {critical_type.capitalize()}: ",
                    "bold",
                )
            elif critical_is_explosive:
                txt_output.insert(
                    "1.0", f"Explosive {critical_type.capitalize()}!\n", "bold"
                )
                txt_output.insert(
                    tk.END,
                    f"{severity.capitalize()} {critical_type.capitalize()}: ",
                    "bold",
                )
            else:
                txt_output.insert(
                    "1.0",
                    f"{severity.capitalize()} {critical_type.capitalize()}: ",
                    "bold",
                )

            # Output remaining critical data for user
            txt_output.insert(tk.END, f"{effect_tuple[0]}\n", "italic")
            if critical_is_explosive:
                txt_output.insert(
                    tk.END,
                    f"{effect_tuple[1]} {effect_tuple[2]} -AND- {double_tuple[1]} {double_tuple[2]}\n\n",
                    "normal",
                )
            else:
                txt_output.insert(
                    tk.END, f"{effect_tuple[1]} {effect_tuple[2]}\n\n", "normal"
                )
            txt_output.insert(tk.END, f"{effect_tuple[3]}\n\n", "normal")
            if critical_is_explosive:
                txt_output.insert(tk.END, f"{double_tuple[3]}", "normal")

            # Reset global flags
            critical_is_lethal = False
            critical_is_explosive = False

        except ValueError as e:
            print(f"Error: {e}")

    def clear():
        global critical_is_serious
        # Reset inputs to default values
        btn_clear.focus()
        attack_roll_var.set("")
        target_ac_var.set("10")
        weapon_type_var.set("melee")
        critical_type_var.set("crit")
        critical_multiplier_var.set(CRITICAL_MULTIPLIERS["x2"])
        is_serious_var.set(0)
        critical_is_serious = False
        ent_attack_roll.focus_set()

    btn_calculate = tk.Button(frm_main, text="Calculate", command=calculate)
    btn_calculate.grid(row=6, column=0, padx=5, pady=10, sticky="w")

    btn_clear = tk.Button(frm_main, text="Clear", command=clear)
    btn_clear.grid(row=6, column=1, padx=5, pady=10, sticky="w")

    # # Bind the calculate function to the age entry box so
    # # that the computer will call the calculate function
    # # when the user changes the text in the entry box.
    # ent_length.bind("<KeyRelease>", calculate)

    # # Bind the clear function to the clear button so
    # # that the computer will call the clear function
    # # when the user clicks the clear button.
    # btn_clear.config(command=clear)

    # # Give the keyboard focus to the age entry box.
    # ent_length.focus()


# Standard Python boilerplate to run the main function
if __name__ == "__main__":
    main()
