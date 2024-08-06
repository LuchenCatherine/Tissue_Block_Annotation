FROM ubuntu:20.04 AS build
ARG DEBIAN_FRONTEND=noninteractive
MAINTAINER lu.chen.3@stonybrook.edu
RUN apt -y update
RUN apt install -y build-essential libssl-dev cmake libboost-all-dev libgmp-dev libmpfr-dev libeigen3-dev libcgal-dev libcpprest-dev
WORKDIR /usr/src/app/build
COPY collision_detection_http_service ..
RUN cmake .. && make

FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y libssl-dev libboost-all-dev libgmp-dev libmpfr-dev libeigen3-dev libcgal-dev libcpprest-dev
# install pip and packages
RUN apt-get -y install python3-pip
RUN pip install requests
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/build/server2 .
COPY model model
COPY server.sh .
# download required data: AS and placement patches
COPY scripts/download_data.py .
RUN python3 download_data.py

ENV PORT 8080
EXPOSE 8080
CMD [ "./server.sh"]
