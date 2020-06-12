include_guard(GLOBAL)

if(WIN32 OR MINGW)
    set(CMAKE_SYSTEM_NAME Windows)
elseif(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux")
    set(CMAKE_SYSTEM_NAME Linux)
else()
    message(FATAL_ERROR "Currently only Windows and Linux platforms are supported.")
endif()    
unset(COMPILER_PREFIX)