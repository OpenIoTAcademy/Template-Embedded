# Select system name Generic and change it to proper by target architecture settings files
set(CMAKE_SYSTEM_NAME Generic)
cmake_minimum_required(VERSION 3.12)

# Change main project name here. Submodules will have different project names.
set(PROJECT_NAME Template)
project(${PROJECT_NAME} LANGUAGES C CXX ASM)

if(NOT DEFINED ARCH)
    set(ARCH native)
endif()

string(TOLOWER ${ARCH} ARCH)

if(ARCH STREQUAL "native")
    message(STATUS "Host system selected for compile")
elseif(ARCH STREQUAL "arm")
    message(STATUS "ARM none-eabi architecture selected")
elseif(ARCH STREQUAL "armhf")
    message(STATUS "ARM linux-gnueabihf architecture selected")
else()
    message(FATAL_ERROR "Unknown architecture selected. Will stop now.")
endif()

if(NOT EXISTS "${CMAKE_SOURCE_DIR}/environment/${ARCH}/system.cmake")
    message(FATAL_ERROR "Target system settings file is missing. Please provide proper settings file.")
endif()

set(MODULES_SOURCE_DIR "${${PROJECT_NAME}_SOURCE_DIR}/source")

include("${CMAKE_SOURCE_DIR}/environment/${ARCH}/system.cmake")

set(CMAKE_ASM_COMPILER  "${COMPILER_PREFIX}gcc -x assembler-with-cpp")
set(CMAKE_C_COMPILER    ${COMPILER_PREFIX}gcc)
set(CMAKE_CXX_COMPILER  ${COMPILER_PREFIX}g++)
set(CMAKE_OBJCOPY       ${COMPILER_PREFIX}objcopy)
set(CMAKE_OBJDUMP       ${COMPILER_PREFIX}objdump)

message(STATUS "Compiler prefix = ${COMPILER_PREFIX}")

# @todo Add module level cmakefiles and helper function to auto append include directories
# Includes
include_directories(${MODULES_SOURCE_DIR}/hello/inc)

# @todo Add module level cmakefiles and helper function to auto append source files
# Source Files
list(APPEND ALL_SOURCES
     "${MODULES_SOURCE_DIR}/hello/src/hello.c"
     "${MODULES_SOURCE_DIR}/main.c"
)
add_executable(${PROJECT_NAME} ${ALL_SOURCES})
