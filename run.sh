#! /bin/sh

xhost +
docker run --gpus all --rm -it --ipc=host --net=host --privileged \
    --env="DISPLAY" \
    --volume="/etc/localtime:/etc/localtime:ro" \
    --volume="/home/pqdung/Unitree_G1/unitree_ros:/root/catkin_ws/src/unitree_ros" \
    vin-motion/unitree_ros:latest 
xhost -