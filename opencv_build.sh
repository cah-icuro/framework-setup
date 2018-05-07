
# Install some dependencies, these lines are from BVLC
sudo apt-get install --assume-yes build-essential cmake git
sudo apt-get install --assume-yes pkg-config unzip ffmpeg qtbase5-dev python-dev python3-dev python-numpy python3-numpy
sudo apt-get install --assume-yes libopencv-dev libgtk-3-dev libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev
sudo apt-get install --assume-yes libavcodec-dev libavformat-dev libswscale-dev libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
sudo apt-get install --assume-yes libv4l-dev libtbb-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev
sudo apt-get install --assume-yes libvorbis-dev libxvidcore-dev v4l-utils vtk6
sudo apt-get install --assume-yes liblapacke-dev libopenblas-dev libgdal-dev checkinstall

# Download opencv and opencv_contrib
mkdir InstallOpenCV
cd InstallOpenCV
# Master branch caused a lot of compatibility issues, so switched to 3.4
# git clone https://github.com/opencv/opencv.git
# git clone https://github.com/opencv/opencv_contrib.git
git clone https://github.com/opencv/opencv/tree/3.4
git clone https://github.com/opencv/opencv_contrib/tree/3.4

# Set up build directory
cd opencv
mkdir build
cd build

# Build
cmake \
-D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D WITH_CUDA=ON \
-D ENABLE_FAST_MATH=1 \
-D CUDA_FAST_MATH=1 \
-D WITH_CUBLAS=1 \
-D INSTALL_C_EXAMPLES=OFF \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D OPENCV_EXTRA_MODULES_PATH=/home/artemis/InstallOpenCV/opencv_contrib/modules \
-D BUILD_SHARED_LIBS=ON \
-D WITH_GTK=ON \
-D BUILD_EXAMPLES=ON ..

make -j $(($(nproc) + 1))

# Install
sudo make install

# If you need to uninstall later, do
# sudo make uninstall
# then clean up the dead links in: /usr/local/lib
