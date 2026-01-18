# Written by Harrison Merrill 2/20/25 CSE111

# Problem Statement:
# In chemistry, a mole is a very large, fixed quantity, specifically
# 602,214,076,000,000,000,000,000 (usually written as 6.02214076 × 1023).
# The molar mass of a substance is the mass in grams of one mole of the substance
# (grams / mole). A molar mass calculator is a program that computes the molar mass
#  of a substance and the number of moles of a sample of that substance.
# To use a molar mass calculator, a chemist enters two inputs:
#
# > The formula for a molecule, such as H2O (water) or C6H12O6 (glucose)
# > The mass in grams of a sample of the substance, such as 3.71
#
# The calculator computes the molar mass of the molecule and the number of moles in
# the sample and then prints both of those numbers.

# Assignment:
# During this prove milestone and the next prove assignment, you will write and test
# a molar mass calculator named chemistry.py. During this milestone, you will complete
# part of the calculator by writing a function named make_periodic_table and the main
# function. The make_periodic_table function must create and return a compound list
# that contains data for all 94 naturally occurring elements.

# Imports
from formula import parse_formula

# Constants
avogadro_number = 6.02214076e23
# Indexes for inner lists in the periodic table
NAME_INDEX = 0
ATOMIC_MASS_INDEX = 1
ATOMIC_NUMBER_INDEX = 2

# Indexes for inner lists in a symbol_quantity_list
SYMBOL_INDEX = 0
QUANTITY_INDEX = 1

# This is the old dictionary, containing 94 elements listed alphabetically by key
# (including atomic number) and passes the test_chemistry.py
# def make_periodic_table():
#     periodic_table_dict = {
#         # symbol [name, atomic_mass, atomic_number]
#         "Ac": ["Actinium", 227, 89],
#         "Ag": ["Silver", 107.8682, 47],
#         "Al": ["Aluminum", 26.9815386, 13],
#         "Ar": ["Argon", 39.948, 18],
#         "As": ["Arsenic", 74.9216, 33],
#         "At": ["Astatine", 210, 85],
#         "Au": ["Gold", 196.966569, 79],
#         "B": ["Boron", 10.811, 5],
#         "Ba": ["Barium", 137.327, 56],
#         "Be": ["Beryllium", 9.012182, 4],
#         "Bi": ["Bismuth", 208.9804, 83],
#         "Br": ["Bromine", 79.904, 35],
#         "C": ["Carbon", 12.0107, 6],
#         "Ca": ["Calcium", 40.078, 20],
#         "Cd": ["Cadmium", 112.411, 48],
#         "Ce": ["Cerium", 140.116, 58],
#         "Cl": ["Chlorine", 35.453, 17],
#         "Co": ["Cobalt", 58.933195, 27],
#         "Cr": ["Chromium", 51.9961, 24],
#         "Cs": ["Cesium", 132.9054519, 55],
#         "Cu": ["Copper", 63.546, 29],
#         "Dy": ["Dysprosium", 162.5, 66],
#         "Er": ["Erbium", 167.259, 68],
#         "Eu": ["Europium", 151.964, 63],
#         "F": ["Fluorine", 18.9984032, 9],
#         "Fe": ["Iron", 55.845, 26],
#         "Fr": ["Francium", 223, 87],
#         "Ga": ["Gallium", 69.723, 31],
#         "Gd": ["Gadolinium", 157.25, 64],
#         "Ge": ["Germanium", 72.64, 32],
#         "H": ["Hydrogen", 1.00794, 1],
#         "He": ["Helium", 4.002602, 2],
#         "Hf": ["Hafnium", 178.49, 72],
#         "Hg": ["Mercury", 200.59, 80],
#         "Ho": ["Holmium", 164.93032, 67],
#         "I": ["Iodine", 126.90447, 53],
#         "In": ["Indium", 114.818, 49],
#         "Ir": ["Iridium", 192.217, 77],
#         "K": ["Potassium", 39.0983, 19],
#         "Kr": ["Krypton", 83.798, 36],
#         "La": ["Lanthanum", 138.90547, 57],
#         "Li": ["Lithium", 6.941, 3],
#         "Lu": ["Lutetium", 174.9668, 71],
#         "Mg": ["Magnesium", 24.305, 12],
#         "Mn": ["Manganese", 54.938045, 25],
#         "Mo": ["Molybdenum", 95.96, 42],
#         "N": ["Nitrogen", 14.0067, 7],
#         "Na": ["Sodium", 22.98976928, 11],
#         "Nb": ["Niobium", 92.90638, 41],
#         "Nd": ["Neodymium", 144.242, 60],
#         "Ne": ["Neon", 20.1797, 10],
#         "Ni": ["Nickel", 58.6934, 28],
#         "Np": ["Neptunium", 237, 93],
#         "O": ["Oxygen", 15.9994, 8],
#         "Os": ["Osmium", 190.23, 76],
#         "P": ["Phosphorus", 30.973762, 15],
#         "Pa": ["Protactinium", 231.03588, 91],
#         "Pb": ["Lead", 207.2, 82],
#         "Pd": ["Palladium", 106.42, 46],
#         "Pm": ["Promethium", 145, 61],
#         "Po": ["Polonium", 209, 84],
#         "Pr": ["Praseodymium", 140.90765, 59],
#         "Pt": ["Platinum", 195.084, 78],
#         "Pu": ["Plutonium", 244, 94],
#         "Ra": ["Radium", 226, 88],
#         "Rb": ["Rubidium", 85.4678, 37],
#         "Re": ["Rhenium", 186.207, 75],
#         "Rh": ["Rhodium", 102.9055, 45],
#         "Rn": ["Radon", 222, 86],
#         "Ru": ["Ruthenium", 101.07, 44],
#         "S": ["Sulfur", 32.065, 16],
#         "Sb": ["Antimony", 121.76, 51],
#         "Sc": ["Scandium", 44.955912, 21],
#         "Se": ["Selenium", 78.96, 34],
#         "Si": ["Silicon", 28.0855, 14],
#         "Sm": ["Samarium", 150.36, 62],
#         "Sn": ["Tin", 118.71, 50],
#         "Sr": ["Strontium", 87.62, 38],
#         "Ta": ["Tantalum", 180.94788, 73],
#         "Tb": ["Terbium", 158.92535, 65],
#         "Tc": ["Technetium", 98, 43],
#         "Te": ["Tellurium", 127.6, 52],
#         "Th": ["Thorium", 232.03806, 90],
#         "Ti": ["Titanium", 47.867, 22],
#         "Tl": ["Thallium", 204.3833, 81],
#         "Tm": ["Thulium", 168.93421, 69],
#         "U": ["Uranium", 238.02891, 92],
#         "V": ["Vanadium", 50.9415, 23],
#         "W": ["Tungsten", 183.84, 74],
#         "Xe": ["Xenon", 131.293, 54],
#         "Y": ["Yttrium", 88.90585, 39],
#         "Yb": ["Ytterbium", 173.054, 70],
#         "Zn": ["Zinc", 65.38, 30],
#         "Zr": ["Zirconium", 91.224, 40],
#     }
#     return periodic_table_dict


