# FPGA Display Animator

A SystemVerilog design that drives the Basys3's four-digit seven-segment display through a set of selectable animations, controlled entirely via the onboard switches. Synthesized and deployed to hardware — a demo video is included in `docs/`.

## What It Does

The user controls the display using 13 switches. Switch 10 acts as an on/off toggle. Switches 9:8 select one of four animation sequences. Switches 11 and 12 control animation speed and display refresh behavior. Switches 7:0 let the user enter a custom 8-bit word that gets decoded into a four-digit hex pattern and used in sequence 3.

The four sequences are:

- **Sequence 0** — A single `A` scrolls across all four digits left to right
- **Sequence 1** — `BBBB` blinks on and off
- **Sequence 2** — The display counts up through `0000`, `1111`, `2222`, `3333`
- **Sequence 3** — The user's custom word rotates across the display one digit at a time

## Architecture

The design is built around a three-state FSM (`IDLE`, `LOAD`, `DISPLAY`) in `fsm_top.sv`, which coordinates three submodules:

**`sequence_timer`** generates a clock enable (`ce`) pulse at a parameterized rate. A `period_double` register optionally halves the animation speed when the speed switch is off. This keeps the timing logic completely separated from the display logic.

**`animation_sequences`** (named `mini_sequence_generator` in development) holds the four animation sequences as localparam arrays and cycles through them on each `ce` pulse. Sequence 3 is generated combinationally by rotating the user's loaded word across the four nibble positions each step.

**`sseg_driver`** handles the time-multiplexed seven-segment display. It cycles through the four anode enables at a rate derived from `base_ref_delay`, feeding each digit's nibble through `hex7seg` for segment pattern lookup.

The top-level wrapper `display_animator.sv` instantiates `fsm_top` with synthesis-appropriate timing parameters (5 MHz sequence period, 83 kHz refresh), while the behavioral parameters in `fsm_top` itself are set slower for simulation convenience.

## Simulation

![Overall FSM Simulation](docs/OverallSim.png)

![Sequence Timer Simulation](docs/TimerSim.png)

## Hardware Demo

A recorded demo of the design running on the Basys3 is in `docs/DemoVideo_Watts_White.MOV`.

## Files

```
display-animator/
├── src/
│   ├── display_animator.sv          # Synthesis top-level wrapper
│   ├── fsm_top.sv                   # FSM and submodule instantiation
│   ├── animation_sequences.sv       # Sequence bank and user word rotation
│   ├── sequence_timer.sv            # Parameterized clock enable generator
│   ├── sseg_driver.sv               # Multiplexed seven-segment driver
│   ├── hex7seg.sv                   # Hex to seven-segment decoder
│   └── tb/
│       ├── tb_fsm_top.sv
│       ├── tb_mini_sequence_generator.sv
│       └── tb_sequence_timer.sv
├── constraints/
│   └── Basys-3-Master.xdc
└── docs/
    ├── OverallSim.png
    ├── TimerSim.png
    ├── display_animator.bit
    └── DemoVideo_Watts_White.MOV
```

## Tools

SystemVerilog (IEEE 1800), Xilinx Vivado, Digilent Basys3 (Artix-7)

## Author

Christian Watts — B.S. Electrical Engineering, University of Alabama
