import asyncio
import numpy as np
from aiofranka import RobotInterface, FrankaController


async def main():
    robot = RobotInterface(None)
    controller = FrankaController(robot)

    await controller.start()
    await controller.move([0, 0, 0.0, -1.57079, 0, 1.57079, -0.7853])

    controller.switch("impedance")
    controller.kp = np.ones(7) * 80.0
    controller.kd = np.ones(7) * 4.0
    controller.set_freq(50)

    for cnt in range(100):
        delta = np.sin(cnt / 50.0 * np.pi) * 0.1
        init = controller.initial_qpos
        await controller.set("q_desired", delta + init)

    await controller.stop()


if __name__ == "__main__":
    asyncio.run(main())
