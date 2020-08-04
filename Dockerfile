ARG PDK_VARIANT=sky130_fd_sc_hd

FROM 0x01be/skywalker-pdk:$PDK_VARIANT as skywalker-pdk

FROM 0x01be/alpine:edge as builder

COPY --from=skywalker-pdk /opt/skywalker-pdk/ /opt/skywalker-pdk/

ENV PDK_ROOT /opt/skywalker-pdk
ENV PDK_VARIANT $PDK_VARIANT

RUN apk add --no-cache --virtual openpdks-build-dependencies \
    git \
    make \
    bash \
    python3 \
    tcl \
    tk

RUN git clone --depth 1 https://github.com/efabless/open_pdks /openpdks

WORKDIR /openpdks

RUN make
RUN make install

