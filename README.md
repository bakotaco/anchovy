Introduction
------------

Anchovy is a simple database migration tool. It is completely written in
bourne shell to make it ultraportable and language agnostic. It comes with an
extensive test suite, There is an extensive test suite defined in the tests
directory.

Currently it only works with MySQL databases, but anchovy is easy to extend to
support other databases in the future. Anchovy has been tested on OS X Lion.

Prerequisites
-------------
* Bourne shell (installed in /bin/sh, tested with bash supplied bourne mode)
* Make (tested with GNU make)
* MySQL client (tested with 5.5.14)

Installation
------------
1.  The test suite expects to have a MySQL server running on localhost with a database and user created by issuing the following commands:

        CREATE DATABASE anchovy_test_db;
        GRANT ALL ON anchovy_test_db.* TO 'anchovy_test'@'localhost'IDENTIFIED BY 'm1gr4t3';

2.  To run the test suite and install anchovy run

        DESTDIR=<dir> make

    where ```<dir>``` is replaced with the directory where anchovy should be installed.

Usage
-----
In order to use anchovy in your project 

TODO...

Contributing
------------
