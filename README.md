# `sgit`, A Simple Git Configuration Tool

This project aims to replace my current bash script for configuring git on a new
machine. It simply calls the git executable with the right options.

The plan is to allow it to be interactive, for anyone to be able to input their
usernames and email addresses, as well as a few key configuration options that I
personally use.

This tool is heavily opinionated; it is supposed to be my first foray into using
Zig to build projects. As such, it will use my configuration, and isn't planned
to encompass much more than my personal usage of Git.
