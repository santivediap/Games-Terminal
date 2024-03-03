#!/bin/bash
# padre.sh - Lanza el proceso hijo

echo "Script $$, lanzando launcher..."
./gamesterminal.py &
wait