# This new dictionary is an improvement on the old one, but does not pass
# test_chemistry.py because it contains 118 elements instead of 94
def make_periodic_table():
    periodic_table_dict = {
        # symbol [name, atomic_mass, atomic_number]
        "H": ["Hydrogen", 1.00794, 1],
        "He": ["Helium", 4.002602, 2],
        "Li": ["Lithium", 6.941, 3],
        "Be": ["Beryllium", 9.012182, 4],
        "B": ["Boron", 10.811, 5],
        "C": ["Carbon", 12.0107, 6],
        "N": ["Nitrogen", 14.0067, 7],
        "O": ["Oxygen", 15.9994, 8],
        "F": ["Fluorine", 18.9984032, 9],
        "Ne": ["Neon", 20.1797, 10],
        "Na": ["Sodium", 22.98976928, 11],
        "Mg": ["Magnesium", 24.305, 12],
        "Al": ["Aluminum", 26.9815386, 13],
        "Si": ["Silicon", 28.0855, 14],
        "P": ["Phosphorus", 30.973762, 15],
        "S": ["Sulfur", 32.065, 16],
        "Cl": ["Chlorine", 35.453, 17],
        "Ar": ["Argon", 39.948, 18],
        "K": ["Potassium", 39.0983, 19],
        "Ca": ["Calcium", 40.078, 20],
        "Sc": ["Scandium", 44.955912, 21],
        "Ti": ["Titanium", 47.867, 22],
        "V": ["Vanadium", 50.9415, 23],
        "Cr": ["Chromium", 51.9961, 24],
        "Mn": ["Manganese", 54.938045, 25],
        "Fe": ["Iron", 55.845, 26],
        "Co": ["Cobalt", 58.933195, 27],
        "Ni": ["Nickel", 58.6934, 28],
        "Cu": ["Copper", 63.546, 29],
        "Zn": ["Zinc", 65.38, 30],
        "Ga": ["Gallium", 69.723, 31],
        "Ge": ["Germanium", 72.64, 32],
        "As": ["Arsenic", 74.9216, 33],
        "Se": ["Selenium", 78.96, 34],
        "Br": ["Bromine", 79.904, 35],
        "Kr": ["Krypton", 83.798, 36],
        "Rb": ["Rubidium", 85.4678, 37],
        "Sr": ["Strontium", 87.62, 38],
        "Y": ["Yttrium", 88.90585, 39],
        "Zr": ["Zirconium", 91.224, 40],
        "Nb": ["Niobium", 92.90638, 41],
        "Mo": ["Molybdenum", 95.96, 42],
        "Tc": ["Technetium", 98, 43],
        "Ru": ["Ruthenium", 101.07, 44],
        "Rh": ["Rhodium", 102.9055, 45],
        "Pd": ["Palladium", 106.42, 46],
        "Ag": ["Silver", 107.8682, 47],
        "Cd": ["Cadmium", 112.411, 48],
        "In": ["Indium", 114.818, 49],
        "Sn": ["Tin", 118.71, 50],
        "Sb": ["Antimony", 121.76, 51],
        "Te": ["Tellurium", 127.6, 52],
        "I": ["Iodine", 126.90447, 53],
        "Xe": ["Xenon", 131.293, 54],
        "Cs": ["Cesium", 132.9054519, 55],
        "Ba": ["Barium", 137.327, 56],
        "La": ["Lanthanum", 138.90547, 57],
        "Ce": ["Cerium", 140.116, 58],
        "Pr": ["Praseodymium", 140.90765, 59],
        "Nd": ["Neodymium", 144.242, 60],
        "Pm": ["Promethium", 145, 61],
        "Sm": ["Samarium", 150.36, 62],
        "Eu": ["Europium", 151.964, 63],
        "Gd": ["Gadolinium", 157.25, 64],
        "Tb": ["Terbium", 158.92535, 65],
        "Dy": ["Dysprosium", 162.5, 66],
        "Ho": ["Holmium", 164.93032, 67],
        "Er": ["Erbium", 167.259, 68],
        "Tm": ["Thulium", 168.93421, 69],
        "Yb": ["Ytterbium", 173.054, 70],
        "Lu": ["Lutetium", 174.9668, 71],
        "Hf": ["Hafnium", 178.49, 72],
        "Ta": ["Tantalum", 180.94788, 73],
        "W": ["Tungsten", 183.84, 74],
        "Re": ["Rhenium", 186.207, 75],
        "Os": ["Osmium", 190.23, 76],
        "Ir": ["Iridium", 192.217, 77],
        "Pt": ["Platinum", 195.084, 78],
        "Au": ["Gold", 196.966569, 79],
        "Hg": ["Mercury", 200.59, 80],
        "Tl": ["Thallium", 204.3833, 81],
        "Pb": ["Lead", 207.2, 82],
        "Bi": ["Bismuth", 208.9804, 83],
        "Po": ["Polonium", 209, 84],
        "At": ["Astatine", 210, 85],
        "Rn": ["Radon", 222, 86],
        "Fr": ["Francium", 223, 87],
        "Ra": ["Radium", 226, 88],
        "Ac": ["Actinium", 227, 89],
        "Th": ["Thorium", 232.03806, 90],
        "Pa": ["Protactinium", 231.03588, 91],
        "U": ["Uranium", 238.02891, 92],
        "Np": ["Neptunium", 237, 93],
        "Pu": ["Plutonium", 244, 94],
        "Am": ["Americium", 243, 95],
        "Cm": ["Curium", 247, 96],
        "Bk": ["Berkelium", 247, 97],
        "Cf": ["Californium", 251, 98],
        "Es": ["Einsteinium", 252, 99],
        "Fm": ["Fermium", 257, 100],
        "Md": ["Mendelevium", 258, 101],
        "No": ["Nobelium", 259, 102],
        "Lr": ["Lawrencium", 262, 103],
        "Rf": ["Rutherfordium", 267, 104],
        "Db": ["Dubnium", 270, 105],
        "Sg": ["Seaborgium", 271, 106],
        "Bh": ["Bohrium", 270, 107],
        "Hs": ["Hassium", 277, 108],
        "Mt": ["Meitnerium", 276, 109],
        "Ds": ["Darmstadtium", 281, 110],
        "Rg": ["Roentgenium", 282, 111],
        "Cn": ["Copernicium", 285, 112],
        "Nh": ["Nihonium", 286, 113],
        "Fl": ["Flerovium", 289, 114],
        "Mc": ["Moscovium", 290, 115],
        "Lv": ["Livermorium", 293, 116],
        "Ts": ["Tennessine", 294, 117],
        "Og": ["Oganesson", 294, 118],
    }
    return periodic_table_dict


