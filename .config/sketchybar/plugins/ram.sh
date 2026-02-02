#!/bin/bash

PAGESIZE=$(sysctl -n hw.pagesize)
TOTAL_RAM=$(sysctl -n hw.memsize)

# Memory capacity (Total RAM) in macOS is always measured in powers of 2 (1024^3)
# Activity Monitor's "Memory Used" is App Memory (Anonymous + Purgeable) + Wired + Compressed
RAM_INFO=$(vm_stat | awk -v ps=$PAGESIZE '
  { gsub(/\./, "", $(NF)); }
  /Anonymous pages/ {anon=$(NF)}
  /Pages wired down/ {wired=$(NF)}
  /Pages occupied by compressor/ {comp=$(NF)}
  /Pages purgeable/ {purge=$(NF)}
  END {
    used = (anon + wired + comp + purge) * ps / 1073741824;
    printf "%.1f", used
  }
')

TOTAL_GB=$(awk -v t=$TOTAL_RAM 'BEGIN {printf "%.0f", t/1073741824}')

sketchybar --set $NAME label="${RAM_INFO}/${TOTAL_GB}GB"
