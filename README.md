# Temporally-Contingent Planner

## Overview

This project implements a temporally-contingent planner, which combines temporal planning with contingent planning to handle scenarios with both time constraints and uncertain outcomes. It's particularly useful for planning in domains where actions have durations and the effects of some actions are not known until execution time.

## Features

- Temporal planning with action durations
- Contingent planning to handle uncertain outcomes
- Interactive execution monitor for plan simulation
- Simple execution simulator for quick plan testing
- PDDL-like domain and problem definition

## Installation

1. Ensure you have SWI-Prolog installed on your system.
2. Clone this repository:

`git clone https://github.com/yourusername/temporally-contingent-planner.git`

3. Navigate to the project directory:

`cd temporally-contingent-planner`

## Usage

1. Define your domain in `domain.pl`
2. Define your problem in `problem.pl`
3. Run the planner:

`./run.sh`

This will execute both the simple simulation and the interactive execution monitor.

## File Structure

- `tcp.pl`: Main entry point for the planner
- `core_planner.pl`: Core planning logic
- `interactive_execution_monitor.pl`: Interactive plan execution
- `simple_execution_monitor.pl`: Simple plan simulation
- `domain.pl`: Domain definition
- `problem.pl`: Problem definition
- `run.sh`: Execution script

## Example

The repository includes an example "Hurricane Evacuation" scenario. You can modify this or create your own scenarios by editing the `domain.pl` and `problem.pl` files.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgements

This project was developed with assistance from an AI language model created by Anthropic.

## License

GPLv3
