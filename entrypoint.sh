#!/bin/sh

# Github token and giphy api key value will passed through actions
GITHUB_TOKEN=$1
GIPHY_API_KEY=$2


# Get PR number
pr_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
echo "PR Number: $pr_number"


# Fetch GIF from Giphy
giphy_response=$(curl -s \
  "https://api.giphy.com/v1/gifs/random?api_key=$GIPHY_API_KEY&tag=thank%20you&rating=g")
echo "Giphy Response: $giphy_response"


# Extract GIF URL
gif_url=$(echo "$giphy_response" | jq --raw-output .data.images.downsized.url)
echo "GIF URL: $gif_url"


# Post comment
response=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d "{\"body\": \"Thank you for your contribution! 🎉\n![GIF]($gif_url)\"}" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$pr_number/comments")
echo "Comment posted: $(echo "$response" | jq --raw-output .html_url)"