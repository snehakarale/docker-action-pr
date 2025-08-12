FROM alpine:3.10


# Install HTTP client and JSON parser
RUN apk update && apk add --no-cache curl jq


# Copy and set entrypoint script permissions
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]