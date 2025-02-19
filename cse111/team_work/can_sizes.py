# Written By: Harrison and Case, CSE111

# Problem Statement:
# In many countries, food is stored in steel cans (also known as tin cans) that are shaped like cylinders.
# There are many different sizes of steel cans. The storage efficiency of a can tells us how much a can stores
# versus how much steel is required to make the can. Some sizes of cans require a lot of steel to store a small
# amount of food. Other sizes of cans require less steel and store more food. A can size with a large storage
# efficiency is considered more friendly to the environment than a can size with a small storage efficiency.
# >
# The storage efficiency of a steel can is computed by dividing the volume of a can by its surface area.
# storage_efficiency = volume / surface_area
# In other words, the storage efficiency of a can is the space inside the can divided by the amount of steel
# required to make the can.
# >
# The formulas for the volume and surface area of a cylinder are:
# volume = π * radius **\ 2 * height
# surface_area = 2 * π * radius * (radius + height)
# π = math.Pi
# radius is the radius of the cylinder
# height is the height of the cylinder

# Assignment:
# Work as a team to write a Python program named can_sizes.py that computes and prints the storage efficiency
# for each of the following 12 steel can sizes. Then visually examine the output and answer this question,
# “Which can size has the highest storage efficiency?”
# > (See table in assignment briefing)
# If you separate your program into functions, this problem will be much easier to solve than if you don’t
# separate it into functions. You are free to write any functions that you choose in your program,
# but we strongly suggest that your program include at least these three functions:
# 1) main; 2) compute_volume; 3) compute_surface_area

# Import outside functions here
import math


def main(radius, height, name="This item", cost=None):
    volume = compute_volume(radius, height)
    surface_area = compute_surface_area(radius, height)
    storage_efficiency = compute_storage_efficiency(volume, surface_area)
    cost_efficiency = compute_cost_efficiency(volume, cost)
    print(
        f"{name} has a storage efficiency of {storage_efficiency:.2f} with a cost efficiency of {cost_efficiency:.2f} cm**3 per dollar."
    )


def compute_cost_efficiency(volume, cost):
    if cost == None:
        cost_efficiency = "Undefined"
        return cost_efficiency
    else:
        cost_efficiency = round(volume / cost, 2)
        return cost_efficiency


def compute_storage_efficiency(volume, surface_area):
    storage_efficiency = volume / surface_area
    return storage_efficiency


def compute_volume(radius, height):
    volume = math.pi * radius**2 * height
    return volume


def compute_surface_area(radius, height):
    surface_area = 2 * math.pi * radius * (radius + height)
    return surface_area


def test_run():
    main(name="#1 Picnic", radius=6.83, height=10.16, cost=0.28)
    main(name="#1 Tall", radius=7.78, height=11.91, cost=0.43)
    main(name="#2", radius=8.73, height=11.59, cost=0.45)
    main(name="#2.5", radius=10.32, height=11.91, cost=0.61)
    main(name="#3 Cylinder", radius=10.79, height=17.78, cost=0.86)
    main(name="#5", radius=13.02, height=14.29, cost=0.83)
    main(name="#6Z", radius=5.40, height=8.89, cost=0.22)
    main(name="#8Z short", radius=6.83, height=7.62, cost=0.26)
    main(name="#10", radius=15.72, height=17.78, cost=1.53)
    main(name="#211", radius=6.83, height=12.38, cost=0.34)
    main(name="#300", radius=7.62, height=11.27, cost=0.38)
    main(name="#303", radius=8.10, height=11.11, cost=0.42)


test_run()