def compute_molar_mass(symbol_quantity_list, periodic_table_dict):
    """Compute and return the total molar mass of all the
    elements listed in symbol_quantity_list.

    Parameters
        symbol_quantity_list is a compound list returned
            from the parse_formula function. Each small
            list in symbol_quantity_list has this form:
            ["symbol", quantity].
        periodic_table_dict is the compound dictionary
            returned from make_periodic_table.
    Return: the total molar mass of all the elements in
        symbol_quantity_list.

    For example, if symbol_quantity_list is [["H", 2], ["O", 1]],
    this function will calculate and return
    atomic_mass("H") * 2 + atomic_mass("O") * 1
    1.00794 * 2 + 15.9994 * 1
    18.01528
    """
    total_molar_mass = 0

    # For each inner list in symbol_quantity_list:
    for symbol_quantity in symbol_quantity_list:
        # Separate the inner list into symbol and quantity.
        symbol = symbol_quantity[0]
        quantity = symbol_quantity[1]

        # Get the atomic mass for the symbol from the dictionary.
        atomic_mass = periodic_table_dict[symbol][1]

        # Multiply the atomic mass by the quantity.
        mass_contribution = atomic_mass * quantity

        # Add the product into the total molar mass.
        total_molar_mass += mass_contribution

    return total_molar_mass


