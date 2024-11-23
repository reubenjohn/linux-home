#!/bin/bash

_optional_command() {
    local description=$1
    shift
    local command=("$@")

    while true; do
        read -p "🔍 Execute '$description'? (y/n) " response
        if [[ "$response" == "y" ]]; then
            "${command[@]}"
            local status=$?
            if [ $status -ne 0 ]; then
                echo "❌ The command '$description' failed with status code $status."
                continue
            fi
            echo "✅ The command '$description' executed successfully."
            return $status
        elif [[ "$response" == "n" ]]; then
            echo "⏭️ Skipping the command '$description'."
            return 0
        else
            echo "⚠️ Invalid response. Please enter 'y' or 'n'."
        fi
    done
}
