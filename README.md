# aiofranka-circle-demo

This simple demo shows how to move the end effector of a Franka FR3 robot in a circle in the YZ plane.
The `Dockerfile` and `docker-compose.yaml` make a container image for testing on the robot or in simulation.
The dependencies are `podman` and `podman-compose`, which can be installed in Ubuntu with `apt`.

```
sudo apt update
sudo apt install -y podman podman-compose
```

The test can then be run on the container with the commands below.

```
podman-compose run --rm dev bash
python circle_demo.py
```
