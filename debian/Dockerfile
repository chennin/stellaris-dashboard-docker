ARG PY_VER="3.10"
ARG OS_VER="bullseye"
FROM python:${PY_VER}-slim-${OS_VER}
ARG SD_TAG="master"

USER root

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get -y --no-install-recommends install \
      gcc libc6-dev curl \
      dumb-init \
      git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN useradd --create-home --shell /bin/bash stellaris

USER stellaris
WORKDIR /home/stellaris
ENV PATH "/home/stellaris/.local/bin:$PATH"

RUN mkdir -p "/home/stellaris/.local/share/Paradox Interactive/Stellaris/save games" "/home/stellaris/.steam/steamapps/common/Stellaris/localisation/english"
RUN git clone https://github.com/eliasdoehne/stellaris-dashboard.git && \
    git -C stellaris-dashboard -c advice.detachedHead=false checkout "$SD_TAG"
RUN pip install --upgrade pip && pip install wheel setuptools && \
    pip install Cython && \
    pip install -r stellaris-dashboard/requirements.txt -r stellaris-dashboard/dev-requirements.txt && \
    pip cache purge

WORKDIR /home/stellaris/stellaris-dashboard

COPY run.sh /run.sh
COPY build-ext.sh /build-ext.sh
RUN /build-ext.sh

EXPOSE 28053

ENTRYPOINT ["dumb-init"]

#CMD ["python", "-m", "stellarisdashboard"]
CMD ["/run.sh"]
