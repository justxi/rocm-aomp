# Copyright
#

EAPI=7
inherit git-r3 cmake-utils

DESCRIPTION="AOMP is an open source Clang/LLVM based compiler with added support for the OpenMP® API on Radeon™ GPUs"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/aomp"
EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/aomp-extras.git"
EGIT_COMMIT="aomp-11.6-1"

LICENSE=""
KEYWORDS=""
SLOT="0"

IUSE="debug"

RDEPEND="=dev-libs/llvm-aomp-3.5.9999"
DEPEND="${RDEPEND}
        dev-util/cmake
        dev-vcs/git"

#S="${WORKDIR}/${P}/llvm"

src_configure() {
        if use debug; then
                CMAKE_BUILD_TYPE=Debug
        else
                CMAKE_BUILD_TYPE=Release
        fi

        local mycmakeargs=(
		-DLLVM_DIR="/usr/lib/llvm/aomp/lib/cmake/llvm"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/aomp/"
		-DROCM_DIR="/usr"
        )

        cmake-utils_src_configure
}

