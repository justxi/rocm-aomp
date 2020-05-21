#
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="HIP: C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP"
EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/HIP"
EGIT_BRANCH="master-next"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocclr-${PV}
	>=sys-devel/llvm-aomp-11.5.0"
DEPEND="${RDEPEND}
	>=dev-util/rocm-cmake-3.3.0"

PATCHES=(
	"${FILESDIR}/hipvdi-master-next-disable-testing.patch"
)

# -DROCM_PATH=$ROCM_DIR \
# -DCMAKE_MODULE_PATH=$ROCM_DIR/cmake \
# -DCMAKE_PREFIX_PATH=$ROCM_DIR/include;$ROCM_DIR \

src_configure() {
	local mycmakeargs=(
		-DHIP_COMPILER=clang
		-DHIP_PLATFORM=vdi
		-DVDI_DIR=/usr/include/rocclr
		-DLIBVDI_STATIC_DIR=/usr/lib64/
		-DHSA_PATH=/usr
		-DCMAKE_INSTALL_PREFIX="/usr/lib/hip/"
		-DCMAKE_CXX_FLAGS=-Wno-ignored-attributes
		-DCMAKE_PREFIX_PATH=/usr/include/rocclr/include
	)
	cmake_src_configure
}
