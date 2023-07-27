#!/bin/bash -e

# Change to the apps directory
cd apps

# Convert the value string to an array
IFS=',' read -ra value_array <<< "$value"
export APP_VERSION=1.0
for app in *; do
    for v in "${value_array[@]}"; do
        if [[ "$v" == *"$app"* ]]; then
            echo "Building using $v"
            # Clean the value by removing unwanted characters like [ ] "
            cleaned_v=$(echo "$v" | tr -d '[]\"')
            TARGET="$cleaned_v:$APP_VERSION"
            echo "Target: $TARGET"
            docker build -t "pipeline-image" "$app"
            docker tag "pipeline-image" "$TARGET"
            docker push "$TARGET"
            break
        fi
    done
done