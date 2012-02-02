Introduction
------------
This project contains a simple database migration script. All is written in
bourne shell script to make it ultraportable and work in limited environments.
There is an extensive test suite defined in the tests directory.

Currently only MySQL databases are supported, but anchovy is easy to extend
with support for other databases in the future.

Prerequisites
-------------
* Bourne shell (installed in /bin/sh, tested with bash supplied bourne mode)
* Make (tested with GNU make)
* MySQL client

Installation
------------
To run the test suite and install the anchovy script run

    DESTDIR=<dir> make

where <dir> is replaced with the directory you want to install the script.

Usage
-----
In order to use anchovy in your project...

TODO...
