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
To increase the reusability, the logic / algorithms should be placed in a different package which does not rely on the ROS bits.
This enables the community or colleagues to use the code in non-ROS projects.
However, this requires the programmer to manually add the packaging magic that catkin would do.
This blog post provides some insight on what is required to make a CMake project 'find_packagable'.

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
## Includes and settings
First, we include some CMake helpers.
The former provides variables for default installation directories like `${CMAKE_INSTALL_LIBDIR}` while the former provides functions for the automatic generation of the CMake configuration files.
These files are mandatory for a CMake package to provide the `find_package` functionality.

```cmake
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
```

Afterwards, some variables are set to configure this package package.
We will use some modern features which require CMake version 3.1 or higher.
Then, we define a name and version for the package and set the C++ standard to version 11.
In the last line, we define the variable `ConfigPackageLocation` which contains the path where our CMake package configuration files will be installed.
Under Linux CMake will search in several locations for the Config.cmake file.
One of the locations is `lib/<package name>/` and we append `/cmake` to keep our installation directory clean.

```cmake
cmake_minimum_required(VERSION 3.1)
project(plain_cmake)
set(PLAIN_CMAKE_VERSION 0.1)
set(CMAKE_CXX_STANDARD 11)
set(ConfigPackageLocation ${CMAKE_INSTALL_LIBDIR}/${CMAKE_PROJECT_NAME}/cmake)
```

Finally, we need to include the dependencies of our package.
In this example, the Eigen3 library is required.

```cmake
find_package (Eigen3 3.3 REQUIRED NO_MODULE)
```

