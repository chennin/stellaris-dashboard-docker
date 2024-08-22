ARG PY_VER="3.10"
ARG OS_VER="bullseye"
FROM python:${PY_VER}-slim-${OS_VER} AS base
ARG SD_TAG="master"
ARG GIT_SD_USER="eliasdoehne"
ARG GIT_SD_NAME="stellaris-dashboard"

USER root

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get -y --no-install-recommends install \
      dumb-init curl git \
      gcc g++ libc6-dev && \
    apt-get clean && rm -rf /var/lib/apt/* && rm /var/cache/debconf/* && find /var/log -type f -delete
RUN useradd --create-home --shell /bin/bash stellaris

USER stellaris
WORKDIR /home/stellaris
ENV PATH "/home/stellaris/.local/bin:$PATH"

RUN mkdir -p "/home/stellaris/.local/share/Paradox Interactive/Stellaris/save games" "/home/stellaris/.steam/steamapps/common/Stellaris/localisation/english"
RUN if [ "${SD_TAG}" = "master" ]; then \
      curl --no-progress-meter -o sd_version.json "https://api.github.com/repos/$GIT_SD_USER/$GIT_SD_NAME/git/refs/heads/$SD_TAG"; \
    else \
      curl --no-progress-meter -o sd_version.json "https://api.github.com/repos/$GIT_SD_USER/$GIT_SD_NAME/git/refs/tags/$SD_TAG"; \
    fi
RUN git clone -b "$SD_TAG" --single-branch --depth 1 -c advice.detachedHead=false https://github.com/$GIT_SD_USER/$GIT_SD_NAME.git
RUN pip install --no-cache-dir --upgrade pip && pip --no-cache-dir install wheel setuptools && \
    pip --no-cache-dir install Cython patchelf && \
    pip --no-cache-dir install -r stellaris-dashboard/requirements.txt -r stellaris-dashboard/dev-requirements.txt

COPY run.sh /run.sh
COPY build-ext.sh /build-ext.sh

FROM base AS build
RUN /build-ext.sh

FROM base AS final
ARG PY_VER
COPY --from=build --chown=stellaris:stellaris /home/stellaris/.local/lib/python${PY_VER}/site-packages/rust_parser/* /home/stellaris/.local/lib/python${PY_VER}/site-packages/rust_parser/
COPY --from=build --chown=stellaris:stellaris /home/stellaris/.local/lib/python${PY_VER}/site-packages/rust_parser-0.1.0.dist-info/* /home/stellaris/.local/lib/python${PY_VER}/site-packages/rust_parser-0.1.0.dist-info/

WORKDIR /home/stellaris/stellaris-dashboard

EXPOSE 28053

ENTRYPOINT ["dumb-init"]

#CMD ["python", "-m", "stellarisdashboard"]
CMD ["/run.sh"]
