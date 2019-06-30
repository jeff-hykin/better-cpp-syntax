cd /opencv-3.2.0/ \
   && mkdir build \
   && cd build \
   && cmake -D CMAKE_BUILD_TYPE=RELEASE \
            -D INSTALL_C_EXAMPLES=OFF \
            -D INSTALL_PYTHON_EXAMPLES=ON \
            -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib-3.2.0/modules \
            -D BUILD_EXAMPLES=OFF \
            -D BUILD_opencv_python2=OFF \
            -D BUILD_NEW_PYTHON_SUPPORT=ON \
            -D CMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)") \
            -D PYTHON_EXECUTABLE=$(which python3) \
            -D WITH_FFMPEG=1 \
            -D WITH_CUDA=0 \
            .. \
    && make -j8 \
    && make install \
    && ldconfig \
    && rm /opencv.zip \
    && rm /opencv_contrib.zip