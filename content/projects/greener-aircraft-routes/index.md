---
author: "Lucas vieira"
title: "Greener Aircraft Routes"
description: "Greener Aircraft Routes"
summary: ""
date: "2024-01-06T22:29:38+01:00"
tags: ["project", "optimisation", "aircraft", "fuel", "sustainability"]
categories: ["project"]
series: []
draft: false
hideSummary: true
hideMeta: true
cover:
  image: "example.jpg"
  alt: ""
  caption: ""
  hiddenInList: true
---

I have developed a tool that assists airlines in designing aircraft routes that minimise fuel consumption and noise emissions. Intelligent routes are crucial to achieving a greener future for the aviation industry. The algorithm uses data from the Dutch population and aircraft fuel equations. Airlines can benefit from this tool, as it helps them save on fuel expenses while also reducing their impact on communities near airports.

## The Challenge

Fuel consumption and noise pollution are significant drawbacks associated with air travel. The aviation industry must minimise these effects to achieve a net zero soon. Lowering fuel consumption reduces air pollution and airline operational costs. Also, reducing noise improves the quality of life for people living near flight paths.

## The Solution

I created a tool that helps find the best flight routes based on fuel efficiency and minimal noise disturbance. You can enter the flight's starting and ending points, and the tool will turn it into a multi-objective linear programming problem to find the best route. Finally, it generates a report that lists all possible routes and their corresponding impacts.

{{< figure src="solution.png" caption="Finding a route that avoids populated areas while still finding a short path" align="center" >}}

## Technology Stack

- **Python**: Main language for development.
- **Gurobi**: Chosen tool for solving the linear programming problem.
