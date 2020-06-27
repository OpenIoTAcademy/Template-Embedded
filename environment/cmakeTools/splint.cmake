# Get include directories list and modify them to use with static analyzer
get_property(dirs TARGET ${CMAKE_PROJECT_NAME} PROPERTY INCLUDE_DIRECTORIES)
foreach(dir ${dirs})
    list(APPEND LINTER_INCLUDES "-I${dir}")
endforeach()
string(REPLACE ";" " " LINTER_INCLUDES "${LINTER_INCLUDES}")
string(REPLACE "${${CMAKE_PROJECT_NAME}_SOURCE_DIR}" ".." LINTER_INCLUDES "${LINTER_INCLUDES}")

message(STATUS "Linter Includes =${LINTER_INCLUDES}")

get_property(LINTER_SOURCES TARGET ${CMAKE_PROJECT_NAME} PROPERTY SOURCES)
FILE(REMOVE ${CMAKE_BINARY_DIR}/linter.txt)
set(LINT_ERROR_STOP 0)

# Run splint static analysis tool for each source file.
foreach(source ${LINTER_SOURCES})
    execute_process(
       COMMAND splint ${LINTER_INCLUDES} ${source}
       WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
       OUTPUT_FILE lint_temp.txt
       ERROR_FILE  lint_temp.txt
    )
    FILE(READ ${CMAKE_BINARY_DIR}/lint_temp.txt LINTER_ERROR)
    FILE(APPEND ${CMAKE_BINARY_DIR}/linter.txt "Static Analysis of ${source}\n")
    FILE(APPEND ${CMAKE_BINARY_DIR}/linter.txt ${LINTER_ERROR})
    FILE(REMOVE ${CMAKE_BINARY_DIR}/lint_temp.txt)
    string(REGEX MATCH "Finished checking --- ([0-9]*) code warnings" LINTER_ERROR ${LINTER_ERROR})
    if (NOT LINTER_ERROR STREQUAL "" )
        set(LINT_ERROR_STOP 1)
    endif()
endforeach()

if(LINT_ERROR_STOP)
    message(FATAL_ERROR "Static analysis found error(s). Check linter.txt file for details.")
endif()
