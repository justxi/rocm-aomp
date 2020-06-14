# Copyright
#

EAPI=7
inherit git-r3 cmake-utils flag-o-matic

DESCRIPTION="AOMP is an open source Clang/LLVM based compiler with added support for the OpenMP® API on Radeon™ GPUs"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/aomp"
EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/amd-llvm-project.git"
EGIT_COMMIT="aomp-11.6-1"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE="debug"

RDEPEND="=dev-libs/rocr-runtime-3.5.9999"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-vcs/git"

S="${WORKDIR}/${P}/llvm"

CMAKE_MAKEFILE_GENERATOR="emake"

src_configure() {
	#strip-flags
        #filter-flags '*march*'

#	if ! use debug; then
#		append-cflags "-DNDEBUG"
#		append-cxxflags "-DNDEBUG"
#	fi

	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

	# Set list of default nvptx subarchitectures to build
	# 30,32,35,50,60,61,70
	export NVPTXGPUS="61"

	# Set list of default amdgcn subarchitectures to build
	# gfx700 gfx701 gfx801 gfx803 gfx900 gfx902 gfx906 gfx908
	export GFXLIST="gfx803"

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
                -DLLVM_ENABLE_ASSERTIONS=ON
		-DLLVM_ENABLE_PROJECTS="clang;lld;compiler-rt;"
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86;"
		-DLLVM_VERSION_SUFFIX=_AOMP_11.6.1
		-DBUG_REPORT_URL="https://github.com/justxi/rocm-aomp"
		-DLLVM_ENABLE_BINDINGS=OFF
		-DLLVM_INCLUDE_BENCHMARKS=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/aomp/"
                -DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/lib/llvm/aomp/lib"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/llvm/aomp/share/man"

		-DCMAKE_SHARED_LINKER_FLAGS="-Wl,--disable-new-dtags"
		-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON
		-DCMAKE_INSTALL_RPATH=\$ORIGIN:\$ORIGIN/../lib:\$ORIGIN/../hsa/lib:\$ORIGIN/../../lib64:\$ORIGIN/../../hsa/lib:$AOMP_INSTALL_DIR/lib:$AOMP_INSTALL_DIR/hsa/lib
	)

	# TODO: Edit $AOMP_INSTALL_DIR
	#       Add "NVPTX" to enabled projects

#		-DROCM_DIR="/usr"
#		-DROCM_VERSION="3.0.0"

	cmake-utils_src_configure
}

