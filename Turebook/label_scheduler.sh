#!/bin/bash

# Desired label information
LABEL_KEY="location"
LABEL_VALUE="dev"

# Custom scheduler information
CUSTOM_SCHEDULER_NAME="Auto-Best-scheduler"

# Pod spec file location
POD_SPEC_FILE="$1"

# Add debug output
echo "LABEL_KEY=$LABEL_KEY, LABEL_VALUE=$LABEL_VALUE, CUSTOM_SCHEDULER_NAME=$CUSTOM_SCHEDULER_NAME, POD_SPEC_FILE=$POD_SPEC_FILE"

# Check for nodes with the desired label
AVAILABLE_NODE=$(kubectl get nodes --show-labels | grep "$LABEL_KEY=$LABEL_VALUE" | awk '{print $1}')
echo "Available Node: $AVAILABLE_NODE"

if [[ -z "$AVAILABLE_NODE" ]]; then
  echo "No nodes found with label '$LABEL_KEY=$LABEL_VALUE'. Falling back to default scheduling..."
else
  # Modify pod spec to use custom scheduler
  sed -i "s/schedulerName:.*/schedulerName: $CUSTOM_SCHEDULER_NAME/" "$POD_SPEC_FILE"
  echo "Modified pod spec to use '$CUSTOM_SCHEDULER_NAME' scheduler for label '$LABEL_KEY=$LABEL_VALUE'."
fi

