# GridStatusReadyCheck

Adds ready check status to Grid

# Why?

When using Grid instead of the standard UI or other unit frames, Grid won't show a ready check. This can be annoying for party or raid leaders because of missing details information.

# What?

Whenever a ready check starts, this addon for Grid adds the current status to the Grid unit frames.

# How?

- [ ] Open the configuration menu of Grid with the command
  ```
  /grid config
  ```
- [ ] If you want to display an icon, then navigate to the submenu "Grid, Frames, Icon" (german: "Grid, Rahmen, Symbol im Zentrum") and activate "ReadyCheck".
- [ ] If you want to display a short text, then navigate to "Grid, Frames, Text" and activate "ReadyCheck".

The last ready check result will be visible until the next ready check of the combat starts.
