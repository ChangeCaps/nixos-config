#/usr/bin/env nu

pw-top -bn 2 | lines | split column -r '\s+' | where column9 != "ERR" | get column9 | into int | math sum
