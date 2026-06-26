# aiofranka-circle-demo

A development environment for controlling a Franka FR3 robot with
[aiofranka](https://github.com/Improbable-AI/aiofranka), switchable between
MuJoCo simulation and a real robot.

## Quickstart (simulation)

```bash
# Build the image
podman build -t aiofranka .

# Start the dev container (Xvfb virtual display starts automatically)
podman run -d --name aiofranka-dev \
  --privileged --network=host \
  -v "$PWD":/workspace -w /workspace \
  -e DISPLAY=:99 \
  localhost/aiofranka \
  bash -c "Xvfb :99 -screen 0 1280x720x24 -ac +extension GLX +render -noreset & sleep 0.5 && sleep infinity"

# Run the demo script
podman exec aiofranka-dev python demo.py

# Open an interactive shell
podman exec -it aiofranka-dev bash
```

## Connecting to a real robot

Replace `RobotInterface(None)` with `RobotInterface("<robot-ip>")` in your
script.  The container uses `--network=host` so it can reach the robot
directly.

## Implementation notes

Two fixes are applied to the upstream aiofranka 0.3.0 wheel
(`aiofranka-0.3.0-py3-none-any.whl` in this repo):

1. **MuJoCo 3.x API**: `mj_fullM` signature changed from
   `(model, dst, data.qM)` to `(model, data, dst)`.  The call in `robot.py`
   is rewritten accordingly.

2. **Viewer lifecycle**: `robot.stop()` now calls `viewer.close()` in
   simulation mode so the MuJoCo GLFW viewer is shut down cleanly before
   Python exits (without this the interpreter segfaults during GC).

The `Dockerfile` installs Xvfb and the X11/Mesa libraries that MuJoCo's
bundled GLFW needs to open a window in a headless container.
