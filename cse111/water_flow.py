# Written by Harrison Merrill 2/6/25 CSE111

# Problem Statement:
# Getting clean water to all buildings in a city is a large and expensive task.
# Many cities will build an elevated water tank, and install a pump that pushes water
# up to the tank where the water is stored. In the city, when a thirsty person opens
# a water faucet, water runs from the tank through pipes to the faucet. Earth’s gravity
# pulling on the water in the elevated tank pressurizes the water and causes it to spray
# from the faucet.
# >
# Before a city builds a water distribution system, an engineer must design the system
# and ensure water will flow to all buildings in the city. An engineer must choose the
# tower height, pipe type, pipe diameter, and pipe path. Engineers use software to help
# them make these choices and design a working water distribution system.

# Assignment
# Write a Python program that could help an engineer design a water distribution system.
# During this prove milestone, you will write three program functions and three test
# functions as described in the Steps section below.

# ----- Import modules -----


# ----- Constants -----
density_of_water = 998.2  # kg/m^3
gravity = 9.80665  # m/s^2


# ---- Function Definitions -----
# This function calculates and returns the height of a column of water from a water tower.
def water_column_height(tower_height, tank_height):
    height = tower_height + ((3 * tank_height) / 4)
    return height


# This function translates water height to water pressure
def pressure_gain_from_water_height(height):
    # Calculate pressure in kilopascals
    pressure = (density_of_water * gravity * height) / 1000
    return pressure


# This function calculates pressure loss (through friction between water and the pipe)
def pressure_loss_from_pipe(
    pipe_diameter, pipe_length, friction_factor, fluid_velocity
):
    pressure_loss = (
        -friction_factor * pipe_length * density_of_water * fluid_velocity**2
    ) / (2000 * pipe_diameter)
    return pressure_loss
