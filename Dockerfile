FROM golang:1-alpine3.19 as builder

RUN apk update
RUN apk add git

WORKDIR /src

COPY . .

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux go build -o app

FROM alpine:3.19.1

WORKDIR /app

COPY --from=builder /src/app ./
COPY --from=builder /src/tracker.db ./
RUN chmod +x app

CMD ["./app"]