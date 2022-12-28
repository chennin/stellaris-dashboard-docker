ARG PY_VER="3.10"
ARG OS_VER="3.17"
FROM python:${PY_VER}-alpine${OS_VER}
ARG SD_TAG="master"

USER root

RUN apk update && apk upgrade && \
    apk --no-cache add \
      dumb-init \
      openblas libstdc++ \
      git gcc libc-dev g++ gfortran openblas-dev yaml-dev make && \
    rm -rf /var/cache/apk/*
RUN adduser --disabled-password stellaris

USER stellaris
WORKDIR /home/stellaris
ENV PATH "/home/stellaris/.local/bin:$PATH"
ENV CFLAGS "-O3 -fstack-protector-strong -march=x86-64 -Wl,--strip-all -g0 -DNDEBUG"
ENV CXXFLAGS "$CFLAGS"
ENV LDFLAGS "$CFLAGS"

RUN mkdir -p "/home/stellaris/.local/share/Paradox Interactive/Stellaris/save games" "/home/stellaris/.steam/steamapps/common/Stellaris/localisation/english"
RUN git clone https://github.com/eliasdoehne/stellaris-dashboard.git && \
    git -C stellaris-dashboard -c advice.detachedHead=false checkout "$SD_TAG"
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir wheel setuptools && \
    pip install --no-cache-dir Cython && \
    pip install --no-cache-dir --extra-index-url https://alpine-wheels.github.io/index -r stellaris-dashboard/requirements.txt && \
    pip cache purge

WORKDIR /home/stellaris/stellaris-dashboard
RUN python setup.py build_ext --inplace

USER root
RUN apk del gcc g++ gfortran libc-dev git openblas-dev yaml-dev make
USER stellaris

COPY run.sh /run.sh

EXPOSE 28053

ENTRYPOINT ["dumb-init"]

CMD ["/run.sh"]
