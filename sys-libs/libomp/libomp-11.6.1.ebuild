# Copyright
#

EAPI=7
inherit git-r3 cmake-utils

DESCRIPTION="OpenMP for Radeon™ GPUs"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/aomp"
EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/amd-llvm-project.git"
EGIT_COMMIT="aomp-11.6-1"

LICENSE=""
KEYWORDS=""
SLOT="0"

IUSE="debug nvptx"

RDEPEND="=dev-libs/rocr-runtime-3.5.9999"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-vcs/git"

S="${WORKDIR}/${P}/openmp"

#CMAKE_MAKEFILE_GENERATOR="emake"

pkg_pretend() {

	if use nvptx; then
		if gcc-major-version gt 7; then
			einfo "Maximum GCC Version is 7"
			die
		fi
	fi
}

src_configure() {
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
	export GFXLIST="gfx803;gfx900"

	AOMP_PATH="/usr/lib/llvm/aomp"

	export AOMP="/usr/lib/llvm/aomp"

#		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/aomp/lib/cmake/llvm"

	local mycmakeargs=(
		-DROCM_DIR="/usr/"

		-DAOMP_STANDALONE_BUILD=1
		-DOPENMP_ENABLE_LIBOMPTARGET=1
		-DLIBOMP_COPY_EXPORTS=OFF
		-DOPENMP_TEST_C_COMPILER="${AOMP_PATH}/bin/clang"
		-DOPENMP_TEST_CXX_COMPILER="${AOMP_PATH}/bin/clang++"

		-DLIBOMPTARGET_AMDGCN_GFXLIST="${GFXLIST}"

		-DCMAKE_C_FLAGS=-g
		-DCMAKE_CXX_FLAGS=-g
		-DCMAKE_INSTALL_PREFIX="/usr/lib/llvm/aomp/"
		-DOPENMP_INSTALL_LIBDIR="/usr/lib64"
	)

	if use nvptx; then
		mycmakeargs+=(
			-DLIBOMPTARGET_NVPTX_ENABLE_BCLIB=ON
			-DLIBOMPTARGET_NVPTX_CUDA_COMPILER=${AOMP_PATH}/bin/clang++
			-DLIBOMPTARGET_NVPTX_ALTERNATE_HOST_COMPILER="/usr/bin"
			-DLIBOMPTARGET_NVPTX_BC_LINKER=${AOMP_PATH}/bin/llvm-link
			-DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=${NVPTXGPUS}
		)
	fi

	# Needed?
	# $AOMP_ORIGIN_RPATH -DROCM_DIR=$ROCM_DIR"

	cmake-utils_src_configure
}

