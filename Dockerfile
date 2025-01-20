# Build frontend dist.
FROM node:20-alpine AS frontend
WORKDIR /frontend-build

COPY . .

WORKDIR /frontend-build/web

RUN corepack enable && pnpm i --frozen-lockfile

RUN pnpm build

# Build backend exec file.
FROM golang:1.23-alpine AS backend
WORKDIR /backend-build

COPY . .
COPY --from=frontend /frontend-build/web/dist /backend-build/server/router/frontend/dist

RUN CGO_ENABLED=0 go build -o memos ./bin/memos/main.go

# Make workspace with above generated files.
FROM alpine:latest AS monolithic
WORKDIR /usr/local/memos

RUN apk add --no-cache tzdata curl busybox-suid
ENV TZ="Asia/Kolkata"

COPY --from=backend /backend-build/memos /usr/local/memos/
COPY entrypoint.sh /usr/local/memos/

# Set up cron job
RUN echo "*/2 * * * * curl -s https://uninotes-stable.onrender.com > /dev/null 2>&1" > /etc/crontabs/root

# Ensure cron runs in the background
RUN mkdir -p /var/spool/cron/crontabs
RUN chmod 0644 /etc/crontabs/root

EXPOSE 5230

# Directory to store the data, which can be referenced as the mounting point.
RUN mkdir -p /var/opt/memos
VOLUME /var/opt/memos

ENV MEMOS_MODE="prod"
ENV MEMOS_PORT="5230"

# Start cron and the main app
CMD ["/bin/sh", "-c", "crond && ./entrypoint.sh ./memos"]