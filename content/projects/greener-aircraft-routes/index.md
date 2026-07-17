+++
title = "Greener Aircraft Routes"
date = "2023-01-06T22:29:38+01:00"
tags = ["aviation", "simulation"]
+++

# Greener Aircraft Routes

I built a tool that helps airlines design flight routes with lower fuel use and less noise. It uses Dutch population data and aircraft fuel equations to find routes that cost less to fly and cause less disruption for people living near airports.

{{< figure src="images/example.jpg" caption="Greener Aircraft Routes" align="center" >}}

## The Challenge

Fuel and noise are two of the biggest downsides of air travel. Burning less fuel means less pollution and lower costs for the airline. Cutting noise means a better quality of life for people who live under flight paths. The industry needs to reduce both to get anywhere near net zero.

## The Solution

The tool finds the best flight route based on fuel efficiency and noise. You give it a start and end point, and it turns that into a multi-objective linear programming problem to solve. At the end it produces a report listing the possible routes and the impact of each one.

{{< figure src="images/solution.png" caption="Finding a route that avoids populated areas while still finding a short path" align="center" >}}

## Technology Stack

- **Python**: Main language for development.
- **Gurobi**: Chosen tool for solving the linear programming problem.
