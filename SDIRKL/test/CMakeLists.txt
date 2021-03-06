cmake_minimum_required(VERSION 2.6)
project(Odes-NG)
enable_language(CXX)
#
# To use intel compiler:
# CXX=icpc cmake ..
# otherwise, to use g++:
#  cmake ..
#
include_directories(
${CMAKE_SOURCE_DIR}/../include
${CMAKE_SOURCE_DIR}/../../common/include
${CMAKE_SOURCE_DIR}/Lapl/.
/usr/include/superlu/
)
if (${CMAKE_CXX_COMPILER} MATCHES "icpc.*$")
  set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS}  -DICC -DALIGN_BLOCKED -restrict -O3   -g -xavx -fargument-noalias  -ansi-alias -qopt-report-phase=vec -qopt-report-file=stdout -qopt-subscript-in-range -std=c++14 ")

elseif(${CMAKE_CXX_COMPILER} MATCHES "clang.*$")
  set (USING_GNU TRUE)
  set(CMAKE_CXX_COMPILER "clang++")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -Wall  -DCLANG")

else ()
  set (USING_GNU TRUE)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  -O3 -g -std=c++14 -Wall -DALIGN_BLOCKED -DGCC  -march=native -ftree-vectorize  -fstrict-aliasing")

endif ()

add_executable(
  run
  ../main.cpp
  ${CMAKE_SOURCE_DIR}/Lapl/SuperLu.cpp
  ${CMAKE_SOURCE_DIR}/Lapl/csr.cpp
  )
if (${CMAKE_CXX_COMPILER} MATCHES "icpc.*$")
  target_link_libraries(
    run
    superlu
    mkl_intel_lp64
    mkl_sequential
    mkl_core
    mkl_lapack95_lp64
    mkl_blas95_lp64
    #proc
    rt
    )
else ()
  target_link_libraries(
    run
    superlu
    )
endif ()



