+++
title = "Drone Testing Framework"
date = "2022-09-08T22:37:53+01:00"
tags = ["automation"]
+++

# Drone Testing Framework

My software engineering internship with [Avy](https://avy.eu/) allowed me to streamline the testing process for the company's drones. I created a framework that facilitates setting up tests and a user-friendly command-line tool to run them.

{{< figure src="images/setup.jpg" caption="Setup of the drone testing framework" align="center" >}}

## The Challenge

Before my project, drone testing was a laborious, manual task. Engineers had to connect to each drone and send commands to check hardware and software integrity. This process was not only time-consuming but also vulnerable to human errors. If a fault was detected, the drone had to be returned for repairs, and the entire testing sequence would have to be rerun.

## The Solution

I created a framework that allows engineers to pre-program a communication sequence with the drones, which automatically evaluates the drones' responses. To make things smoother, I built a command-line tool to execute these tests at the push of a button, saving both time and sanity.

{{< figure src="images/aat.png" caption="CLI interface of the automated testing tool." align="center" >}}

## Overcoming Difficulties

My initial vision for this tool included wireless connections to the drones. However, implementing this feature presented a couple of challenges. First, a wireless system would make the tool dependent on the drone's firmware authentication system. Secondly, a tool that wirelessly connects to any drone could be a security risk. Think about someone reverse-engineering it and using it to control a drone remotely.

After weighing the pros and cons, I opted for a USB connection, which was more straightforward and more efficient. This method had two perks. First, it instantly establishes a communication link between the computer and the drone. Second, it signals the drone's firmware to ignore any movement commands, ensuring safety during testing.

The USB solution also made it easier to use the tool. All the production team needed to do was plug in the drone, run the command `aat run`, and voila! The tests were executed automatically, and a detailed report was generated.

## The Impact

This new framework significantly reduced testing time, bringing higher efficiency and reliability to Avy's production process. The Automated Testing Framework allows the production team to allocate more time for complex tasks while the tool is autonomously testing the drones.

## Technology Stack

- **Python**: The core programming language for this project and the command-line application
- **[Typer](https://typer.tiangolo.com/)**: A modern library that simplified the CLI development.
- **[MAVLink](https://mavlink.io/en/)**: The protocol used to build the communication between the testing framework and the drones.
