---
layout: post
title: "Writing-an-API-with-Tornado"
description: "Writing-an-API-with-Tornado"
category: "tornado"
tags: [tornado]
---
 Tornado is a Python web framework and asynchronous networking library originally developed at FriendFeed. By using non-blocking network I/O, Tornado can scale to tens of thousands of open connections. Some of the APIs we provide take some time to process so we take advantage of Tornado’s scalability and non-blocking I/O to support these longer user connections.

** Overview:**

with Python (2.7) and pip;

**Top-level directory**

    setup.py -> python setup.py develop -> installs the package and requirements that are necessary to run the server.
    req.txt -> dependencies list
    setup.cfg -> nosetests -> runs the test suite for the package
    yourapp -> package for the server

The project [Boilerplate code for a Tornado API Server https://indico.io](https://github.com/sihrc/tornado-boilerplate) building Python + Tornado + Motor (MongoDb)


**Modules:**

Let’s go over the modules that are in the package.

    db -> database helper functions for each individual database table / collection
    error -> custom errors for error handling and sending appropriate server responses
    routes -> handlers that specify routing logic for the server. most of the server logic is here.
    tests -> unittest tests
    utils -> utilities that make lives easier (more later)

**Running the Server:**

To run the server, run the following:

    $ python -m yourapp.server

Additional configs are in config.py — right now, it simply has a specified port and MongoDB URI.

More in [**tornado-boilerplate**](https://github.com/BeginMan/tornado-boilerplate).

ref:[Writing an API with Tornado](https://indico.io/blog/writing-an-api-with-tornado/)

整理完善中~
