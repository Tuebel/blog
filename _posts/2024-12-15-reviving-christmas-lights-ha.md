---
title: "Reviving my christmas lights in home assistnt"
description: "Home Assistant does not support bluepy anymore which broke the clusterlights integration. A hacky alternative using ESPHome"
layout: post
comments: true
hide: false
tags: [blog, home-automation]
---

A few years ago, my wife and I bought our first Christmas tree in a local hardware store.
Of course, we needed some lights to go along it.
There were those Bluetooth lights which could be controlled via a "Lights" App which gave me those Android Gingerbread vibes.
A quick google in the store and I found that someone reverse engineered the Bluetooth low energy (BLE) protocol for these "[clusterlights](https://github.com/BasVerkooijen/cluster-lights-home-assistant/tree/master)" as a home assistant integration.
This integration stopped working last year and I had to use the old buggy app...

On my quest to revive the integration, I started off fixing the dependencies, upgrading to bluepy3, etc.
However, the home assistant OS heavily relies on Docker containerization, which made it difficult to install system dependencies in addition to the Python requirements.
Since I had a few ESP32 in my closet and knew how to use **ESPHome** a bit, I thought it would be a neat solution which would allow me to place the Christmas tree further away from the Raspberry Pi server.
BLE only works for approximately 10 meters, and that is without any obstacles in the way.
So I hacked up an ESPHome yaml which allows me to send the commands to turn on and off the lights, change the effects, and brightness.

You can find my implementation on [github](https://github.com/Tuebel/Clusterlights-ESPHome).

Merry Christmas!

P.S. Apparently, the author of the home assistant integration has added a branch which uses Bleak for newer home assistant versions now.

