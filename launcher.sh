#!/bin/bash
# padre.sh - Launches child process

echo "Script with PID $$, initializing launcher..."
./gamesterminal.py &
wait