## Defining targets
This step is very similar to defining targets in a catkin package.
In this example, we define a library named after project which consists of a single source file.
Instead of 
However, as the [CMake documentation](https://cmake.org/cmake/help/latest/command/target_include_directories.html) states: "Include directories usage requirements commonly differ between the build-tree and the install-tree."

```cmake
add_library(${CMAKE_PROJECT_NAME}_lib)
target_sources(${CMAKE_PROJECT_NAME}_lib PRIVATE
  src/matrix_operations.cpp)
target_include_directories(${CMAKE_PROJECT_NAME}_lib PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>)
target_link_libraries(${CMAKE_PROJECT_NAME}_lib PUBLIC Eigen3::Eigen)
```

Moreover, we we define an application to showcase the installation and export of the targets later.
Since we defined the library earlier, this application only needs to be linked to this very library.

```cmake
add_executable(example_app src/example_app.cpp)
target_link_libraries(example_app ${CMAKE_PROJECT_NAME}_lib)
```

## Installing the targets
The obvious reason for using `install(TARGETS)` is to copy the libraries, binaries and headers to a system directory, where it can be found by other projects.
The not so obvious reason is that we can use the `EXPORT` command to associate the installation targets with `${CMAKE_PROJECT_NAME}Targets`, which will be important in the next section.
The `ARCHIVE`, `LIBRARY` and `RUNTIME` `DESTINATION` commands define where the files will be installed.
Here, we use the GNUInstallDirs helper variables for the destination.
There also exists an option to set the includes destination via `INCLUDES DESTINATION`.
However, the includes destination has already been set via `target_include_directories` and thus can be omitted.

```cmake
install(TARGETS ${CMAKE_PROJECT_NAME}_lib example_app
  EXPORT ${CMAKE_PROJECT_NAME}Targets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
```

The header files require a separate installation command to copy them to a system directory.
You can either use `install(FILES)` to install a list of files or `install(DIRECTORY)` to install a whole directory.
Since all header files of the example package are stored in the `include/plain_cmake` directory, we use the latter.
Again, we use a GNUInstallDirs variable for the include destination.
Please note the "/" after the "include".

```cmake
install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
```

## Export Targets
In the last section we associated the install targets with `${CMAKE_PROJECT_NAME}Targets`.
Now, we can use this to generate the `plain_cmakeTargets.cmake` which will allow other projects to import our targets.
The `NAMESPACE` is be prepended to the target names, so the library can be linked via `plain_cmake::plain_cmake_lib`.
If you have not specified an installation, you could alternatively use `export(TARGETS)` to manually specify the targets.

```cmake
export(EXPORT ${CMAKE_PROJECT_NAME}Targets
  FILE ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Targets.cmake
  NAMESPACE ${CMAKE_PROJECT_NAME}::)
```

The export command makes the targets available in the build tree only.
To make the targets available for projects which are not part of the build tree, they also require an installation:

```cmake
install(EXPORT ${CMAKE_PROJECT_NAME}Targets
  FILE ${CMAKE_PROJECT_NAME}Targets.cmake
  NAMESPACE ${CMAKE_PROJECT_NAME}::
  DESTINATION ${ConfigPackageLocation})
```

## Package Configuration Generation
This section describes the steps required to enable the `find_package` mechanism.
For our plain_cmake project two files are required to turn it into a package:
- `plain_cmakeConfigVersion.cmake`
- `plain_cmakeConfig.cmake`

We can use the `CMakePackageConfigHelpers` for the generation of both files.
The `plain_cmakeConfigVersion.cmake` can easily be generated by specifying he version number of the package and a compatibility:

```cmake
write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake
  VERSION ${PLAIN_CMAKE_VERSION}
  COMPATIBILITY SameMajorVersion)
```

Generating the `plain_cmakeConfig.cmake` involves a bit more work but we can use the `configure_package_config_file` helper which requires:
- The `plain_cmakeConfig.cmake.in` makes the targets and dependencies available to the importing project.
  This file will be explained in the next section.
- An output filename, which expands to `${CMAKE_CURRENT_BINARY_DIR}/plain_cmakeConfig.cmake`.
- The path where the `plain_cmakeConfig.cmake` will be installed, which is the same as the installation path of the `plain_cmakeTargets.cmake`.
- The ` PATHS_VARS <variable1> <variable2> ...` are variables of the installation locations.
  Our example package only requires one variable `INCLUDE_INSTALL_DIR` for the location of the headers.

```cmake
set(INCLUDE_INSTALL_DIR ${CMAKE_INSTALL_INCLUDEDIR})
configure_package_config_file(
  ${CMAKE_PROJECT_NAME}Config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake
  INSTALL_DESTINATION ${ConfigPackageLocation}
  PATH_VARS INCLUDE_INSTALL_DIR)
```

After generating both, the `ConfigVersion.cmake` and the `Config.cmake` files they can be installed to a system directory.
We use the same installation command that we used for the installation of the header files.
It is important, the installation `DESTINATION` matches the one specified in `configure_package_config_file`.

```cmake
install(FILES 
  ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake
  DESTINATION ${ConfigPackageLocation})
```

## The `Config.cmake.in` File
The first line will automatically be expanded by the config helpers to make the file relocatable.

```cmake
@PACKAGE_INIT@
```

Next, we make the targets we defined earlier available to the consumer projects:

```cmake
include(${CMAKE_CURRENT_LIST_DIR}/plain_cmakeTargets.cmake)
```

If we want to use our library in a catkin package we are required to set the variables `plain_cmake_INCLUDE_DIRS` and `plain_cmake_LIBRARIES`.
Otherwise `catkin_package()` would result in the following warning>

```
catkin_package() DEPENDS on 'plain_cmake' but neither 'plain_cmake_INCLUDE_DIRS' nor 'plain_cmake_LIBRARIES' is defined.
```

As `plain_cmake_INCLUDE_DIRS` is a path and we would like our package to be relocatable, we use the `@PACKAGE_<variable>@` macro.
This macro expands the path variables from `PATH_VARS` we passed to `configure_package_config_file`.
Earlier, we set the `INCLUDE_INSTALL_DIR` variable to `${CMAKE_INSTALL_INCLUDEDIR}`.
When building the plain_cmake library in a catkin workspace, the macro `@PACKAGE_INCLUDE_INSTALL_DIR@` is the expanded `<path to catkin_ws>/devel/include` and can be accessed via `plain_cmake_INCLUDE_DIRS`.

The `set_and_check` helper checks whether the path we set actually exists.
Moreover, we populate the `plain_cmake_LIBRARIES` with our library target - notice the namespace.

```cmake
set_and_check(plain_cmake_INCLUDE_DIRS "@PACKAGE_INCLUDE_INSTALL_DIR@")
set(plain_cmake_LIBRARIES plain_cmake::plain_cmake_lib)
```

Theoretically, we could use `find_package` and `target_link_libraries` to compile against our library now.
However this would result in an error that the target "Eigen3::Eigen" was not be found.
Forwarding the dependencies is easy using the find dependency macro.
Simply insert the same package requirements as in `find_package` from the beginning of your `CMakeLists.txt`.
The difference to `find_package` is that this macro will return with an error message from the `Config.cmake` iif the package cannot be found.

Please note that there seems to be an issue with the expansion of the `@PACKAGE_<...>@` macros when using `find_dependency` before it.
When finding Eigen3 before setting the `plain_cmake_INCLUDE_DIRS` it would point to the Eigen3 include directory instead of the plain_cmake ones.

```cmake
include(CMakeFindDependencyMacro)
find_dependency(Eigen3 3.3 REQUIRED NO_MODULE)
```

Finally it is recommended to call the following to confirm that all required components have been found:

```cmake
check_required_components(plain_cmake)
```

# Usage

## Build and Installation

## Catkin Workspacce


## CMake

## References
[^1]: [https://www.ros.org/reps/rep-0134.html]



# TODO
- Plain CMake packages cannot be compiled via `catkin_make` [^1].
- Having ROS dependencies requires catkin anyways.
- Use inclusive "we"
- 
