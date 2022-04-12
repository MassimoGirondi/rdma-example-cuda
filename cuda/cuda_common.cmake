# Usage :
# target_link_libraries(yourprogram PUBLIC cuda_common)



message("Setting CUDA common environment")

add_library(cuda_common INTERFACE)

set(RMDA_LIBS -lrdmacm -libverbs)

# TODO: CMake should be able to find it automagically
set(CUDA_ARCHITECTURES "75")
set_property(GLOBAL PROPERTY CUDA_ARCHITECTURES "75")
set_property(GLOBAL PROPERTY CMAKE_CUDA_COMPILER  /usr/local/cuda/bin/nvcc)
set(CMAKE_CUDA_COMPILER  /usr/local/cuda/bin/nvcc)
set_target_properties(cuda_common
        PROPERTIES
        CMAKE_CUDA_COMPILER /usr/local/cuda/bin/nvcc 
        CUDA_PATH /usr/local/cuda
        POSITION_INDEPENDENT_CODE ON
        CMAKE_CXX_STANDARD 17
        CUDA_ARCHITECTURES "75"
        CUDA_SEPARABLE_COMPILATION ON
        CUDA_RESOLVE_DEVICE_SYMBOLS ON
        #CMAKE_server_CREATE_STATIC_LIBRARY ON
        CUDA_VERBOSE_BUILD ON
            COMPILE_FLAGS "-Wno-type-limits"
            SKIP_BUILD_RPATH TRUE
            BUILD_WITH_INSTALL_RPATH TRUE
            INSTALL_RPATH_USE_LINK_PATH FALSE
            INSTALL_RPATH ""
        )

find_package(CUDAToolkit)
enable_language(CUDA)


set(cuda_flags "-Xcudafe=--display_error_number")

target_include_directories(cuda_common INTERFACE 
        )

target_compile_features(cuda_common INTERFACE cxx_std_17)
target_link_libraries(
        cuda_common
        INTERFACE ${CUDA_LIBRARIES}
        INTERFACE  cuda cudart
        INTERFACE rdmacm ibverbs
        INTERFACE nvToolsExt
  )

message("-->   CUDA INCLUDE DIRECTORIES: ${CUDAToolkit_INCLUDE_DIRS}")
message("-->   CUDA VERSION ${CUDAToolkit_VERSION}")


