---
title: "GitLab CI and git submodules"
description: "GitLab CI does not clone git submodules by default and defaults to shallow clones, which leads to issues when building PX4."
layout: post
hide: false
tags: [gitlab, ci, wiki]
---

When trying to build [PX4](https://docs.px4.io/main/en/dev_setup/building_px4.html), a drone autopilot software, I ran into a failure that only occurs in the GitLab CI.
This failure occurred in a script, which checks whether a specific tag of a git submodule is available.
It turns out that GitLab only does a shallow clone of the repository, and submodules need special care.

# Why did I need GitLab to clone the submodules?
We customized the gazebo simulation package to include our drone setup.
These changes were pushed to a private repository, which cannot be accessed without an access token.
The easiest solution is to let GitLab clone the submodules, as it will take care of the permissions.
This resulted in a CI script like the following:

```yaml
build_job:
  stage: build_px4
  variables:
    ROS_DISTRO_ARG: ROS_DISTRO=noetic
    # Required to clone customized px4-sitl_gazebo-classic from our private GitLab
    GIT_SUBMODULE_STRATEGY: recursive
  script:
    - /kaniko/executor
      --build-arg "CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE"
      --build-arg $ROS_DISTRO_ARG
      --build-arg "CI_COMMIT_REF_NAME=$CI_COMMIT_REF_NAME"
      --cache
      --context $CI_PROJECT_DIR
      --dockerfile $CI_PROJECT_DIR/docker/px4/Dockerfile
      --destination $CI_REGISTRY_IMAGE/$CI_COMMIT_REF_NAME:noetic-px4
```

# The error
In the Dockerfile, we build PX4 using their make instructions.
However, this is the error message that occurred in GitLab but not on my machine:

```bash
FAILED: src/lib/version/build_git_version.h 
cd /home/vscode/px4 && /usr/bin/python3 /home/vscode/px4/src/lib/version/px_update_git_header.py /home/vscode/px4/build/px4_sitl_default/src/lib/version/build_git_version.h --validate --git_tag 'v1.14.0-beta2-4964-gb674d6ce706'
Traceback (most recent call last):
  File "/home/vscode/px4/src/lib/version/px_update_git_header.py", line 132, in <module>
    nuttx_git_tag = re.findall(r'nuttx-[0-9]+\.[0-9]+\.[0-9]+', nuttx_git_tags)[-1].replace("nuttx-", "v")
```

The `px_update_git_header.py` script checks whether a specific git tag is available.
It turns out that GitLab creates shallow clones by default, which does not include the required tag.

# The solution
Typical suggestions are setting `GIT_DEPTH` and `GIT_SUBMODULE_DEPTH` to `0` to disable shallow clones.
In my case, I additionally had to change the `GIT_STRATEGY` to `clone` as suggested [in this issue](https://gitlab.com/gitlab-org/gitlab/-/issues/292470).
The resulting CI script looks like this:

```yaml
build_job:
  stage: build_px4
  variables:
    ROS_DISTRO_ARG: ROS_DISTRO=noetic
    # Required to clone customized px4-sitl_gazebo-classic from our private GitLab
    GIT_STRATEGY: clone
    GIT_SUBMODULE_STRATEGY: recursive
    # Fetch the entire git history so the px_update_git_header.py script can fetch the tag
    GIT_DEPTH: "0"
    GIT_SUBMODULE_DEPTH: "0"
  script:
    - /kaniko/executor
      --build-arg "CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE"
      --build-arg $ROS_DISTRO_ARG
      --build-arg "CI_COMMIT_REF_NAME=$CI_COMMIT_REF_NAME"
      --cache
      --context $CI_PROJECT_DIR
      --dockerfile $CI_PROJECT_DIR/docker/px4/Dockerfile
      --destination $CI_REGISTRY_IMAGE/$CI_COMMIT_REF_NAME:noetic-px4
```
One drawback of these settings is that cloning takes longer.
In this case, the time required for cloning is negligible compared to the other build steps.

P.S.: Yes, this is a project that will end with the ROS1 end of life.