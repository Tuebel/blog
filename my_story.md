---
title: "My Story: How I got to here"
description: "How I got here"
layout: post
toc: true
hide: false
tags: [personal]
---

# Introduction
This site is my chance to write up a less formal version of my [CV](/cv) - chronologically instead of the fashionable reverse-chronological order.
I want to share how my interests have developed over time and how I got to where I am now.
Hopefully, this will also show you that doors can open in unexpected ways like a side project which will lead you to join a PhD program.

# Early Days
**I love robots** and yes, it started with a Lego R2D2.
It was a nice little toy but quite limited as it could only be controlled by a light and drive some predefined paths.
Fortunately, I got my hands on the yellow **Lego Mindstorms RCX brick in school**, where I learned to program it (I believe it was Java).
Later, I got a Lego Mindstorms NXT and built fun projects like a Lego seal and a dust wiper.

Programming got me hooked, and I started to learn it from books of the "... for kids" series by Hans-Georg Schumann.
My goal was to build 2D and 3D games, and my journey led me from some **Basic over Delphi to C++**.
To be honest, 3D games were a bit too ambitious for me at that time, since I lacked some basic trigonometry knowledge.
However, I also started to program more useful stuff like a **timetable app in C#** for my Windows Phone 7/8 (I miss you).
I published it on the Windows Store, and it was actually quite successful and had good ratings.
Back then, I didn't know that it **would open the door** for my professional career at the university.
Unfortunately, the only thing left from this app seems to be my stall [Facebook page](https://www.facebook.com/EasyTimetable/) I created for it.
I didn't know source control back then and personal websites were black magic to me (I had to teach myself).

## My first job: Marché at DUS airport
In school I started working at Marché at the international airport in Düsseldorf and stayed there for a few years.
It was quite nice since I could work quite a few hours on the weekend and during the holidays.
I got some responsibility organizing the shifts on event days and met all kinds of people from all over the world.
Working in a service job really teaches you a lot about people and how to handle them (customers can be a*** lot of fun).
Bonus: I got to taste the latest and greatest Mövenpick ice cream flavors.

# Studying at RWTH Aachen University
Time passed while studying mechanical engineering at the university.
While there was a course which included programming a **Lego NXT in Java**, it was quite underwhelming for me.
As side projects, I started building ESP8266-based IoT devices like an automatic plant watering system.

## My first technical job: student assistant
I actually liked my job, the international vibes and spirit of optimism at the airport.
But I felt the itch to do something more technical and started looking for a job at the university.
After some less successful applications, my soon-to-be mentor Jonas stumbled over my application.
He was looking for a student assistant who would help him to develop a GUI for his medical colleagues so they could easily play around with the cardiovascular system model he developed.
He needed someone who could program in C# and I had the experience from **my timetable app**.
In my memory the interview was like "Here is my app, look at the Windows Store ratings, it is quite successful".
So I got the job, developed the GUI which got a bit out of hand and became a full-fledged real-time hardware-in-the-loop environment.
In the end, we had a Linux backend programmed in C++, transferred data using TCP/IP and protobuf, CAN adapters, and custom boards.
Anyway, I learned a lot about software development, version control, and how to work in a team.
This job would also lead me on **my path to a PhD** at the same institute.

## First real robots: bachelor's thesis
My supervisor of the student assistant job would have loved to have me write a thesis at his institute, but I was keen to work with robots and see another institute.
So I found this thesis topic at the WZL of RWTH Aachen University, which would allow me to **finally work with real robots**.
Three robots to be precise: They were mounted vertically on a large linear axis and end effectors equipped with pneumatic grippers and force-to-torque sensor plates.
The goal was to use the robots to apply specific forces which would bring a shell into a predefined shape.
Since the main machine hall burned down shortly before I started, I got a brand-new setup in a brand-new hall.
The only downside: I was alone in this large hall most of the time, since it was the first test bench in the new hall.
I had to set up everything from scratch: the safety concept on a PLC, communication stack, force control interfaces, etc.
In the end, I had written a C++ "real-time" client for Windows which would communicate with the robots.
I exposed a C API which I called in Matlab, where I calculated the forces to be applied.
For my supervisor, I also wrote an interface for LabView which would call the C API.
Obviously, the amount of engineering work was quite high, so the scientific results had to be written down last minute. 

## Automation Engineering Master's program and thesis
- HiWi job: take over rehabilitation robot project
  - Who decided that programming an industrial robot in Java is a good idea?
  - Maybe took the same course as the Lego NXT one? Most popular at the time? Awful for linear algebra and robotics.
- After failing to convince me to do my bachelor's thesis at his institute, my supervisor proposed a master's thesis which I could not turn down
  - Using LiDAR / 3D sensor to detect bones, robotic surgery, how cool is that?
  - I learned a lot about ROS, C++, 3D sensors, computer vision (yes the rotating LiDAR the institute had was not the best for this task)

# PhD at the Institute of Automatic Control
