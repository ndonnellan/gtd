Getting Things Done on the command line / FreeMind
=======================================
My little project for manipulating some GTD-oriented FreeMind maps using a simple Ruby console application.

Currently it loads my 'next_actions' mindmap by default and only has a few enabled commands:

- "next"
  - Print the next\_actions mindmap to console.
  - With additional arguments (separated by commas), print specific nodes (e.g. "next, today" will print the today node of next\_actions)
- "dump: "
  - Add text node to the "dump" node of next\_actions (multiple entries separated by commas)
  - Example: "dump: pickup strawberries from grocery store"
- "save"
  - Overwrite the current mindmap (which would be next\_actions for the moment)


Future Plans?

- Move nodes around using the console
- Create action nodes from within the current\_projects mindmap
- Add attribute access and modification