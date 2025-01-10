while true; do
    read -p "Enter commands:" command
    if [ "$command" = "#" ]; then
        break
    fi
    commands+=("$command")
done

last_idx=$((${#commands[@]} - 1))
for i in "${!commands[@]}"; do
    eval "${commands[$i]}"
    if [ $i -lt $last_idx ]; then
        read -p "continue?" continue
    fi
done