#!/bin/bash

# Replace 'en0' with your actual interface
INTERFACE="en0" 
INTERVAL=1 # seconds

normalize() {
    local in
    read in
    count=$(echo -n $in | wc -c | tr -d " \t\n")
    case $count in
        4 | 5 | 6)
            echo ${in:0:4}
            ;;
        *)
            echo ${in:0:$(($count - 3))}
            ;;
    esac
}

echo "Monitoring network usage on $INTERFACE every $INTERVAL second(s)..."
echo "Time (s) | Download (KB/s) | Upload (KB/s)"

# Get initial bytes
read initial_in initial_out <<< $(netstat -I $INTERFACE -b | awk 'NR==2 {print $7, $10}')

while true; do
    sleep $INTERVAL

    # Get current bytes
    read current_in current_out <<< $(netstat -I $INTERFACE -b | awk 'NR==2 {print $7, $10}')

    # Calculate difference
    diff_in=$((current_in - initial_in))
    diff_out=$((current_out - initial_out))

    # Convert to KB/s
    download_kb_s=$(awk "BEGIN {printf \"%.2f\", $diff_in / 1024 / $INTERVAL}" | normalize)
    upload_kb_s=$(awk "BEGIN {printf \"%.2f\", $diff_out / 1024 / $INTERVAL}" | normalize)

    # Get network status
    connection=$(ifconfig $INTERFACE | awk '/status/{ print $2 }')

    printf "$(date +%T) | $connection \t| $download_kb_s \t| $upload_kb_s\n"
    sketchybar --trigger wifi_update CONNECTION="$connection" DOWNLOAD_KB_S="$download_kb_s" UPLOAD_KB_S="$upload_kb_s"
    sketchybar --trigger wifi_event CON=$connection DW="$download_kb_s" UP="$upload_kb_s"

    # Update initial for next iteration
    initial_in=$current_in
    initial_out=$current_out
done
