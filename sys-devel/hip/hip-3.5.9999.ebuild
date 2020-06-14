#
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="HIP: C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP"
EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/HIP"
EGIT_BRANCH="roc-3.5.x"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocclr-${PV}
	>=sys-devel/llvm-aomp-11.6.1"
DEPEND="${RDEPEND}
	>=dev-util/rocm-cmake-3.5.0"

PATCHES=(
	"${FILESDIR}/hip-3.5.9999-disable-testing.patch"
)

# -DROCM_PATH=$ROCM_DIR \
# -DCMAKE_MODULE_PATH=$ROCM_DIR/cmake \
# -DCMAKE_PREFIX_PATH=$ROCM_DIR/include;$ROCM_DIR \

S="${WORKDIR}/hip-3.5.9999"

src_configure() {

	# Needed?
	#	-DROCM_PATH="/usr"

	local mycmakeargs=(
		-DHSA_PATH="/usr"
		-DHIP_COMPILER=clang
		-DHIP_PLATFORM=rocclr
		-DROCclr_DIR="/usr/include/rocclr"
		-DLIBROCclr_STATIC_DIR="/usr/lib64/cmake/rocclr"
		-DCMAKE_CXX_FLAGS=-Wno-ignored-attributes
		-DCMAKE_PREFIX_PATH=/usr/include/rocclr/include
		-DCMAKE_INSTALL_PREFIX="/usr/lib/hip/"
	)
	cmake_src_configure
}
