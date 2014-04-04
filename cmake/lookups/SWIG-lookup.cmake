# Downloads SWIG
ExternalProject_Add(
    SWIG
    PREFIX ${EXTERNAL_ROOT}
    URL http://prdownloads.sourceforge.net/swig/swig-2.0.12.tar.gz
    CONFIGURE_COMMAND ./configure --prefix=${EXTERNAL_ROOT}
    BUILD_IN_SOURCE 1
    BUILD_COMMAND make
    INSTALL_COMMAND make install
    TIMEOUT 10
    # Wrap download, configure and build steps in a script to log output
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
)
# Rerun cmake to capture new armadillo install
add_recursive_cmake_step(SWIG DEPENDEES install)