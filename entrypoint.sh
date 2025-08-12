#!/bin/sh

# =========================
# INPUT VARIABLES
# =========================

# GitHub token used to authenticate with the GitHub API (passed as first argument)
GITHUB_TOKEN=$1

# Giphy API key to fetch a random GIF (passed as second argument)
GIPHY_API_KEY=$2


# =========================
# GET PR NUMBER
# =========================

# The event payload file contains all information about the current GitHub event (e.g., PR open)
# We use jq to extract the pull request number from the event JSON file
pr_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")

# Log the PR number for reference
echo "PR Number: $pr_number"


# =========================
# FETCH A RANDOM 'THANK YOU' GIF FROM GIPHY
# =========================

# Use curl to send a GET request to the Giphy API for a random 'thank you' GIF
# -s means silent mode (no progress bar)
giphy_response=$(curl -s \
  "https://api.giphy.com/v1/gifs/random?api_key=$GIPHY_API_KEY&tag=thank%20you&rating=g")

# Log the full response JSON (useful for debugging)
echo "Giphy Response: $giphy_response"


# =========================
# EXTRACT GIF URL
# =========================

# Use jq to parse the JSON and extract the downsized version of the GIF URL
gif_url=$(echo "$giphy_response" | jq --raw-output .data.images.downsized.url)

# Log the final GIF URL to be used in the comment
echo "GIF URL: $gif_url"


# =========================
# POST COMMENT TO GITHUB PR
# =========================

# Use curl to send a POST request to GitHub's API to add a comment to the pull request
response=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \                  # Authentication header
  -H "Accept: application/vnd.github.v3+json" \              # GitHub API version header
  -d "{\"body\": \"Thank you for your contribution! 🎉\n![GIF]($gif_url)\"}" \  # JSON payload with the message and embedded GIF
  "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$pr_number/comments")  # Endpoint to post a comment to a specific PR


# =========================
# OUTPUT THE COMMENT URL
# =========================

# Extract the HTML URL of the comment from the API response
comment_url=$(echo "$response" | jq --raw-output .html_url)

# Output the comment URL for reference
echo "Comment posted: $comment_url"
