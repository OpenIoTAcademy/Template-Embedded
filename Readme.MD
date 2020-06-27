# OpenIoTAcademy Template-Embedded project files.

This build system is developed for OpenIoTAcademy projects. It is using CMake for build system. It will include unit-tests for each submodule.

CMake build system currently generates Makefiles for building. Any IDE specific project files will be included by developers.

## How to build

Navigate into build/ folder and run those commands to build for native(for same host) compiling.

`cmake ../`

`make`

If you want to cross compile please provide ARCH variable to the CMake. 
Current plan is to support these : 

* bare-metal ARM microcontrollers which can be invoked by `arm`
* gnueabihf ARM microprocessors which can be invoked by `armhf`

`cmake ../ -DARCH=arm` or `cmake ../ -DARCH=armhf`
