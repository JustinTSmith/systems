# Platform health: count the machine, then let it audit itself.
# Render with: vhs demo.tape
#
# READ demos/README.md BEFORE RENDERING. The findings list is generated at
# render time. Review every frame of the output before committing the GIF.

Output demo.gif

Set Shell "bash"
Set FontSize 18
Set Width 1300
Set Height 900
Set Padding 20
Set TypingSpeed 25ms
Set Theme "Catppuccin Mocha"

Hide
Type "cd ~/Workspace/scripts" Enter
Type "clear" Enter
Show

# How many of my own scheduled jobs are loaded right now.
Type "launchctl list | grep -cE 'justinsmith|justinos|openclaw|paperclip|mnemo|gbrain'"
Sleep 500ms
Enter
Sleep 2s

Type "crontab -l | grep -cvE '^[[:space:]]*(#|$)'"
Sleep 500ms
Enter
Sleep 2500ms

Type "clear" Enter
Sleep 500ms

# Nine check modules, run concurrently, in about six seconds.
# The drill beat is deliberately cut: `--drill N` currently reprints the
# same one-line finding, so it lands flat on screen. See README.
Type "python3 -m platform_health.main --dry-run"
Sleep 500ms
Enter
Sleep 12s
