# STEP 1 build executable binary
FROM golang:alpine as builder

WORKDIR $GOPATH/src/github.com/asciimoo/filtron

# add gcc musl-dev for "go test"
RUN apk add --no-cache git

COPY . .
RUN go get -d -v
RUN gofmt -l ./
# RUN go vet -v ./...
# RUN go test -v ./...
RUN go build .

# STEP 2 build the image including only the binary
FROM alpine:latest

EXPOSE 3000

RUN apk --no-cache add ca-certificates \
 && adduser -D -h /usr/local/filtron -s /bin/false filtron filtron

COPY rules.json /etc/filtron/rules.json
COPY --from=builder /go/src/github.com/asciimoo/filtron/filtron /usr/local/filtron/filtron

USER filtron

ENTRYPOINT ["/usr/local/filtron/filtron", "--rules", "/etc/filtron/rules.json"]
