# -----------------------------------------------------------------------------
# The base image for building the k9s binary
FROM --platform=$BUILDPLATFORM golang:1.25-alpine3.21 AS build

ARG BUILDPLATFORM
ARG TARGETOS=linux
ARG TARGETARCH=amd64
ARG VERSION=v0.50.18
ARG GIT_REV=local
ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH
ENV GOTOOLCHAIN=auto
ENV CGO_ENABLED=0

WORKDIR /k9s
COPY go.mod go.sum ./
RUN apk --no-cache add --update ca-certificates curl git make \
  && go mod download
COPY main.go Makefile ./
COPY internal internal
COPY cmd cmd
RUN make build VERSION=${VERSION} GIT_REV=${GIT_REV}

# -----------------------------------------------------------------------------
# Build the final Docker image
FROM alpine:3.23.3
ARG TARGETARCH=amd64
ARG KUBECTL_VERSION="v1.32.2"

COPY --from=build /k9s/execs/k9s /bin/k9s
COPY skins/tpeeg.yaml /tmp/tpeeg.yaml
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN apk --no-cache add --update ca-certificates \
  && apk --no-cache add --update -t deps curl \
  && mkdir -p /root/.kube /root/.config/k9s /root/.local/share/k9s/skins \
  && mv /tmp/tpeeg.yaml /root/.local/share/k9s/skins/tpeeg.yaml \
  && curl -f -L https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl -o /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kubectl /usr/local/bin/entrypoint.sh \
  && apk del --purge deps

ENV K9S_SKIN=tpeeg
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
