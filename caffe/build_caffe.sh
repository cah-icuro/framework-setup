#!/bin/bash

### Custom Function for formatted output ###
# echo_emph <string> <int>
# Displays <string> in bold and color
# If <int> is given, outputs <int> blank lines before the string
function echo_emph {
  if [ $# == 2 ]; then
    for i in `seq 1 $2`; do
      echo
    done
  fi
  echo -e "\e[1m\e[96m"$1"\e[0m"
}

start=`date +%s`

echo_emph 'Updating system...' 1
sudo apt-get update -y
sudo apt-get upgrade -y

echo_emph 'Installing prerequisite packages...' 5
sudo apt-get install -y build-essential cmake git pkg-config
sudo apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev
sudo apt-get install -y protobuf-compiler libatlas-base-dev libboost-all-dev
sudo apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev

# (Python general)
echo_emph 'Installing pip...' 5
sudo apt-get install -y python-pip

# (Python 2.7 development files)
echo_emph 'Installing python 2 packages...' 5
sudo apt-get install -y python-dev
sudo apt-get install -y python-numpy python-scipy

# (or, Python 3.5 development files)
echo_emph 'Installing python 3 packages...' 5
sudo apt-get install -y python3-dev
sudo apt-get install -y python3-numpy python3-scipy

# (OpenCV 2.4)
# sudo apt-get install -y libopencv-dev
# Manually install latest version of OpenCV instead of this

echo_emph 'Creating InstallCaffe directory...' 5
cd ${HOME}
mkdir InstallCaffe
cd InstallCaffe
echo_emph 'Cloning caffe repository...' 1
git clone 'https://github.com/BVLC/caffe.git'
cd caffe

# cp Makefile.config.example Makefile.config
# At this point, you need to edit Makefile.config
#  - Uncomment USE_CUDNN := 1
#  - Uncomment OPENCV_VERSION := 3
#  - Set architecture: "CUDA_ARCH := -gencode arch=compute_61,code=compute_61"
#  - Uncomment WITH_PYTHON_LAYER := 1
#  - Add hdf5 includes/links:
# INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial
# LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/hdf5/serial

# Open and edit Makefile
#  - Near top, after config file commands, add "CXXFLAGS += -std=c++11"
#  - Change NVCCFLAGS += ... line to :
# 	NVCCFLAGS += -D_FORCE_INLINES -ccbin=$(CXX) -Xcompiler -fPIC $(COMMON_FLAGS)

# Open and edit CMakeLists.txt
# Add the following:
# # ---[ Includes
# set(${CMAKE_CXX_FLAGS} "-D_FORCE_INLINES ${CMAKE_CXX_FLAGS}")
# I added it to line 17 below Caffe version

# Instead of manually performing these changes
# download the files from my github
echo_emph 'Downloading configured "Makefile.config"...' 5
wget 'https://raw.githubusercontent.com/cah-icuro/framework-setup/master/caffe/Makefile.config' -q -O Makefile.config
echo_emph 'Downloading configured "CMakeLists.txt"...' 1
wget 'https://raw.githubusercontent.com/cah-icuro/framework-setup/master/caffe/CMakeLists.txt' -q -O CMakeLists.txt
echo_emph 'Downloading configured "Makefile"...' 1
wget 'https://raw.githubusercontent.com/cah-icuro/framework-setup/master/caffe/Makefile' -q -O Makefile

# Install python requirements
echo_emph 'Installing pythong requirements from "python/requirements.txt"...' 5
for req in $(cat python/requirements.txt); do sudo -H pip install $req --upgrade; done
# this spams me with messages like
# matplotlib 2.2.2 has requirement python-dateutil>=2.1, but you'll have python-dateutil 1.5 which is incompatible.
# Hopefully nothing breaks

echo_emph 'Building caffe!...' 6
# Finally, build it!
make all -j $(($(nproc) + 1))

echo_emph 'Building tests...' 6
make test -j $(($(nproc) + 1))

echo_emph 'Running tests...' 6
make runtest -j $(($(nproc) + 1))

echo_emph 'Installing caffe for python...' 6
# should be finished already, so you can omit this one:
make pycaffe -j $(($(nproc) + 1))

echo_emph 'Final install ("make distribute")...' 6
make distribute -j $(($(nproc) + 1))

# Finished!
end=`date +%s`
runtime=$((end-start))
echo_emph "~ ~ ~ ~ Script Completed ~ ~ ~ ~" 3
echo_emph "Total execution time: ${runtime} second(s)." 1
