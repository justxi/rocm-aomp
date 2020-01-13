# Copyright
#

EAPI=7
inherit git-r3 cmake-utils flag-o-matic

DESCRIPTION="AOMP is an open source Clang/LLVM based compiler with added support for the OpenMP® API on Radeon™ GPUs"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/aomp"
EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/llvm-project.git"
EGIT_COMMIT="AOMP-${PV}"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE=""

#RDEPEND="=dev-libs/rocr-runtime-${PV}*
#	 dev-util/rocminfo"
RDEPEND=""
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-vcs/git"

CMAKE_BUILD_TYPE=Release

src_configure() {
#	strip-flags
#	append-cxxflags '-O2'

#	if ! use debug; then
#		append-cflags "-DNDEBUG"
#		append-cxxflags "-DNDEBUG"
#	fi

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/aomp/"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/aomp/share/man"
	)

	cmake-utils_src_configure
}

#src_install() {
#	echo "HCC_HOME=/usr/lib/hcc/$(ver_cut 1-2)" > 99hcc || die
#	echo "HSA_PATH=/usr" >> 99hcc || die
#	echo "LDPATH=/usr/lib/hcc/$(ver_cut 1-2)/lib" >> 99hcc || die
#	echo "ROOTPATH=/usr/lib/hcc/$(ver_cut 1-2)/bin" >> 99hcc || die
#	echo "ROCM_PATH=/usr" >> 99hcc || die
#	doenvd 99hcc
#
#	cmake-utils_src_install
#}

