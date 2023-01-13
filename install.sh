#!/bin/bash
sudo apt-get install -y libdrm-amdgpu1 libdrm-amdgpu1-dbgsym libdrm-dev libdrm-exynos1 libdrm-exynos1-dbgsym libdrm-freedreno1 libdrm-freedreno1-dbgsym libdrm-nouveau2 libdrm-nouveau2-dbgsym libdrm-omap1 libdrm-omap1-dbgsym libdrm-radeon1 libdrm-radeon1-dbgsym libdrm-tegra0 libdrm-tegra0-dbgsym libdrm2 libdrm2-dbgsym
sudo apt-get install -y libglu1-mesa libglu1-mesa-dev glusterfs-common libglu1-mesa libglu1-mesa-dev libglui-dev libglui2c2
sudo apt-get install -y libglu1-mesa libglu1-mesa-dev mesa-utils mesa-utils-extra xorg-dev libgtk-3-dev libusb-1.0-0-dev
cd ~
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/ 
sudo udevadm control --reload-rules && udevadm trigger
echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
source ~/.bashrc
cd ~
git clone --depth=1 -b v3.5.1 https://github.com/google/protobuf.git
cd protobuf
./autogen.sh
./configure
make -j1
sudo make install
cd python
export LD_LIBRARY_PATH=../src/.libs
python3 setup.py build --cpp_implementation 
python3 setup.py test --cpp_implementation
sudo python3 setup.py install --cpp_implementation
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION_VERSION=3
sudo ldconfig
cd ~
wget https://github.com/PINTO0309/TBBonARMv7/raw/master/libtbb-dev_2018U2_armhf.deb
sudo dpkg -i ~/libtbb-dev_2018U2_armhf.deb
sudo ldconfig
rm libtbb-dev_2018U2_armhf.deb
wget https://github.com/mt08xx/files/raw/master/opencv-rpi/libopencv3_3.4.3-20180907.1_armhf.deb
sudo apt install -y ./libopencv3_3.4.3-20180907.1_armhf.deb
sudo ldconfig
cd ~/librealsense
mkdir  build  && cd build
cmake .. -DBUILD_EXAMPLES=true -DCMAKE_BUILD_TYPE=Release -DFORCE_LIBUVC=true
make -j1
sudo make install
cd ~/librealsense/build
cmake .. -DBUILD_PYTHON_BINDINGS=bool:true -DPYTHON_EXECUTABLE=$(which python3)
make -j1
sudo make install
echo "export PYTHONPATH=$PYTHONPATH:/usr/local/lib" >> ~/.bashrc
source ~/.bashrc
