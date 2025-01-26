---
title: "My Story: How I got to here"
description: "How I got here"
layout: post
toc: true
hide: false
tags: [personal]
---

# Introduction
This site is my chance to write up a less formal version of my [CV](/cv) — chronologically instead of the fashionable reverse-chronological order.
I want to share how my interests have developed over time and how I got to where I am now.
Hopefully, this will also show you that doors can open in unexpected ways, like a side project that will lead you to join a PhD program.

# Early Days (~2004-2010)
**I love robots,** and yes, it started with a Lego R2D2.
It was a nice little toy but quite limited as it could only be controlled by a light and drive some predefined paths.
Fortunately, I got my hands on the yellow **Lego Mindstorms RCX brick in school**, where I learned to program it (I believe it was Java).
Later, I got a Lego Mindstorms NXT and built fun projects like a Lego seal and a dust wiper.

Programming got me hooked, and I started to learn it from books of the “... for kids" series by Hans-Georg Schumann.
My goal was to build 2D and 3D games, and my journey led me from some **Basic over Delphi to C++**.
To be honest, 3D games were a bit too ambitious for me at that time, since I lacked some basic trigonometry knowledge.
However, I also started to program more useful stuff, like a **timetable app in C#** for my Windows Phone 7/8 (I miss you).
I published it on the Windows Store, and it was actually quite successful and had good ratings.
Back then, I didn't know that it **would open the door** for my professional career at the university.
Unfortunately, the only thing left from this app seems to be my stall [Facebook page](https://www.facebook.com/EasyTimetable/) I created for it.
I didn't know source control back then, and personal websites were black magic to me (I had to teach myself).

## My first job: Marché at DUS airport (2011-2015)
In school, I started working at Marché at the international airport in Düsseldorf and stayed there for a few years.
It was quite nice since I could work quite a few hours on the weekend and during the holidays.
I got some responsibility organizing the shifts on event days and met all kinds of people from all over the world.
Working in a service job really teaches you a lot about people and how to handle them (customers can be a*** lot of fun).
Bonus: I got to taste the latest and greatest Mövenpick ice cream flavors.

# Studying at RWTH Aachen University (2013-2018)
Time passed while studying mechanical engineering at the university.
While there was a course that included programming a **Lego NXT in Java**, it was quite underwhelming for me.
As side projects, I started building ESP8266-based IoT devices like an automatic plant watering system.

## My first technical job: student assistant (2015-2018)
I actually liked my job and the international vibes and spirit of optimism at the airport.
But I felt the itch to do something more technical and started seeking employment at the university.
After some less successful applications, my soon-to-be mentor stumbled over my application.
He was looking for a student assistant who would help him to develop a GUI for his medical colleagues so they could easily play around with the cardiovascular system model he developed.
He needed someone who could program in C#, and I had the experience from **my timetable app**.
In my memory, the interview was like, “Here is my app; look at the Windows Store ratings; it is quite successful.”
So I got the job, developed the GUI, which got a bit out of hand, and became a full-fledged real-time hardware-in-the-loop environment.
In the end, we had a Linux backend programmed in C++, transferred data using TCP/IP and Protocol Buffers, CAN adapters, and custom boards.
Anyway, I learned a lot about software development, version control, and how to work in a team.
This job would also lead me on [my path to a PhD](/my_story#phd-at-the-institute-of-automatic-control-2018-2025) at the same institute.

## First real robots: bachelor's thesis (2017)
My supervisor of the student assistant job would have loved to have me write a thesis at his institute, but I was keen to work with robots and see another institute.
So I found this thesis topic at the WZL of RWTH Aachen University, which would allow me to **finally work with real robots**.
Three robots, to be precise: They were mounted vertically on a large linear axis and end effectors equipped with pneumatic grippers and force-to-torque sensor plates.
The goal was to use the robots to apply specific forces that would bring a shell into a predefined shape.
Since the main machine hall burned down shortly before I started, I got a brand-new setup in a brand-new hall.
The only downside: I was alone in this large hall most of the time, since it was the first test bench in the new hall.
I had to set up everything from scratch: the safety concept on a PLC, communication stack, force control interfaces, etc.
In the end, I had written a C++ “real-time” client for Windows that would communicate with the robots.
I exposed a C API, which I called in Matlab, where I calculated the forces to be applied.
For my supervisor, I also wrote an interface for LabView that would call the C API.
Obviously, the amount of engineering work was quite high, so the scientific results had to be written down at the last minute. 

## Automation engineering master's program and thesis (2017-2018)
During my bachelor's degree, I had to choose a specialization, and I chose production engineering — which bored me after having to draw the house of quality for the 3rd time.
I was looking for something more challenging that would bring me closer to robotics.
So I found the automation engineering program, which was a mix of mechanical engineering, electrical engineering, and computer science.

While my mentor from my student assistant job failed to convince me to write my bachelor's thesis at his institute, he proposed a master's thesis, which I could not turn down.
He sketched a project where we would use a LiDAR sensor to detect bones and use this information to guide a robotic surgery system.
First, I had to convince my supervisor to buy a 3D camera instead of reusing a rotating LiDAR, since the latter does not provide a sufficient resolution.
The challenging part was that neither he nor I had any experience in computer vision, so it took quite some time to find a suitable approach.
Moreover, deep learning was unpopular at the institute at that time, so there was no capable hardware to train a neural network.
I first figured that the task would be a pose estimation problem, so I started with the LineMOD approach and some 3D-printed hip bones.
This approach did not work whatsoever, since the bones neither provided textures nor geometric features.
The breakthrough came when I figured out that we only need to track the pose of the bones, which is much easier than detecting it without prior knowledge.
In the end, I implemented the very first version of a particle-based pose tracking algorithm on depth images, which I would build upon in my PhD.
At that time I learned a lot about **ROS, C++, 3D sensors, computer vision**.

The focus of my **student assistant job** also shifted towards a project where I had to program a rehabilitation robot for the upper extremities.
A colleague dropped out of the project, so I basically took over the project as a student assistant.
Most of the missing parts were related to usability and safety for the therapists and patients.
I had to program the robot in Java (KUKA Sunrise), which was a pain since the robot was an industrial robot and not a Lego NXT.
So I wrote Java code with factory patterns and other patterns to make Java bearable.
Programming math, specifically linear algebra, in Java is a pain, but I successfully implemented a controller for hand guidance and compliant replaying of recorded movements.

# PhD at the Institute of Automatic Control (2018-2025)
