# Written by Harrison Merrill 2/6/25 CSE111

# ----- Import modules -----
from pytest import approx
import pytest
from water_flow import (
    water_column_height,
    pressure_gain_from_water_height,
    pressure_loss_from_pipe,
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


# ----- Main Function Runs -----
# This calls the main function of pytest to execute the test functions in this file.
pytest.main(["-v", "--tb=line", "-rN", __file__])
