---
title: "ROS Plain CMake"
description: "Tutorial on creating a plain CMake package that can be used in a catkin workspace and as a system dependency without  ROS."
layout: post
toc: true
comments: true
# image: images/plain_cmake_preview.png
hide: false
search_exclude: true
categories: [ROS, CMake]
---

# Motivation
Even though it is considered best practice to separate the ROS code from the logic, they are commonly placed in the same ROS package.
To enable reusing the code in a ROS-agnostic context, the logic and the ROS-bits should be placed in a different packages.
However, this requires the programmer to manually add the packaging magic of `catkin_package()`.
This blog post provides insight on what is required to make a CMake project 'find_packagable' [^CmakePackage].

# Example repository
A minimal working example of a ROS workspace can be found [here](https://github.com/Tuebel/ros_plain_cmake).
This workspace contains three packages:
1. [plain_cmake](https://github.com/Tuebel/ros_plain_cmake/tree/master/src/plain_cmake): Minimal example of a plain CMake package for ROS.
2. [catkin_pkg](https://github.com/Tuebel/ros_plain_cmake/tree/master/src/catkin_pkg): Test the plain_cmake package in a ROS workspace.
3. [consumer_cmake](https://github.com/Tuebel/ros_plain_cmake/tree/master/src/consumer_cmake): Test the system installation of plain_cmake in another CMake project.

This blog post will fokus on the plain_cmake package but will also give short examples of reusing the package.

# package.xml
Even though a *package.xml* is not required for the CMake functionalities, it is still required in the context of ROS.
This file gets parsed by the build tool, for example `catkin build` to determine the dependencies and the build order [^REP140].
To mark our project as plain CMake we add the following tags to our *package.xml*:

```xml
<buildtool_depend>cmake</buildtool_depend>
<exports>
  <build_type>cmake</build_type>
</exports>
```

Many dependencies can be installed via [rosdep](http://wiki.ros.org/rosdep) so they should be added to the *package.xml*, too.
Make sure to visit [rosindex](http://rosindex.github.io/) to find the correct name of the dependencies.
For example for linear algebra, matrix and vector operations the package could depend on [Eigen](http://eigen.tuxfamily.org/):

```xml
<depend>eigen</depend>
```

# CMakeLists.txt
## Includes and Settings
First, we include some CMake helpers.
`GNUInstallDirs` provides variables for default installation directories like `${CMAKE_INSTALL_LIBDIR}` while the `CMakePackageConfigHelpers` provides functions for the automatic generation of the CMake configuration files.

```cmake
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)
```

Afterwards, some package specific variables are set.
We will use some modern features which require CMake version 3.1 or higher.
Then, we define a name and version for the package and set the C++ standard to version 11.
In the last line, we define the variable `ConfigPackageLocation` which contains the path where our CMake package configuration files will be installed [^UseCmakeEnabled].
Under Linux, CMake will search in several locations for the Config.cmake file.
One of the locations is `lib/<package name>/cmake`.

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
It is good practice to include headers and sources for each target instead of using the global `include_directories()` [^DoCmakeRight].
For the sources, `target_sources()` is considered IDE friendly but defining a library without any source will lead to a catkin warning.
Adding at least one source file to the library seems to do the trick and all sources can be added via `target_sources()` 
Including the header directories however is a bit more complicated, as the [CMake documentation](https://cmake.org/cmake/help/latest/command/target_include_directories.html) states: "Include directories usage requirements commonly differ between the build-tree and the install-tree.".
Therefore, we have to use generator expressions to specify the correct include paths [^HeaderOnly].

```cmake
add_library(${CMAKE_PROJECT_NAME}_lib src/matrix_operations.cpp)
target_sources(${CMAKE_PROJECT_NAME}_lib PRIVATE
  src/matrix_operations.cpp)
target_include_directories(${CMAKE_PROJECT_NAME}_lib PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>)
target_link_libraries(${CMAKE_PROJECT_NAME}_lib PUBLIC Eigen3::Eigen)
```

Moreover, we define an application and link it to our library:

```cmake
add_executable(example_app src/example_app.cpp)
target_link_libraries(example_app ${CMAKE_PROJECT_NAME}_lib)
```

## Installing the targets
The obvious reason for using `install(TARGETS)` is to copy the libraries, binaries and headers to a system directory, where they can be found by other projects [^ModernCmakeInstall].
The not so obvious reason is that we can use the `EXPORT` command to associate the installation targets with `plain_cmakeTargets`, which we will use in the next section.
The `ARCHIVE`, `LIBRARY` and `RUNTIME` `DESTINATION` commands define where the files will be installed.
Here, we use the `GNUInstallDirs` helper variables for the destination.
There also exists an option to set the includes destination via `INCLUDES DESTINATION`.
However, the includes destination has already been set via `target_include_directories` and thus can be omitted [^HeaderOnly].

```cmake
install(TARGETS ${CMAKE_PROJECT_NAME}_lib example_app
  EXPORT ${CMAKE_PROJECT_NAME}Targets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
```

The header files require a separate installation command to copy them to a system directory.
You can either use `install(FILES)` to install a list of files or `install(DIRECTORY)` to install a whole directory.
Since all header files of the example package are stored in the *include/plain_cmake* directory, we use the latter.
Again, we use a `GNUInstallDirs` variable for the include destination.
Please note the '/' after the 'include'.

```cmake
install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
```

## Export Targets
In the last section we associated the install targets with `plain_cmakeTargets`.
Now, we can use this association to generate the *plain_cmakeTargets.cmake* which will allow other projects to import our targets.
The `NAMESPACE` is be prepended to the target names, so we can link to this library via `plain_cmake::plain_cmake_lib`.
If you do not want to specify and associate an installation target, you could alternatively use `export(TARGETS)` to manually specify and export the targets for the build tree.

```cmake
export(EXPORT ${CMAKE_PROJECT_NAME}Targets
  FILE ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Targets.cmake
  NAMESPACE ${CMAKE_PROJECT_NAME}::)
```

The export command makes the targets available in the build tree only [^InstallExportCmake].
To make the targets available for projects which are not part of the build tree, we also have to install them:

```cmake
install(EXPORT ${CMAKE_PROJECT_NAME}Targets
  FILE ${CMAKE_PROJECT_NAME}Targets.cmake
  NAMESPACE ${CMAKE_PROJECT_NAME}::
  DESTINATION ${ConfigPackageLocation})
```

## Package Configuration Generation 
This section describes the steps required to enable the `find_package` mechanism.
For our plain_cmake project two files are required to turn it into a CMake package:
- *plain_cmakeConfigVersion.cmake*
- *plain_cmakeConfig.cmake*

We can use the `CMakePackageConfigHelpers` for the generation of both files [^ConfigHelpers].
The *plain_cmakeConfigVersion.cmake* can easily be generated by specifying the version number of the package and a compatibility setting:

```cmake
write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake
  VERSION ${PLAIN_CMAKE_VERSION}
  COMPATIBILITY SameMajorVersion)
```

Generating the *plain_cmakeConfig.cmake* involves a bit more work.
But, we can use the `configure_package_config_file` helper to simplify the process.
This helper function requires:
- The *plain_cmakeConfig.cmake.in* makes the targets and dependencies available to the importing project.
  This file will be explained in the next section.
- An output filename, which expands to *${CMAKE_CURRENT_BINARY_DIR}/plain_cmakeConfig.cmake*.
- The path where the *plain_cmakeConfig.cmake* will be installed, which is the same as the installation path of *plain_cmakeTargets.cmake*.
- The `PATHS_VARS variable1 variable2 ...` can be used to pass different installation locations to the *plain_cmakeConfig.cmake.in*.
  Our example package only requires one variable `INCLUDE_INSTALL_DIR` for the location of the headers.

```cmake
set(INCLUDE_INSTALL_DIR ${CMAKE_INSTALL_INCLUDEDIR})
configure_package_config_file(
  ${CMAKE_PROJECT_NAME}Config.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake
  INSTALL_DESTINATION ${ConfigPackageLocation}
  PATH_VARS INCLUDE_INSTALL_DIR)
```

After generating both, the *ConfigVersion.cmake* and the *Config.cmake* files, they can be installed to a system directory.
We use the same installation command that we used for the installation of the header files.
It is important that the installation `DESTINATION` matches the one specified in `configure_package_config_file`.

```cmake
install(FILES 
  ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake
  DESTINATION ${ConfigPackageLocation})
```

## Config.cmake.in
The first line will be automatically expanded by the config helpers to make the file relocatable.

```cmake
@PACKAGE_INIT@
```

Next, we make the targets which we defined earlier available to the consumer projects:

```cmake
include(${CMAKE_CURRENT_LIST_DIR}/plain_cmakeTargets.cmake)
```

If we want to use our library in a **catkin package** we are required to set the variables `plain_cmake_INCLUDE_DIRS` and `plain_cmake_LIBRARIES`.
Otherwise `catkin_package()` would result in the following warning:

```bash
catkin_package() DEPENDS on 'plain_cmake' but neither 'plain_cmake_INCLUDE_DIRS' nor 'plain_cmake_LIBRARIES' is defined.
```

To make our package relocatable, we use the `@PACKAGE_<variable>@` macro for the path of `plain_cmake_INCLUDE_DIRS`.
This macro expands the path variables from `PATH_VARS` we passed to `configure_package_config_file`.
Remember, we set the `INCLUDE_INSTALL_DIR` variable to `${CMAKE_INSTALL_INCLUDEDIR}`.
For example, when building the plain_cmake library in a catkin workspace, the macro `@PACKAGE_INCLUDE_INSTALL_DIR@` is the expanded `path/to/catkin_ws/devel/include`.

The `set_and_check` helper checks whether the path we set actually exists.
Moreover, we populate the `plain_cmake_LIBRARIES` with our library target - notice the namespace.

```cmake
set_and_check(plain_cmake_INCLUDE_DIRS "@PACKAGE_INCLUDE_INSTALL_DIR@")
set(plain_cmake_LIBRARIES plain_cmake::plain_cmake_lib)
```

Theoretically, we could use `find_package` and `target_link_libraries` to compile against our library now.
However, this would result in an error that the target `Eigen3::Eigen` was not be found.
Forwarding the dependencies is easily accomplished by using the find dependency macro.
Simply insert the same package requirements as in `find_package` from the beginning of your *CMakeLists.txt*.
The difference to `find_package` is that this macro will return with an error message from the *Config.cmake* iif the package cannot be found.

Please note that there seems to be an issue with the expansion of the `@PACKAGE_<...>@` macros when using `find_dependency` before it.
When finding Eigen3 before setting the `plain_cmake_INCLUDE_DIRS`, the path would be expanded to the Eigen3 include directory instead of the plain_cmake's one.

```cmake
include(CMakeFindDependencyMacro)
find_dependency(Eigen3 3.3 REQUIRED NO_MODULE)
```

Finally it is recommended to call the following line to confirm that all required components have been found:

```cmake
check_required_components(plain_cmake)
```

# Usage
Now that we have completed our plain CMake package, it is time to use it in another project.
We implemented the package so that it can be used in the build tree of a catkin workspace or from a system installation.

## Catkin Workspace
Using the `plain_cmake` package is pretty straight forward, almost as using any other catkin package.
Catkin uses the *package.xml* to determine the build order [^REP140].
Thus, we add the following line to the *package.xml* of the consumer package:

```xml
<depend>plain_cmake</depend>
```

In the *CMakeLists.txt* of the catkin package we can use the `find_package` mechanism to use our plain_cmake package.

```cmake
find_package(plain_cmake REQUIRED) 
```

Catkin uses the `catkin_package` macro to generate the package configuration which we generated via `configure_package_config_file` and `write_basic_package_version_file`.
To forward our package further down the dependency tree, we have to add it as a non-catkin dependency [^RosCmake]: 

```cmake
catkin_package(
 CATKIN_DEPENDS roscpp std_msgs
 DEPENDS plain_cmake)
```

After `catkin_package()`, the targets of the catkin package can be defined.
For example, we can add a ROS node executable that depends on the `plain_cmake_lib`.
If the package was found via `find_package()`, the library can be linked via `target_link_library()`.
Since we exported the target in the namespace `plain_cmake`, we have to link the node against `plain_cmake::plain_cmake_lib`.

```cmake
add_executable(test_node src/test_node.cpp)
target_include_directories(test_node 
  PRIVATE ${catkin_INCLUDE_DIRS})
target_link_libraries(test_node
  PRIVATE ${catkin_LIBRARIES} plain_cmake::plain_cmake_lib)
```

Finally, we can compile the whole catkin workspace.
As the plain CMake package makes it a mixed workspace, we cannot use `catkin_make`.
Instead, `catkin_make_isolated`[^REP134] or the catkin_tools have to be used.
An example can be found in [catkin_pkg](https://github.com/Tuebel/ros_plain_cmake/tree/master/src/catkin_pkg).

## CMake System Installation
Since the `plain_cmake` package's only ROS bit is the *package.xml*, it can be installed and used like any other system dependency.
Navigate to the *plain_cmake* directory and create a *build* directory to keep the workspace clean.
Inside this directory we can call the typical sequence of commands to build and install a CMake package.
For development, I prefer using `checkinstall` instead of `make install` because it enables an easy cleanup via apackage manager like `dpkg`.

```bash
cd path/to/plain_cmake
mkdir build && cd build
cmake ..
make
sudo checkinstall
```

After installing the package to the system, we can use it in another CMake project by finding it and linking against it just like in the catkin workspace example.
The only difference is, that we do not use the `catkin_package` macro.

```cmake
find_package(plain_cmake)
add_executable(app src/app.cpp)
target_link_libraries(app plain_cmake::plain_cmake_lib)
```

A full example can be found in [consumer_cmake](https://github.com/Tuebel/ros_plain_cmake/tree/master/src/consumer_cmake).
Note, that if you compile the whole repository with catkin, the consumer_cmake project is not compiled as it does not include a *package.xml*.

# Conclusion
We have implemented a plain CMake package that can be used in a catkin workspace and in a ROS-agnostic setting.
This portability is also useful, if you intend to transition to ROS2 in the near future, as colcon supports plain CMake packages, too.
If you have any questions or recommendations, feel free to comment or open a pull-request 🤖.

## References and Useful Resources
[^REP134]: https://www.ros.org/reps/rep-0134.html
[^REP140]: https://www.ros.org/reps/rep-0140.html
[^ModernCmakeInstall]: https://cliutils.gitlab.io/modern-cmake/chapters/install/installing.html
[^DoCmakeRight]: https://pabloariasal.github.io/2018/02/19/its-time-to-do-cmake-right/
[^InstallExportCmake]: https://medium.com/@kkunalsharma825/install-and-export-in-cmake-5c26d20ff715
[^UseCmakeEnabled]: https://coderwall.com/p/qej45g/use-cmake-enabled-libraries-in-your-cmake-project-iii
[^HeaderOnly]: https://dominikberner.ch/cmake-interface-lib/
[^ConfigHelpers]: https://cmake.org/cmake/help/latest/module/CMakePackageConfigHelpers.html
[^CmakePackage]: https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html
[^RosCmake]: wiki.ros.org/catkin/CMakeLists.txt
