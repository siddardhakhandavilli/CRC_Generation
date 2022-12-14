if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Linux")
    message(
"${PORT} currently requires the following libraries from the system package manager:
    libudev-dev
These can be installed on Ubuntu systems via sudo apt install libudev-dev"
    )
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO NordicSemiconductor/pc-ble-driver
    REF v4.1.2
    SHA512 625a52151f2c78421e48e90ff60292c6106e8504b55a26c7df716df75e051a40d2ee4a26c57b5daaa370e53a79002fe965aee8a0d8749f7dce380e8e4a617c95
    HEAD_REF master
    PATCHES
        001-arm64-support.patch
)

# Ensure that git is found within CMakeLists.txt by appending vcpkg's git executable dirpath to $PATH.
# Git should always be available as it is downloaded during the bootstrap phase.
# Append instead of prepend to $PATH to honor the user's git executable as a general rule.
vcpkg_find_acquire_program(GIT)
get_filename_component(GIT_EXE_PATH "${GIT}" DIRECTORY)
vcpkg_add_to_path("${GIT_EXE_PATH}")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DDISABLE_EXAMPLES=ON
        -DDISABLE_TESTS=ON
        -DNRF_BLE_DRIVER_VERSION=4.1.2
        -DCONNECTIVITY_VERSION=4.1.2
    MAYBE_UNUSED_VARIABLES
        DISABLE_EXAMPLES
        DISABLE_TESTS
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup()

# Copy hex files into shared folder for package
foreach(HEX_DIR IN ITEMS "sd_api_v2" "sd_api_v3" "sd_api_v5" "sd_api_v6")
    set(TARGET_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/${PORT}/hex/${HEX_DIR}")
    file(MAKE_DIRECTORY "${TARGET_DIRECTORY}")
    file(INSTALL "${SOURCE_PATH}/hex/${HEX_DIR}" DESTINATION "${TARGET_DIRECTORY}/..")
endforeach()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")


if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
