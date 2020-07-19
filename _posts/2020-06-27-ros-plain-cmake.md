---
title: "ROS Plain CMake"
description: "Tutorial on creating a plain CMake package without any ROS dependencies that can be used with ROS."
layout: post
toc: true
comments: true
# image: https://commons.wikimedia.org/wiki/File:Cmake.svg
hide: false
search_exclude: true
categories: [ROS, CMake]
---

# Motivation
Even though it is considered best practice to separate the ROS code from the logic, they are commonly placed in the same ROS package.
To increase the reusability, the logic should be placed in a different package which does not rely on the ROS bits.
This enables the community or colleagues to use the code in non-ROS projects.
However, this requires the programmer to manually add the packaging magic that catkin would do.
This blog post is meant to provide some insight on what is required to make a CMake project 'find_packagable' to enable:
- `find_package` in a ROS workspace
- `find_package` as a system dependency
- importing targets and forwarding their dependencies

## package.xml
As any other ROS package, a `package.xml` is required.
This file gets parsed by the build tool to determine the dependencies and the build order.
To mark your project as plain CMake add the following tags to your `package.xml`:
```xml
<buildtool_depend>cmake</buildtool_depend>

<exports>
  <build_type>cmake</build_type>
</exports>
```

Many dependencies can be installed via `rosdep`[^2] so they should be added, too.
Make sure to visit [rosindex](http://rosindex.github.io/) to find the correct name of the dependencies.
For example for OpenGL based rendering one might include:
```xml
<depend>glut</depend>
<depend>opengl</depend>
<depend>libglfw3-dev</depend>
<depend>assimp</depend>
<depend>libglm-dev</depend>
```

## CMake Packages / Make it `find_package`' able
- Build in source tree
- Build out of source tree

## Building the Project

## References
[^1]: [https://www.ros.org/reps/rep-0134.html]
[^2]: [http://wiki.ros.org/rosdep]



# TODO
- Plain CMake packages cannot be compiled via `catkin_make` [^1].
- Having ROS dependencies requires catkin anyways.
