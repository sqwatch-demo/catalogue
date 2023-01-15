FROM golang:1.19-alpine

COPY . /src
WORKDIR /src

#RUN go get -u github.com/FiloSottile/gvt
#RUN gvt restore && \
RUN go get ./... && \
    go mod vendor
RUN go build cmd/cataloguesvc/main.go && \
    mv main /catalogue

FROM alpine:3.17.1

ENV	SERVICE_USER=myuser \
	SERVICE_UID=10001 \
	SERVICE_GROUP=mygroup \
	SERVICE_GID=10001

RUN	addgroup -g ${SERVICE_GID} ${SERVICE_GROUP} && \
	adduser -g "${SERVICE_NAME} user" -D -H -G ${SERVICE_GROUP} -s /sbin/nologin -u ${SERVICE_UID} ${SERVICE_USER}

WORKDIR /
COPY --from=0 /catalogue /catalogue
COPY images/ /images/

RUN	chmod +x /catalogue && \
	chown -R ${SERVICE_USER}:${SERVICE_GROUP} /catalogue /images

USER ${SERVICE_USER}

ARG BUILD_DATE
ARG BUILD_VERSION
ARG COMMIT

LABEL org.label-schema.vendor="Weaveworks" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.version="${BUILD_VERSION}" \
  org.label-schema.name="Socks Shop: Catalogue" \
  org.label-schema.description="REST API for Catalogue service" \
  org.label-schema.url="https://github.com/sqwatch-demo/catalogue" \
  org.label-schema.vcs-url="github.com:sqwatch-demo/catalogue.git" \
  org.label-schema.vcs-ref="${COMMIT}" \
  org.label-schema.schema-version="1.0"

CMD ["/catalogue", "-port=8080"]
EXPOSE 8080
