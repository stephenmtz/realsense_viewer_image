# realsense-viewer

> Containerized Intel RealSense Viewer — no SDK installation required on the host.

Built from source using **librealsense v2.55.1** with the RSUSB backend, X11 forwarding, and automatic udev rule provisioning on first run.


## Requirements

- Docker
- Linux host with X11
- Intel RealSense camera (D400 series) on a **USB 3.x port**
- `xhost` available on the host


## Build

```bash
docker build -t realsense-viewer .
```

> First build takes ~10 minutes — librealsense is compiled from source inside the image.


## Run

```bash
xhost +local:docker

docker run --rm -it \
  --privileged \
  --network host \
  --cpus="4" \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /dev:/dev \
  -v /etc/udev/rules.d:/etc/udev/rules.d \
  realsense-viewer

xhost -local:docker
```

On first run, the entrypoint automatically installs the RealSense udev rules to `/etc/udev/rules.d/` on the host and reloads udev. **Unplug and replug your camera** after the first run for the rules to take effect.


## How it works

| Flag | Purpose |
|------|---------|
| `--privileged` | Grants access to host USB/device hardware |
| `--network host` | Low-latency host networking |
| `--cpus="4"` | Caps container CPU usage |
| `-e DISPLAY` | Forwards GUI to host monitor via X11 |
| `-v /dev:/dev` | Exposes host device tree to container |
| `-v /etc/udev/rules.d` | Allows entrypoint to install udev rules on host |


## Why build from source?

Intel's official `librealsense.intel.com` apt repository has been intermittently unreachable since late 2025. Building from source is the most reliable installation path and ensures you get a known-good version.


## Troubleshooting

**`cannot open display` error**
```bash
xhost +local:docker
```

**Camera not detected / high CPU usage**

The viewer will spin all cores if the camera isn't detected. Check:

```bash
# Should show Intel device at 5000M (USB3), not 480M (USB2)
lsusb -t | grep -A2 -i intel
```

If it shows `480M`, the camera is on a USB2 connection. Move it to a blue USB3 port and use a USB3 cable (the extra pins inside the connector matter).

**Enumerate devices without launching the viewer**
```bash
docker run --rm --privileged -v /dev:/dev realsense-viewer rs-enumerate-devices
```

**udev rules not applying**

Unplug and replug the camera after the first container run, then verify:
```bash
ls /etc/udev/rules.d/ | grep realsense
```

## Stack

- Ubuntu 22.04
- [librealsense v2.55.1](https://github.com/IntelRealSense/librealsense/releases/tag/v2.55.1)
- RSUSB backend (`FORCE_RSUSB_BACKEND=ON`)
- X11 via `DISPLAY` passthrough
