# ROS Plain CMake project
Table of contents:
1. TOC
{:toc}

## Why Plain CMake?
There is one big reason to use a plain CMake package instead of a catkin: **flexibility**.
Using catkin specific commands in your `CMakeLists.txt` prohibits to compile the package using good old CMake.
Thus, colleagues or the community might not be able to use your awesome package.
However, I would recommend to only us plain CMake for a core library which does not have any ROS dependencies:

- Catkin takes away a lot of the pain involved with enabling `find_package` for a CMake package.
- Plain CMake packages cannot be compiled via `catkin_make` [^1].
- Having ROS dependencies requires catkin anyways.

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
