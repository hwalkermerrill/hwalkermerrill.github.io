# Written by Harrison Merrill 2/6/25 CSE111

# ----- Import modules -----
from pytest import approx
import pytest
from water_flow import (
    water_column_height,
    pressure_gain_from_water_height,
    pressure_loss_from_pipe,
    pressure_loss_from_fittings,
    reynolds_number,
    pressure_loss_from_pipe_reduction,
    pressure_at_house,
)


# ----- Tests go below here-----
def test_water_column_height():
    assert water_column_height(0, 0) == 0
    assert water_column_height(0, 10) == 7.5
    assert water_column_height(25, 0) == 25
    assert water_column_height(48.3, 12.8) == 57.9


def test_pressure_gain_from_water_height():
    # asserts use approx to set tolerance to 0.001 of float
    assert pressure_gain_from_water_height(0) == approx(0, abs=0.001)
    assert pressure_gain_from_water_height(30.2) == approx(295.628, abs=0.001)
    assert pressure_gain_from_water_height(50) == approx(489.450, abs=0.001)


def test_pressure_loss_from_pipe():
    # asserts use approx to set tolerance to 0.001 of float
    assert pressure_loss_from_pipe(
        pipe_diameter=0.048692,
        pipe_length=0,
        friction_factor=0.018,
        fluid_velocity=1.75,
    ) == approx(0, abs=0.001)
    assert pressure_loss_from_pipe(
        pipe_diameter=0.048692,
        pipe_length=200,
        friction_factor=0,
        fluid_velocity=1.75,
    ) == approx(0, abs=0.001)
    assert pressure_loss_from_pipe(
        pipe_diameter=0.048692,
        pipe_length=200,
        friction_factor=0.018,
        fluid_velocity=0,
    ) == approx(0, abs=0.001)
    assert pressure_loss_from_pipe(
        pipe_diameter=0.048692,
        pipe_length=200,
        friction_factor=0.018,
        fluid_velocity=1.75,
    ) == approx(-113.008, abs=0.001)
    assert pressure_loss_from_pipe(
        pipe_diameter=0.048692,
        pipe_length=200,
        friction_factor=0.018,
        fluid_velocity=1.65,
    ) == approx(-100.462, abs=0.001)
    assert pressure_loss_from_pipe(
        pipe_diameter=0.28687,
        pipe_length=1000,
        friction_factor=0.013,
        fluid_velocity=1.65,
    ) == approx(-61.576, abs=0.001)
    assert pressure_loss_from_pipe(
        pipe_diameter=0.28687,
        pipe_length=1800.75,
        friction_factor=0.013,
        fluid_velocity=1.65,
    ) == approx(-110.884, abs=0.001)


def test_pressure_loss_from_fittings():
    # asserts use approx to set tolerance to 0.001 of float
    assert pressure_loss_from_fittings(0, 3) == approx(0, abs=0.001)
    assert pressure_loss_from_fittings(1.65, 0) == approx(0, abs=0.001)
    assert pressure_loss_from_fittings(1.65, 2) == approx(-0.109, abs=0.001)
    assert pressure_loss_from_fittings(1.75, 2) == approx(-0.122, abs=0.001)
    assert pressure_loss_from_fittings(1.75, 5) == approx(-0.306, abs=0.001)


def test_reynolds_number():
    # asserts use approx to set tolerance to 1 of float
    assert reynolds_number(0.048692, 0) == approx(0, abs=1)
    assert reynolds_number(0.048692, 1.65) == approx(80069, abs=1)
    assert reynolds_number(0.048692, 1.75) == approx(84922, abs=1)
    assert reynolds_number(0.28687, 1.65) == approx(471729, abs=1)
    assert reynolds_number(0.28687, 1.75) == approx(500318, abs=1)


def test_pressure_loss_from_pipe_reduction():
    # asserts use approx to set tolerance to 0.001 of float
    assert pressure_loss_from_pipe_reduction(
        larger_diameter=0.28687,
        fluid_velocity=0,
        reynolds_number=1,
        smaller_diameter=0.048692,
    ) == approx(0, abs=0.001)
    assert pressure_loss_from_pipe_reduction(
        larger_diameter=0.28687,
        fluid_velocity=1.65,
        reynolds_number=471729,
        smaller_diameter=0.048692,
    ) == approx(-163.744, abs=0.001)
    assert pressure_loss_from_pipe_reduction(
        larger_diameter=0.28687,
        fluid_velocity=1.75,
        reynolds_number=500318,
        smaller_diameter=0.048692,
    ) == approx(-184.182, abs=0.001)


def test_pressure_at_house():
    # asserts use approx to set tolerance to 0.1 of float
    assert pressure_at_house(36.6, 9.1, 1524.0, 3, 15.2) == approx(158.7, abs=0.1)


# ----- Main Function Runs -----
# This calls the main function of pytest to execute the test functions in this file.
pytest.main(["-v", "--tb=line", "-rN", __file__])
