# Schudelu

The objective of Schudelu is to provide a complete task manager.
This document describes what is a task in a type and operation manner

## Tasks

### During the run

The atomic object of a schedule is a task. Task have the following properties:
- A task contains a description.
- A task a task is started via a trigger event which can come from multiple sources:
  - A date
  - The end of one or more previous tasks
  - A hook
- A task is finished via a trigger event which can come from multiple sources:
  - A date
  - The start of an other task
  - A timer
- A task can be repeated easily
- A task can contains subtasks

### Editing a schedule

A schedule is basically a bucket of tasks.
- Create a task
  + Generate a new task ID
  + Add a description to the task
- Add a sub-task (Exactly as creating or normal task)
- Link a task a trigger to another task
- 



# TODO
- Create a pubsub to register to a calendar list
- Create a pubsub to register to a calendar
