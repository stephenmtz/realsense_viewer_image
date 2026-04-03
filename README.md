# 📸 DOCKER CONTAINER FOR REALSENSE VIEWER

A professional, containerized environment for running the Intel RealSense Viewer 
on Linux. This setup allows for full hardware-accelerated visualization 
without installing the SDK on your host system.

---------------------------------------------------------
🛠  1. BUILD THE IMAGE
---------------------------------------------------------
Run this from the root of the repository:

docker build -t realsense-viewer .


---------------------------------------------------------
🚀  2. RUN THE CONTAINER
---------------------------------------------------------
Launch the viewer with full hardware access and X11 forwarding:

docker run --rm -it \
  --privileged \
  --network host \
  --cpus="4" \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /dev:/dev \
  -v /etc/udev/rules.d:/etc/udev/rules.d \
  realsense-viewer


---------------------------------------------------------
⚙️  CONFIGURATION BREAKDOWN
---------------------------------------------------------
--privileged        : Grants access to host hardware (USB/Sensors).
--network host      : Ensures low-latency communication.
--cpus="4"          : Dedicated resources for depth map processing.
-e DISPLAY          : Routes the GUI output to your host monitor.
-v /dev:/dev        : Maps the host's device tree.


---------------------------------------------------------
💡  TROUBLESHOOTING
---------------------------------------------------------
DISPLAY ISSUES:
If you get a "cannot open display" error, run this on your host:
xhost +local:docker

note:
README generated using google gemini since orginal README was kinda boring 

DEVICE RECOGNITION:
Ensure RealSense udev rules are installed on the host workstation.
---------------------------------------------------------
