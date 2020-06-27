cmake_minimum_required(VERSION 3.12)

# Submodule project name
project(gpio_driver)

# Add include folders to main project 
target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC ${${PROJECT_NAME}_SOURCE_DIR}/inc)

# Add source files to main project. Each source file should included in one line
target_sources(${CMAKE_PROJECT_NAME} PUBLIC ${${PROJECT_NAME}_SOURCE_DIR}/src/gpio.c)