def sum_protons(symbol_quantity_list, periodic_table_dict):
    """Compute and return the total number of protons in
    all the elements listed in symbol_quantity_list.

    Parameters
        symbol_quantity_list is a compound list returned
            from the parse_formula function. Each small
            list in symbol_quantity_list has this form:
            ["symbol", quantity].
        periodic_table_dict is the compound dictionary
            returned from make_periodic_table.
    Return: the total number of protons of all
        the elements in symbol_quantity_list.
    """
    total_protons = 0

    for symbol_quantity in symbol_quantity_list:
        symbol = symbol_quantity[0]
        quantity = symbol_quantity[1]

        # lookup symbol in periodic table, return atomic number of symbol
        atomic_number = periodic_table_dict[symbol][2]

        # Add sum of symbols protons to the running total protons.
        total_protons += atomic_number * quantity

    return total_protons


def main():
    # Get a chemical formula for a molecule from the user.
    chemical_formula = input("Enter the chemical formula for the molecule: ")

    # Get the mass of a chemical sample in grams from the user.
    sample_mass = float(input("Enter the mass of the sample in grams: "))

    # Call the make_periodic_table function and store the periodic table in a variable.
    periodic_table_dict = make_periodic_table()

    # Call the parse_formula function to convert the chemical formula given by the user
    # to a compound list that stores element symbols and the quantity of atoms of each
    # element in the molecule.
    symbol_quantity_list = parse_formula(chemical_formula, periodic_table_dict)

    # Call the compute_molar_mass function to compute the molar mass of the molecule
    # from the compound list.
    molar_mass = compute_molar_mass(symbol_quantity_list, periodic_table_dict)

    # Computes the number of protons in the molecule
    total_protons = sum_protons(symbol_quantity_list, periodic_table_dict)

    # Does math to determine other number of moles, quantity of molecules in sample,
    # and total protons in sample.
    number_of_moles = sample_mass / molar_mass
    total_number_of_molecules = number_of_moles * avogadro_number
    protons_in_sample = total_protons * total_number_of_molecules

    # Print a blank line for readability.
    print()

    # Print the molar mass to a maximum of 5 decimal places.
    print(f"The molar mass of {chemical_formula} is {molar_mass:.5f} grams/mole.")

    # Print the total protons in the molecule.
    print(
        f"The number of protons in the {chemical_formula} molecule is {total_protons} protons."
    )

    # Print the number of moles to a maximum of 5 decimal places.
    print(f"The number of moles in the sample is {number_of_moles:.5f} moles.")

    # Print the number of molecules in the sample to a maximum of 5 decimal places.
    print(
        f"The total number of molecules in the samples is approximately {total_number_of_molecules:.5e} molecules."
    )

    # Print the number of protons in the sample to a maximum of 5 decimal places.
    print(
        f"The total number of protons in the given sample is approximately {protons_in_sample:.5e} protons."
    )


# Standard convention for running program, while leaving place for validation tests.
if __name__ == "__main__":
    main()
