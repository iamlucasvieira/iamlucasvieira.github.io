+++
title = "Safe AI Autopilot"
date = "2023-06-08T22:43:54+01:00"
tags = ["aviation", "ai"]
+++

# Safe AI Autopilot

[[Source]](https://github.com/lucasctl/HybridRL-FlightControl) [[Paper]](https://arc.aiaa.org/doi/10.2514/6.2025-2795) [[Demo]](https://youtu.be/7ZOf5KNVHAk)

{{< figure src="images/sperry.jpeg" caption="In 1914, [Lawrence Sperry](https://www.historynet.com/lawrence-sperry-autopilot-inventor-and-aviation-innovator/) takes to the skies for the world's first autopilot flight" align="center" >}}

For my Master's thesis I built a machine-learning autopilot that can keep flying an aircraft even when something goes badly wrong, like a plane losing part of its wing. It adapts its control strategy on the fly so the aircraft stays under control. If you want the technical details:

[Code](https://github.com/lucasctl/HybridRL-FlightControl) / [Paper](https://repository.tudelft.nl/islandora/object/uuid%3A10f5fa68-f934-414a-9067-988f51f098cb?collection=education) / [Demo](https://youtu.be/7ZOf5KNVHAk)

## The Challenge

Air travel is one of the safest ways to get around, but traditional autopilots can struggle with unexpected malfunctions or structural failures. They're designed for a specific range of conditions, so they don't cope well when something falls outside that range.

## The solution

I wanted an autopilot that could adapt to conditions it was never explicitly designed for. To do that, I built an algorithm that combines Distributional Soft Actor-Critic (DSAC)[^1] and Incremental Dual Heuristic Programming (IDHP)[^2]. DSAC learns offline, using precomputed knowledge to make quick decisions. IDHP learns online, adapting in real time. Combining the two gives you an autopilot that can adjust to bad conditions as they happen while still drawing on what it learned beforehand.

{{< figure src="images/hybrid.png" caption="Topology of hybrid actor network." align="center" >}}

## Experiments

I tested the autopilot under sensor noise, changing flight conditions, and failure cases like partial loss of the rudder and aileron. In each case it kept control of the aircraft.

## Technology Stack

- **PyTorch**: to build and train the autopilot model.
- **Gymnasium**: to build the reinforcement learning environment.
- **Weights & Biases (W&B)**: for tracking experiments and MLOps.

[^1]: <https://arxiv.org/abs/1801.01290>
[^2]: <https://doi.org/10.1016/j.ifacol.2019.12.613>
