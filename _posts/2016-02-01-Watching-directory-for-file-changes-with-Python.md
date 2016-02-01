---
layout: post
title:  Watching directory for file changes with Python
date:   2016-02-01 13:38:36
categories: Python
tags: Python Libary
---

First create the monitoring script, it will run daemonized and will observe any changes to the given directory. In that script 3 modules/classes will be used

1. time from Python will be used to sleep the main loop
1. watchdog.observers.Observer is the class that will watch for any change, and then dispatch the event to specified the handler.
1. watchdog.events.PatterMatchingHandler is the class that will take the event dispatched by the observer and perform some action

PatternMatchingEventHandler inherits from FileSystemEventHandler and exposes some usefull methods:

Events are: modified, created, deleted, moved

1. on_any_event: if defined, will be executed for any event
1. on_created: Executed when a file or a directory is created
1. on_modified: Executed when a file is modified or a directory renamed
1. on_moved: Executed when a file or directory is moved
1. on_deleted: Executed when a file or directory is deleted.

Each one of those methods receives the event object as first parameter, and the event object has 3 attributes.

   event_type
   'modified' | 'created' | 'moved' | 'deleted'
   is_directory
   True | False
   src_path
   path/to/observed/file


[参考原文](http://brunorocha.org/python/watching-a-directory-for-file-changes-with-python.html)

http://pythonhosted.org/watchdog/_modules/watchdog/events.html#FileSystemEventHandler.on_deleted
