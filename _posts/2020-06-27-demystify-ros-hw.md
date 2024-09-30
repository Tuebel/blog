---
title: "[WIP] Demistify ROS Hardware & Control"
description: "Accumulation of information and best practices for implementing your own ROS HardwareInterface for ros_control."
layout: default
toc: true
comments: true
image: images/plain_cmake_preview.png
hide: false
search_exclude: true
categories: [ROS, Hardware, ros_control]
---

# Motivation
Information about implementing your own `HardwareInterface` or `RobotHW` is sparse and spread all over the internet.

# HardwareInterface
- Implemntation
- Configuration

# ROS Control
- Implementation
- Configuration

# ros_control_boilerplate
This is probably the easiest and go-to place for implementing a new `HardwareInterface` from scratch.
As the name suggests, most of the boilerplate you will always have to write is taken away from you.

# Multiple Robots
## Separate Control Loops: Namespacing
## Single Control Loop: Combined Hardware
