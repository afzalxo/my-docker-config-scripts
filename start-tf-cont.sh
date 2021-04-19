set -e

docker run --gpus all -it --ipc=host tensorflow/tensorflow:latest-gpu bash
