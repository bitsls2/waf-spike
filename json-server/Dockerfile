FROM node:23-alpine3.21
# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Add TARGETPLATFORM argument
#ARG TARGETPLATFORM

# Install json-server
RUN npm install -g json-server

# Switch to non-root user
USER appuser

EXPOSE 80

# Start json-server
CMD ["json-server", "--host", "0.0.0.0", "--port", "80", "/app/db.json"]