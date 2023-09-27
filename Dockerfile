FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download
COPY internal ./internal
COPY cmd ./cmd

RUN CGO_ENABLED=0 go build -o /app/api-forward-auth ./cmd/api-forward-auth

FROM alpine:3.18

WORKDIR /app
COPY --from=builder /app/api-forward-auth ./
ENTRYPOINT ["/app/api-forward-auth"]
