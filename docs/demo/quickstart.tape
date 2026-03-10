Output docs/demo/quickstart.gif
Set Width 1100
Set Height 650
Set FontSize 26
Set Margin 24
Set Padding 20
Set Theme "Dracula"

Type "cd neofetch-security-notes"
Enter
Sleep 900ms

Type "echo 'Example system output before sharing:'"
Enter
Sleep 900ms

Type "printf 'Host: demo-machine\nPath: demo-path\nIP: demo-ip\n'"
Enter
Sleep 1600ms

Type "echo ''"
Enter
Sleep 600ms

Type "echo 'Sanitizing output...'"
Enter
Sleep 900ms

Type "printf 'Host: demo-machine\nPath: demo-path\nIP: demo-ip\n' | ./tools/sanitize-neofetch.sh --strict"
Enter
Sleep 2400ms

Type "echo ''"
Enter
Sleep 600ms

Type "echo 'Optional disclosure scan:'"
Enter
Sleep 900ms

Type "printf 'Host: demo-machine\nPath: demo-path\nIP: demo-ip\n' | ./tools/sanitize-neofetch.sh --strict | ./tools/redflag-scan.sh"
Enter
Sleep 2600ms

Type "echo ''"
Enter
Sleep 600ms

Type "echo 'Safe output ready for sharing.'"
Enter
Sleep 1800ms
