include .bingo/Variables.mk

IMAGE?=ghcr.io/ryanmcafee/prometheus-envoy
TAG?=$(shell echo "$(shell git rev-parse --abbrev-ref HEAD | tr / -)-$(shell date +%Y-%m-%d)-$(shell git rev-parse --short HEAD)")

all: go-vendor build image

.PHONY: go-vendor
go-vendor: go.mod go.sum
	go mod tidy
	go mod vendor

.PHONY: build
build: go-vendor main.go
	mkdir -p compiled
	go build -o compiled/prometheus-envoy

.PHONY: lint
lint: $(GOLANGCI_LINT)
	$(GOLANGCI_LINT) run -v --enable-all

.PHONY: clean
clean:
	-rm -fr vendor
	-rm -fr compiled

.PHONY: image
image:
	docker build -t $(IMAGE):$(TAG) .