FROM golang:1.23.4 AS build-stage

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go test -v ./...
RUN CGO_ENABLED=0 GOOS=linux go build -o snippetbox ./cmd/web

FROM golang:1.23.4-alpine AS build-release-stage

WORKDIR /app

COPY --from=build-stage /app/tls tls
COPY --from=build-stage /app/snippetbox snippetbox

EXPOSE 4000

ENTRYPOINT ["/app/snippetbox"] 	
