#!/bin/bash

_optional_command() {
    local description=$1
    shift
    local command=("$@")

    while true; do
        echo -n "🔍 Execute '$description'? (Y/n): "
        read response
        response=${response:-Y}
        if [[ "$response" == "Y" ]]; then
            ${command[@]}
            local cmd_status=$?
            if [ $cmd_status -ne 0 ]; then
                echo "❌ The command '$description' failed with status code $cmd_status."
                continue
            fi
            echo "✅ The command '$description' executed successfully."
            return $cmd_status
        elif [[ "$response" == "n" ]]; then
            echo "⏭️ Skipping the command '$description'."
            return 0
        else
            echo "⚠️ Invalid response. Please enter 'Y' or 'n'."
        fi
        sleep 1000
    done
}

_warn_overwrite() {
    local file=$1

    if [ ! -f "$file" ]; then
        return 0
    fi

    while true; do
        echo -n "⚠️ The file '$file' already exists. Overwrite? (Y/n): "
        read response
        response=${response:-Y}
        if [[ "$response" == "Y" ]]; then
            return 0
        elif [[ "$response" == "n" ]]; then
            return 1
        else
            echo "⚠️ Invalid response. Please enter 'Y' or 'n'."
        fi
    done
}
