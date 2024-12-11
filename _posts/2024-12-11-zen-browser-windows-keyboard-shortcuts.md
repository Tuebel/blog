---
title: "Zen Browser Keyboard Shortcuts in Windows"
description: "Windows turns Ctrl+Alt into AltGr which prevents Zen keyboard shortcuts for split views from working. Here is how to work around it."
layout: post
comments: true
hide: false
tags: [blog]
---

Windows turns the default Ctrl+Alt commands into AltGr which prevents Zen keyboard shortcuts for split views. Here is how to work around it.

The easiest solution is to reassign the keyboard shortcuts in Zen.
Go to `settings keyboard shortcuts` and click on shortcuts which use `Ctrl + Alt`.
Retype the same shortcut, which will be replaced by the custom character depending on your keyboard layout.
Confirm the change with `Esc`.
For example, `Ctrl + Alt + q` is turned into `ì` using the [EurKey](https://eurkey.steffen.bruentjen.eu/) layout.
By the way, I very much recommend EurKey to European programmers who like using custom keyboards, which often use an ANSI keyboard.

This method has one apparent **drawback**:
If you switch between keyboard layouts, the key combination will turn into a different character.
For the example above, `Ctrl + Alt + v` is turned into `@` for a German keyboard layout.