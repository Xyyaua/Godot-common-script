# Logger
Used for `Godot 4.x`

## Usage
1. Put the logger in your project
2. Enable this logger from Project Setting -> AutoLoad -> add Logger and enable Global Variable
3. Add `const SCR_NAME = (you script name)` in script
4. Use `Logger.output(SCR_NAME, text, level)` to output log

Final output:
```text
2023-09-01 00:00:00|INFO|main.gd|This a info
```

Level of the log:
```text
0 = debug
1 = info
2 = warring
3 = error
```

## Change Log
- 1.0
    - First logger
- 1.1
    - Add output file
- 1.2
    - Complete output file
- 1.3
    - Add const type
    - Add output file path
- 1.4
    - Add detect enable status
- 1.4.1
    - Change UTC const name
- 1.4.2
    - Add type limit
- 1.4.3
    - Change `SRC_NAME` to `SCR_NAME`
- 1.5
    - Add log level enable status