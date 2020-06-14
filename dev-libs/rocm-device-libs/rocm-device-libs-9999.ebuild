#
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-Device-Libs/"
	EGIT_BRANCH="amd-stg-open"
	EGIT_COMMIT="168cbba7c"
	S="${WORKDIR}/${P}/"
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/roc-ocl-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ROCm-Device-Libs-roc-ocl-${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Radeon Open Compute Device Libraries"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-Device-Libs"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="=dev-libs/rocr-runtime-3.5.9999
	=sys-devel/llvm-aomp-11.6.1"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/aomp/"
	)
	cmake_src_configure
}

src_install() {

	cmake_src_install

	# This should be added to the CMakeLists.txt and maybe installed to "/usr/include/rocm-device-libs"?
	# Needed by llvm-aomp-extras.
	mkdir ${D}/usr/include
	cp ${S}/irif/inc/* ${D}/usr/include
	cp ${S}/ockl/inc/ockl* ${D}/usr/include
	cp ${S}/oclc/inc/* ${D}/usr/include
	cp ${S}/ocml/inc/* ${D}/usr/include
}
