# Problem Statement
# The following example Python program is supposed to ask the user for the radius and height of a
# right circular cone and then compute and print the volume of that cone. The code is almost correct,
# but it contains a common mistake. The programmer who wrote it assumed that the cone_volume function
# could use the radius and height variables that are defined in the main function. Of course, this
# assumption is incorrect because as the preparation content for this lesson explains, variables defined
# inside a function have local scope and can be used only inside their containing function.

"""Compute and print the volume of a right circular cone."""

# Import the standard math module so that
# math.pi can be used in this program.
import math


def main():
    # Call the cone_volume function to compute the volume of an example cone.
    ex_radius = 2.8
    ex_height = 3.2
    ex_vol = cone_volume(radius, height)

    # Print several lines that describe this program.
    print("This program computes the volume of a right")
    print("circular cone. For example, if the radius of a")
    print(f"cone is {ex_radius} and the height is {ex_height}")
    print(f"then the volume is {ex_vol:.1f}")
    print()

    # Get the radius and height of the cone from the user.
    radius = float(input("Please enter the radius of the cone: "))
    height = float(input("Please enter the height of the cone: "))

    # Call the cone_volume function to compute the volume
    # for the radius and height that came from the user.
    vol = cone_volume(radius, height)

    # Print the radius, height, and volume for the user to see.
    print(f"Radius: {radius}")
    print(f"Height: {height}")
    print(f"Volume: {vol:.1f}")


def cone_volume(radius, height):
    """Compute and return the volume of a right circular cone."""
    volume = math.pi * radius**2 * height / 3
    return volume


# Start this program by
# calling the main function.
main()
