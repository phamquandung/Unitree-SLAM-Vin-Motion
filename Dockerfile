FROM osrf/ros:noetic-desktop-full

ENV DEBIAN_FRONTEND noninteractive
ENV CORE 8

RUN apt update && apt upgrade -y

RUN apt install -y \
    build-essential  \
    cmake \
    pkg-config  \
    htop  \
    gedit  \
    wget \
    git \
    unzip  \
    curl \
    vim \
    software-properties-common \
    libboost-all-dev \
    net-tools \
    iputils-ping \
    libeigen3-dev \
    liblcm-dev 

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends --quiet \
           python3 \
           python3-pip \
    && apt-get clean all
   
RUN pip install --no-cache --upgrade pip setuptools
   

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
&& wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add - \
&& apt-get update \
&& apt-get install libgazebo11-dev libignition-common3-dev libignition-math-dev -y

#ROS dependency
RUN apt install -y ros-noetic-controller-manager \
                ros-noetic-ros-control \ 
                ros-noetic-ros-controllers \
                ros-noetic-joint-state-controller \
                ros-noetic-effort-controllers \
                ros-noetic-velocity-controllers \
                ros-noetic-position-controllers \
                ros-noetic-robot-controllers \
                ros-noetic-robot-state-publisher \
                ros-noetic-gazebo-ros-pkgs \
                ros-noetic-gazebo-ros-control

# #qpOASES
# WORKDIR /root/
# RUN git clone https://github.com/coin-or/qpOASES.git
# WORKDIR /root/qpOASES/build
# RUN cmake .. && make -j${CORE} && make install


#ROS workspace
WORKDIR /root/catkin_ws/src 
# RUN git clone https://github.com/DRCL-USC/Hector_Simulation.git
# WORKDIR /root/catkin_ws
# RUN . /opt/ros/noetic/setup.sh && \
#     catkin_make
# RUN echo source /root/catkin_ws/devel/setup.bash >> /root/.bashrc

RUN . /opt/ros/noetic/setup.sh
RUN rm -rf /var/lib/apt/lists/*
RUN echo source /opt/ros/noetic/setup.bash >> /root/.bashrc
RUN echo source /usr/share/gazebo-11/setup.sh >> /root/.bashrc


# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics


ENTRYPOINT [ "/bin/bash" ]