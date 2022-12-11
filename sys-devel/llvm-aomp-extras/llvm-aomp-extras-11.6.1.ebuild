# Copyright
#

EAPI=7
inherit git-r3 cmake

DESCRIPTION="AOMP is an open source Clang/LLVM based compiler with added support for the OpenMP® API on Radeon™ GPUs"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/aomp"
EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/aomp-extras.git"
EGIT_COMMIT="aomp-11.6-1"

LICENSE=""
KEYWORDS=""
SLOT="0"

IUSE="debug"

RDEPEND="=dev-libs/rocm-device-libs-9999
	=sys-devel/llvm-aomp-11.6.1"
DEPEND="${RDEPEND}
        dev-util/cmake
        dev-vcs/git"

src_prepare() {

	sed -e "s:/lib/bitcode:/lib:" -i "${S}/aomp-device-libs/libm/CMakeLists.txt" || die
	sed -e "s:/lib/bitcode:/lib:" -i "${S}/aomp-device-libs/aompextras/CMakeLists.txt" || die

	cmake_src_prepare
}

src_configure() {
        if use debug; then
                CMAKE_BUILD_TYPE=Debug
        else
                CMAKE_BUILD_TYPE=Release
        fi

	# DEVICELIBS_ROOT has to match installation path of "dev-libs/rocm-device-libs"

        local mycmakeargs=(
		-DROCM_DIR="/usr"
		-DAOMP="/usr/lib/llvm/aomp"
		-DAOMP_STANDALONE_BUILD=0
		-DDEVICELIBS_ROOT="/usr/lib"
		-DLLVM_DIR="/usr/lib/llvm/aomp/lib/cmake/llvm"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/aomp/"
        )

        cmake_src_configure
}

