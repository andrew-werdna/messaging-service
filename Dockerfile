FROM golang:1.25.3-alpine3.22 AS builder

RUN apk add --no-cache curl ca-certificates

WORKDIR /app

COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod \
    && go mod download

COPY . .

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    && go build -o messaging-service main.go

FROM alpine:3.22

COPY --from=builder /app/messaging-service /usr/local/bin/messaging-service

CMD ["/usr/local/bin/messaging-service"]