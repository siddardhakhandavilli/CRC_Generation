vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO sciplot/sciplot
    REF v0.2.2
    SHA512 2e7646e0fd52643bf86c09466d921d7b6a53349cd113e15177c3389654e0489df1d56f5fdcad7fc73834e632fff0a303d1366688ac7bb11937d49babd0742a7f
    HEAD_REF vcpkg
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DSCIPLOT_BUILD_TESTS=OFF
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH share/sciplot)

vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
