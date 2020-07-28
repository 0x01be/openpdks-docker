FROM 0x01be/skywalker-pdk as skywalker-pdk

FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    git \
    make \
    bash \
    python3 \
    tcl \
    tk

RUN git clone --depth 1 https://github.com/efabless/open_pdks /openpdks

WORKDIR /openpdks

COPY --from=skywalker-pdk /opt/skywalker-pdk/ /opt/skywalker-pdk/
ENV PDK_ROOT /skywalker-pdk

RUN make
RUN make install

