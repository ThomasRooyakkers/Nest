# Build from the project root with:
# docker build -f nest_server/Dockerfile .
# For production, deploy/deploy.sh first builds the web app into
# nest_server/web/app, which the image serves.

# Build stage
FROM dart:3.13.7 AS build

# Create a minimal workspace that preserves locked server dependency versions.
WORKDIR /app
COPY pubspec.lock .
COPY nest_server nest_server
RUN printf '%s\n' \
  'name: _' \
  'environment:' \
  '  sdk: ^3.12.2' \
  'workspace:' \
  '  - nest_server' \
  > pubspec.yaml
RUN dart pub get

# Compile the server executable.
WORKDIR /app/nest_server
RUN dart build cli --target bin/main.dart --output build
RUN mv build/bundle/bin/main build/bundle/bin/server

# Add a fallback for the copy of possibly missing directories.
RUN mkdir -p config web migrations

# Final stage
FROM alpine:latest
WORKDIR /app

# Environment variables
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy runtime dependencies
COPY --from=build /runtime/ /

# Copy compiled server executable and native libraries
COPY --from=build /app/nest_server/build/bundle/ ./

# Copy configuration files and resources
COPY --from=build /app/nest_server/config/ config/
COPY --from=build /app/nest_server/web/ web/
COPY --from=build /app/nest_server/migrations/ migrations/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/nest_server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Define the entrypoint command. Migrations are applied at start.
ENTRYPOINT ./bin/server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role --apply-migrations
