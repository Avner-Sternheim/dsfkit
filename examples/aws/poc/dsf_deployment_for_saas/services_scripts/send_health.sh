#!/bin/bash

# URL of the localhost service
localhost_url="https://localhost:27906/diagnostics/api/v1/health/agents/latest"

# URL of the remote service
remote_url="https://api.stage.impervaservices.com/datasec-anywhere-monitor/monitor/agents"

# Read the api_id and api_key from the secrets.config file
source /usr/local/bin/secrets.config

# Send request to localhost and capture JSON response
response=$(curl -k --cert $JSONAR_LOCALDIR/ssl/client/admin/cert.pem --key $JSONAR_LOCALDIR/ssl/client/admin/key.pem "$localhost_url")

# Check if the curl request was successful
if [ $? -eq 0 ]; then
  echo "Successfully fetched response from localhost."

  # Send the captured response as the body of the new request
  curl --location "$remote_url" \
    --header "x-api-key: $api_key" \
    --header "x-API-id: $api_id" \
    --header "Content-Type: application/json" \
    --data "$response"
  if [ $? -eq 0 ]; then
    echo "Successfully sent response to the remote service."
  else
    echo "Failed to send response to the remote service."
  fi
else
  echo "Failed to fetch response from localhost."
fi