# syntax=docker/dockerfile:1

##
## Build
##

FROM golang:1.17.3-bullseye AS build

WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN cd cmd/server/

RUN go build -o /bin/proglog

##
## Deploy
##

FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /bin/proglog /bin/proglog

# EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/proglog"]
