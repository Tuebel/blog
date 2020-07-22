---
title: "(WIP) ROS Plain CMake"
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

# Example repository
A minimal working example of a ROS workspace can be found [here](https://github.com/Tuebel/ros_plain_cmake).
This workspace contrains three packages:
1. [catkin_pkg](https://github.com/Tuebel/ros_plain_cmake/tree/master/src/catkin_pkg): test the plain_cmake package in a ROS workspace
2. [consumer_cmake](https://github.com/Tuebel/ros_plain_cmake/tree/master/src/consumer_cmake): test the system installation of plain_cmake in another CMake project
3. [plain_cmake](https://github.com/Tuebel/ros_plain_cmake/tree/master/src/plain_cmake): minimal example of a plain CMake package for ROS
This blog post will fokus on the plain_cmake package.

Importing the package into another CMake or catkin package is straight forward and tutorials can be found in the [ROS wiki](http://wiki.ros.org/catkin/Tutorials/CreatingPackage).

# package.xml
Even though a `package.xml` is not required for the CMake functionalities, it is still required in the context of ROS.
This file gets parsed by the build tool to determine the dependencies and the build order.
To mark our project as plain CMake we add the following tags to our `package.xml`:
```xml
<buildtool_depend>cmake</buildtool_depend>

<exports>
  <build_type>cmake</build_type>
</exports>
```
Many dependencies can be installed via [rosdep](http://wiki.ros.org/rosdep) so they should be added, too.
Make sure to visit [rosindex](http://rosindex.github.io/) to find the correct name of the dependencies.
For example for linear algebra, matrix and vector operations the package could depend on [Eigen](http://eigen.tuxfamily.org/):
```xml
<depend>eigen</depend>
```

# CMakeLists.txt
## Basic configuration
First, some basic configuration variables are set for the package.
We will use some modern features which require CMake version 3.0 or higher.
Moreover, we define a name and version for the package.
```cmake
cmake_minimum_required(VERSION 3.0)
project(plain_cmake)
set(PLAIN_CMAKE_VERSION 0.1)
```
Now we include some CMake helpers which provide default installation locations and helpers to generate the CMake configuration.
```cmake
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
```
Finally, we need to include the dependencies of our package.
In this example, the Eigen3 library is required.
```cmake
find_package (Eigen3 3.3 REQUIRED NO_MODULE)
```

## Defining targets
This step is very similar to defining targets in a catkin package.
In this example, we define a library named after project which consists of a single source file.
The only difference ...

```cmake
add_library(${CMAKE_PROJECT_NAME}_lib src/matrix_operations.cpp)
# different locations on build and after install
target_include_directories(${CMAKE_PROJECT_NAME}_lib PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>)
target_link_libraries(${CMAKE_PROJECT_NAME}_lib PUBLIC Eigen3::Eigen)
```

## Config generation
Both, the `plain_cmakeConfigVersion.cmake` and the `plain_cmakeConfig.cmake` are required for the `find_package` functionality.


## Installation
- Build in source tree
- Build out of source tree

## Building the Project

## References
[^1]: [https://www.ros.org/reps/rep-0134.html]



# TODO
- Plain CMake packages cannot be compiled via `catkin_make` [^1].
- Having ROS dependencies requires catkin anyways.
- Use inclusive "we"
- 
