# Electronic Air-Hockey Machine

## Project Overview

This project involves designing and implementing an electronic air-hockey game for two players using an FPGA device. The game simulates the movement of a puck in a 2D 5x5 area using LEDs and a seven-segment display (SSD). Players will use buttons and switches on the FPGA to control the puck.

## Features

- **2D Playground**: The game area is a 5x5 grid.
- **LED Simulation**: LEDs (LD9 to LD5) are used to show the puck moving from right to left.
- **SSD Display**: A seven-segment display (SSD5) shows the puck's Y-coordinate.
- **Player Controls**: Players A and B use buttons (BTNL and BTNR) and sliding switches (SW15-SW11) to control the puck.
- **Score Display**: Initial and current scores are displayed on SSDs (SSD2-SSD0).
- **Game Speed**: The puck moves at a speed of 2 seconds per step.
- **Winning Condition**: The first player to score 3 goals wins.

## Project Plan and Deadlines

1. **Requirements**: Provided to students on Dec 19, 2023.
2. **State Diagrams**: Submit hard copies by Dec 26, 2023, at 9 am (10% of the grade).
3. **Simulation**: Demonstrate simulation by Jan 1, 2024, at 23:55 (30% of the grade).
4. **Demo**: Implement the circuit on FPGA and demonstrate by Jan 7, 2024 (60% of the grade).

## Extra Modules

1. **Clock Divider (clk_divider.v)**: Generates a 50 Hz clock signal from a 100 MHz input clock.
2. **Debouncer (debouncer.v)**: Generates a one-clock-pulse output from a push button input.
3. **Seven Segment Driver (ssd.v)**: Drives the segments of the SSD.

## Game Rules

1. **Initial Turn**: Player A starts, the initial score "0-0" is shown for 2 seconds.
2. **Puck Control**: Players adjust Y-coordinate and direction using switches, then press their button to send the puck.
3. **Scoring**: If a player fails to hit the puck correctly within 1 second, the other player scores.
4. **Winning**: The first player to score 3 goals wins. The score and winner are displayed on SSDs, and LEDs blink.

## Make-up Lab Options

- **Speed Adjustment**: Demonstrate at least two speed options (0.5 and 1 second periods).
- **Custom Settings**: Allow users to select the number of goals to win (1-7) and the playground size (4-7).

## How to Run

1. Clone the repository.
2. Load the provided Verilog files into your FPGA development environment.
3. Implement the circuit on an FPGA device.
4. Use the provided buttons and switches to control the game as per the rules.

## Authors

- [https://github.com/YagizEbil]
- [https://github.com/teo123man]

## License

This project is licensed under the MIT License. Built for Sabanci University: CS303 Logic and Digital System Design course.