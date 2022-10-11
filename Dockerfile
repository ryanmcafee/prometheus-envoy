FROM golang:1.19-alpine AS build
WORKDIR /app
COPY go.mod ./
COPY go.sum ./
RUN go mod download
COPY . ./
RUN go build -o /compiled/prometheus-exporter ./

FROM alpine:3
WORKDIR /
COPY --from=build /compiled/prometheus-exporter /prometheus-envoy
EXPOSE 2112
ENTRYPOINT ["/prometheus-envoy"]
