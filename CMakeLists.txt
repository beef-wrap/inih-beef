cmake_minimum_required(VERSION 3.27)

project(inih)

# remove "lib" prefix on unix systems
set(CMAKE_STATIC_LIBRARY_PREFIX "")

if (WIN32)
    set(OUTPUT_DIR "windows" CACHE STRING "")
elseif(APPLE)
    set(OUTPUT_DIR "macos" CACHE STRING "")
elseif(UNIX)
    set(OUTPUT_DIR "linux" CACHE STRING "")
endif ()

add_library(inih STATIC inih/ini.c)

set_target_properties(inih PROPERTIES OUTPUT_NAME_DEBUG "inihd")
set_target_properties(inih PROPERTIES OUTPUT_NAME_RELEASE "inih")
set_target_properties(inih PROPERTIES ARCHIVE_OUTPUT_DIRECTORY $<LOWER_CASE:../../libs/${OUTPUT_DIR}>) 