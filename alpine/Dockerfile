ARG PY_VER="3.10"
ARG OS_VER="3.17"
FROM python:${PY_VER}-alpine${OS_VER}
ARG SD_TAG="master"
ARG GIT_SD_USER="eliasdoehne"
ARG GIT_SD_NAME="stellaris-dashboard"

USER root
RUN apk update && apk upgrade && \
    apk --no-cache add \
      dumb-init \
      openblas libstdc++ \
      git gcc libc-dev g++ gfortran openblas-dev yaml-dev make curl && \
    rm -rf /var/cache/apk/*
RUN adduser --disabled-password stellaris

USER stellaris
WORKDIR /home/stellaris
ENV PATH "/home/stellaris/.local/bin:$PATH"
ENV CFLAGS "-O3 -fstack-protector-strong -march=x86-64 -Wl,--strip-all -g0 -DNDEBUG"
ENV CXXFLAGS "$CFLAGS"
ENV LDFLAGS "$CFLAGS"

RUN mkdir -p "/home/stellaris/.local/share/Paradox Interactive/Stellaris/save games" "/home/stellaris/.steam/steamapps/common/Stellaris/localisation/english"
RUN if [ "${SD_TAG}" = "master" ]; then \
      curl --no-progress-meter -o sd_version.json "https://api.github.com/repos/$GIT_SD_USER/$GIT_SD_NAME/git/refs/heads/$SD_TAG"; \
    else \
      curl --no-progress-meter -o sd_version.json "https://api.github.com/repos/$GIT_SD_USER/$GIT_SD_NAME/git/refs/tags/$SD_TAG"; \
    fi
RUN git clone -b "$SD_TAG" -c advice.detachedHead=false https://github.com/$GIT_SD_USER/$GIT_SD_NAME.git
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir wheel setuptools && \
    pip install --no-cache-dir Cython patchelf && \
    pip install --no-cache-dir --extra-index-url https://alpine-wheels.github.io/index -r stellaris-dashboard/requirements.txt -r stellaris-dashboard/dev-requirements.txt

WORKDIR /home/stellaris/stellaris-dashboard

COPY run.sh /run.sh
COPY build-ext.sh /build-ext.sh
RUN /build-ext.sh

USER root
RUN apk del gcc g++ gfortran libc-dev git openblas-dev yaml-dev make

USER stellaris

EXPOSE 28053

ENTRYPOINT ["dumb-init"]

CMD ["/run.sh"]
