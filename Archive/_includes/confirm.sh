while true; do
    read -p "Confirm: " result
    if [ "$result" = "confirm" ]; then
        break
    fi
done