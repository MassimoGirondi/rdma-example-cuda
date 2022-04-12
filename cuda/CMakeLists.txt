# Author : Massimo Girondi

cmake_minimum_required (VERSION 3.17)

include(cuda_common.cmake)
project (rdma-example-gpu LANGUAGES CUDA)

set(PROJECT_SOURCE_DIR ${CMAKE_SOURCE_DIR}/src)
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/bin)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR})

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_BUILD_TYPE Release) # or debug if you need to use gdb on it.

add_executable(rdma_server ${PROJECT_SOURCE_DIR}/rdma_common.c ${PROJECT_SOURCE_DIR}/rdma_server.c ${PROJECT_SOURCE_DIR}/rdma_server.cu)
target_compile_definitions(rdma_server PUBLIC CUDA=1)

find_library(IBVERBS_LIBRARY ibverbs)
find_library(RDMACM_LIBRARY rdmacm)

link_libraries(pthread ${IBVERBS_LIBRARY} ${RDMACM_LIBRARY} cuda_common)
target_link_libraries(rdma_server PUBLIC cuda_common)

get_property(cuda_arch GLOBAL PROPERTY CUDA_ARCHITECTURES)
set_target_properties(rdma_server PROPERTIES CUDA_ARCHITECTURES ${cuda_arch})

# set_target_properties(rdma_server PROPERTIES
#         CUDA_SEPARABLE_COMPILATION ON)

# # Some additional directives to force the CUDA compilation, shouldn't be needed
# set_source_files_properties(${PROJECT_SOURCE_DIR}/rdma_common.c PROPERTIES LANGUAGE CUDA)
target_include_directories(rdma_server PRIVATE ${CUDAToolkit_INCLUDE_DIRS})
