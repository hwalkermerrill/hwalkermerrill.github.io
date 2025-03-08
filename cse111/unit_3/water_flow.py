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
water_dynamic_viscosity = 0.0010016  # N*s/m^2

# ----- Variables Copied from cse111 lesson06 -----
PVC_SCHED80_INNER_DIAMETER = 0.28687  # (meters)  11.294 inches
PVC_SCHED80_FRICTION_FACTOR = 0.013  # (unitless)
SUPPLY_VELOCITY = 1.65  # (meters / second)

HDPE_SDR11_INNER_DIAMETER = 0.048692  # (meters)  1.917 inches
HDPE_SDR11_FRICTION_FACTOR = 0.018  # (unitless)
HOUSEHOLD_VELOCITY = 1.75  # (meters / second)


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


# This function calculates pressure loss from fittings
def pressure_loss_from_fittings(fluid_velocity, quantity_fittings):
    pressure_loss_fittings = (
        -0.04 * density_of_water * fluid_velocity**2 * quantity_fittings
    ) / 2000
    return pressure_loss_fittings


# This functions returns the reynolds number for a pipe with water flowing through it
def reynolds_number(hydraulic_diameter, fluid_velocity):
    reynolds = (
        density_of_water * fluid_velocity * hydraulic_diameter
    ) / water_dynamic_viscosity
    return reynolds


# This function calculates the water pressure lost from water moving from a
# larger diameter pipe to a smaller diameter pipe
def pressure_loss_from_pipe_reduction(
    larger_diameter, fluid_velocity, reynolds_number, smaller_diameter
):
    reduction_constant = (0.1 + (50 / reynolds_number)) * (
        ((larger_diameter / smaller_diameter) ** 4) - 1
    )
    pressure_loss_reduction = (
        -reduction_constant * density_of_water * fluid_velocity**2
    ) / 2000
    return pressure_loss_reduction


def pressure_at_house(tower_height, tank_height, length1, quantity_angles, length2):
    water_height = water_column_height(tower_height, tank_height)
    pressure = pressure_gain_from_water_height(water_height)
    reynolds = reynolds_number(
        hydraulic_diameter=PVC_SCHED80_INNER_DIAMETER, fluid_velocity=SUPPLY_VELOCITY
    )

    loss = pressure_loss_from_pipe(
        pipe_diameter=PVC_SCHED80_INNER_DIAMETER,
        pipe_length=length1,
        friction_factor=PVC_SCHED80_FRICTION_FACTOR,
        fluid_velocity=SUPPLY_VELOCITY,
    )
    pressure += loss

    loss = pressure_loss_from_fittings(
        fluid_velocity=SUPPLY_VELOCITY, quantity_fittings=quantity_angles
    )
    pressure += loss

    loss = pressure_loss_from_pipe_reduction(
        larger_diameter=PVC_SCHED80_INNER_DIAMETER,
        fluid_velocity=SUPPLY_VELOCITY,
        reynolds_number=reynolds,
        smaller_diameter=HDPE_SDR11_INNER_DIAMETER,
    )
    pressure += loss

    loss = pressure_loss_from_pipe(
        pipe_diameter=HDPE_SDR11_INNER_DIAMETER,
        pipe_length=length2,
        friction_factor=HDPE_SDR11_FRICTION_FACTOR,
        fluid_velocity=HOUSEHOLD_VELOCITY,
    )
    pressure += loss

    return pressure


def main():
    tower_height = float(input("Height of water tower (meters): "))
    tank_height = float(input("Height of water tank walls (meters): "))
    length1 = float(input("Length of supply pipe from tank to lot (meters): "))
    quantity_angles = int(input("Number of 90° angles in supply pipe: "))
    length2 = float(input("Length of pipe from supply to house (meters): "))

    pressure = pressure_at_house(
        tower_height, tank_height, length1, quantity_angles, length2
    )

    print(f"Pressure at house: {pressure:.1f} kilopascals")


if __name__ == "__main__":
    main()
