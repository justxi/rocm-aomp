# Copyright
#

EAPI=7
inherit git-r3 cmake-utils flag-o-matic

DESCRIPTION="AOMP is an open source Clang/LLVM based compiler with added support for the OpenMP® API on Radeon™ GPUs"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/aomp"
EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/llvm-project.git"
EGIT_BRANCH="AOMP-${PV}"

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

S="${WORKDIR}/${P}/llvm"

CMAKE_BUILD_TYPE=Release

src_configure() {

	AOCC_CMAKE_OPTS="-DLLVM_BUILD_LLVM_DYLIB:STRING=ON \
                         -DLLVM_LINK_LLVM_DYLIB=ON \
                         -DLLVM_ENABLE_LIBEDIT=OFF \
                         -DCLANG_DEFAULT_LINKER:STRING=ld.lld \
                         -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON \
                         -DCOMPILER_RT_BUILD_XRAY=OFF \
                         -DLLVM_ENABLE_ASSERTIONS:BOOL=ON \
                         -DCMAKE_CXX_FLAGS='-Wno-error=pedantic'"

	# Set list of default nvptx subarchitectures to build
	# 30,32,35,50,60,61,70
	export NVPTXGPUS="61"

	# Set list of default amdgcn subarchitectures to build
	# gfx700 gfx701 gfx801 gfx803 gfx900 gfx902 gfx906 gfx908
	export GFXLIST="gfx803"


# NVPTX
	local mycmakeargs=(
		$AOCC_CMAKE_OPTS
		-DLLVM_ENABLE_PROJECTS:STRING="clang;lld;compiler-rt;"
		-DLLVM_TARGETS_TO_BUILD:STRING="AMDGPU;NVPTX;X86;"
		-DLLVM_VERSION_SUFFIX=_AOMP_1.0
		-DBUG_REPORT_URL="https://github.com/justxi/rocm-aomp"
		-DLLVM_ENABLE_BINDINGS=OFF
		-DLLVM_INCLUDE_BENCHMARKS=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/aomp/"
                -DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/lib/aomp/lib"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/aomp/share/man"
	)
#		-DATMI_HSA_INTEROP=on
#		-DATMI_WITH_AOMP=on
#		-DROCM_DIR="/usr"
#		-DROCM_VERSION="3.0.0"
#                     -DLLVM_DIR=$LLVM_DIR
#                     $EXTERNAL_PROJECTS_OPTS
#                     $DO_TESTS
#                     $AOMP_ORIGIN_RPATH

	cmake-utils_src_configure
}
