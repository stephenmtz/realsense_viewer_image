FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    curl \
    ca-certificates \
    pkg-config \
    libusb-1.0-0-dev \
    libssl-dev \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libglu1-mesa-dev \
    libglfw3-dev \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    libxrandr-dev \
    libxi-dev \
    libglib2.0-dev \
    libgtk-3-dev \
    mesa-utils \
    gosu \
    udev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/IntelRealSense/librealsense.git /opt/librealsense \
    --branch v2.55.1 --depth 1

RUN cmake -S /opt/librealsense -B /opt/librealsense/build \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_EXAMPLES=true \
    -DBUILD_GRAPHICAL_EXAMPLES=true \
    -DFORCE_RSUSB_BACKEND=true \
    && cmake --build /opt/librealsense/build -j$(nproc) \
    && cmake --install /opt/librealsense/build \
    && ldconfig

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN useradd -ms /bin/bash rsuser

ENTRYPOINT ["/entrypoint.sh"]
CMD ["realsense-viewer"]