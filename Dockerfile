FROM golang:alpine3.13 AS builder
RUN apk add --no-cache git
WORKDIR $GOPATH/src/
RUN git clone https://github.com/Lucretius/vault_raft_snapshot_agent.git .
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/bin/vault_raft_snapshot_agent main.go

FROM alpine:3.13.0
RUN apk add --no-cache bash
COPY --from=builder /go/bin/vault_raft_snapshot_agent /go/bin/vault_raft_snapshot_agent
COPY loop.sh /loop.sh
ENTRYPOINT [ "/bin/bash", "/loop.sh" ]
