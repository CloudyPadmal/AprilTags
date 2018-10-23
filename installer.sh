#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
NOCOLOR='\033[0m'

echo -e "${GREEN}Welcome to FYP April Tag setup${NOCOLOR}"
echo -e "${YELLOW}Setting up ...${NOCOLOR}"
sudo apt-get update
sudo apt-get upgrade
# Install dev tools
sudo apt-get install build-essential cmake pkg-config
# Install image libraries
sudo apt-get install libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev
# Install video libraries
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install libxvidcore-dev libx264-dev
sudo apt-get install libgtk-3-dev
sudo apt-get install libatlas-base-dev gfortran
# Install python dev environments
sudo apt-get install python2.7-dev python3.5-dev
# Install opencv
cd ~
wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.4.3.zip
unzip opencv.zip
wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.4.3.zip
unzip opencv_contrib.zip
# Setup pip
cd ~
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
# Setup virtual environment
sudo pip install virtualenv virtualenvwrapper
sudo rm -rf ~/get-pip.py ~/.cache/pip
# virtualenv and virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
# Update bashrc
echo -e "\n# virtualenv and virtualenvwrapper" >> ~/.bashrc
echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
source ~/.bashrc
# Create virtual environment
mkvirtualenv fyp -p python2
# Get into the virtual environment
workon fyp
# Install tools
pip install numpy
# Make directory
cd ~/opencv-3.4.3/
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.4.3/modules \
    -D PYTHON_EXECUTABLE=~/.virtualenvs/cv/bin/python \
    -D BUILD_EXAMPLES=ON ..
# Final make
make -j4
make clean
make
sudo make install
sudo ldconfig
# Clean up
cd ~
rm -rf opencv-3.4.3 opencv_contrib-3.4.3 opencv.zip opencv_contrib.zip
# Clone my repo
git clone https://github.com/CloudyPadmal/AprilTags.git
cd AprilTags
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j4
sudo make install
# Run demo
echo -e "${GREEN}Installation complete!${NOCOLOR}"

if (whiptail --title "Opening demo ..." --yesno "Do you want to open a demo now?" 8 46) then
	echo -e "${GREEN}Starting application!${NOCOLOR}"
	workon fyp
	cd python
	python apriltag.py
else
	echo -e "${GREEN}Installation complete!${NOCOLOR}"
fi
