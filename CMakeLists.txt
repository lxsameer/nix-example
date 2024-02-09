cmake_minimum_required(VERSION 3.10)

project(qr)

include(GNUInstallDirs)

find_package(PkgConfig)
pkg_check_modules(QR libqrencode REQUIRED)
find_package(fmt REQUIRED)

add_executable(qr src/main.cpp)
target_link_libraries(qr ${QR_LIBRARIES} fmt::fmt)

install(TARGETS qr)
