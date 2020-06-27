# Select system name Generic and change it to proper by target architecture settings files
set(CMAKE_SYSTEM_NAME Generic)
cmake_minimum_required(VERSION 3.12)

# Main project name here. Submodules will have different project names.
project(Template            # Project name
        VERSION 0.0.1       # Project Version
        DESCRIPTION "Template Embedded Project"
        LANGUAGES C CXX ASM
        )

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

if(NOT EXISTS ${CMAKE_SOURCE_DIR}/environment/${ARCH}/system.cmake)
    message(FATAL_ERROR "Target system settings file is missing. Please provide proper settings file.")
endif()

set(MODULES_SOURCE_DIR ${${CMAKE_PROJECT_NAME}_SOURCE_DIR}/source)
set(DRIVERS_SOURCE_DIR ${${CMAKE_PROJECT_NAME}_SOURCE_DIR}/drivers)

include("${CMAKE_SOURCE_DIR}/environment/${ARCH}/system.cmake")

# Create Main Project executable
add_executable(${CMAKE_PROJECT_NAME})
# Add main.c for Main proejct. 
target_sources(${CMAKE_PROJECT_NAME} PUBLIC ${MODULES_SOURCE_DIR}/main.c)

# Add submodules to the project. Each submodule should have it's own CMakeLists.txt 
add_subdirectory(${DRIVERS_SOURCE_DIR}/gpio)

# Set C/C++ compiler settings
set(CMAKE_ASM_COMPILER  "${COMPILER_PREFIX}gcc -x assembler-with-cpp")
set(CMAKE_C_COMPILER    ${COMPILER_PREFIX}gcc)
set(CMAKE_CXX_COMPILER  ${COMPILER_PREFIX}g++)
set(CMAKE_OBJCOPY       ${COMPILER_PREFIX}objcopy)
set(CMAKE_OBJDUMP       ${COMPILER_PREFIX}objdump)
message(STATUS "Compiler prefix =" ${COMPILER_PREFIX})

# Include Splint static analysis tool
include(${CMAKE_SOURCE_DIR}/environment/cmakeTools/splint.cmake)

