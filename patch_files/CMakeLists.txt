cmake_minimum_required (VERSION 3.28)
project(RagelForWindows LANGUAGES CXX)
set(CMAKE_DISABLE_FIND_PACKAGE_Python ON)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
file(GLOB_RECURSE src_files CONFIGURE_DEPENDS "ragel/*.h" "ragel/*.cpp" "aapl/*.h")
add_executable(Ragel ${src_files})
target_include_directories(Ragel PRIVATE ${CMAKE_SOURCE_DIR}/aapl ${CMAKE_SOURCE_DIR}/linux_headers)
target_compile_options(Ragel PRIVATE /W0 /permissive- )
