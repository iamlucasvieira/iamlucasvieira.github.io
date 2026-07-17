+++
title = "Parachute and Wind Simulator"
date = "2021-07-07T21:30:35+01:00"
tags = ["space", "simulation"]
+++

# Parachute and Wind Simulator

At [Delft Aerospace Rocket Engineering (DARE)](https://dare.tudelft.nl/), I was on the simulation team, working on parachute aerodynamics. I built a wind tunnel simulator that models how a parachute interacts with airflow as it deploys and generates data from it.

{{< figure src="images/flow.gif" caption="Parachute and wind simulator" align="center" >}}

## The Challenge

Designing rocket recovery parachutes is hard, especially when you're starting from scratch like DARE's parachute research group was. Real testing happens in wind tunnels, and those are in high demand with very few free slots. Every session counts, so it helps to have a way to pre-test design changes before booking full wind tunnel time.

## The Solution

Together with a teammate, I built a tool that simulates the airflow around a parachute. You set the parameters that define the parachute's shape, then run the simulation. We used numerical methods for the airflow and wrote algorithms to handle collisions between the parachute cloth and the ropes. It let DARE's engineers try out design changes quickly, and it gave our team real experience building this kind of software from scratch.

{{< figure src="images/parachute.gif" caption="Parachute cloth and ropes simulation" align="center" >}}

## Technology Stack

- **Python**: the main language for the project.
- **C++**: for the parts of the simulation that needed to be fast.
- **TKinter**: for the interface to set up parachute and simulation properties.
- **Cython**: to let the Python code talk to the C++ code.
