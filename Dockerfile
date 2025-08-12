FROM alpine:3.10


# Install HTTP client and JSON parser
RUN apk update && apk add --no-cache curl jq


# Copy and set entrypoint script permissions
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]


# GitHub Actions passes inputs from action.yml as arguments to your Docker container.

# These show up in your entrypoint.sh as $1, $2, etc.

# You don’t need to define CMD in the Dockerfile — GitHub handles passing the args.

