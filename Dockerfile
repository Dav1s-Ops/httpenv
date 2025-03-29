FROM golang:alpine AS builder
COPY httpenv.go /go
RUN go build httpenv.go

FROM alpine:3.19
RUN addgroup -g 1000 httpenv \
    && adduser -u 1000 -G httpenv -D httpenv
COPY --from=builder --chown=httpenv:httpenv /go/httpenv /httpenv
EXPOSE 8888
USER httpenv
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:8888/health || exit 1
CMD ["/httpenv"]