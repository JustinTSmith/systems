# Injection defense: two-stage scan, then the test suite.
# Render with: vhs demo.tape

Output demo.gif

Set Shell "bash"
Set FontSize 18
Set Width 1300
Set Height 800
Set Padding 20
Set TypingSpeed 25ms
Set Theme "Catppuccin Mocha"

Hide
Type "cd ~/Workspace/projects/showcase/demos/01-injection-defense" Enter
Type "clear" Enter
Show

# Stage one: regex. Cheap, runs on everything.
Type "node scan.js"
Sleep 500ms
Enter
Sleep 4s

Type "clear" Enter
Sleep 500ms

# The suite. 51 tests, including a named regression per fixed bug.
Hide
Type "cd ~/.openclaw/workspace/security/injection-defense" Enter
Type "clear" Enter
Show

Type "node test/injection-defense.test.js 2>&1 | tail -20"
Sleep 500ms
Enter
Sleep 8s
Sleep 3s
