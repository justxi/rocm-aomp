#
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Radeon Open Compute Common Language Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCclr"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocm-comgr-${PV}
	>=sys-devel/llvm-aomp-11.5.0"
DEPEND="${RDEPEND}
	>=dev-util/rocm-cmake-3.3.0"

PATCHES=(
	${FILESDIR}/rocclr-master-install-cmake-file.patch
)

src_unpack() {
	EGIT_BRANCH="master"
	git-r3_fetch "https://github.com/ROCm-Developer-Tools/ROCclr"

	EGIT_BRANCH="master"
	git-r3_fetch "https://github.com/radeonopencompute/ROCm-OpenCL-Runtime"

	git-r3_checkout "https://github.com/ROCm-Developer-Tools/ROCclr"
	git-r3_checkout "https://github.com/radeonopencompute/ROCm-OpenCL-Runtime" ${WORKDIR}/opencl-on-vdi
}

src_configure() {
	local mycmakeargs=(
		-DUSE_COMGR_LIBRARY=YES
		-DOPENCL_DIR=${WORKDIR}/opencl-on-vdi/api/opencl
		-DCMAKE_INSTALL_PREFIX="/usr"
	)
	cmake_src_configure
}

src_install() {

	# CMakeLists.txt must be fixed to get this installed automaticaly...
	mkdir -p ${D}/usr/lib64
	cp ${BUILD_DIR}/amdvdi_staticTargets.cmake ${D}/usr/lib64 || die
	sed -e "s:/var/tmp/portage/dev-libs/rocclr-9999/work/rocclr-9999_build:/usr/lib64:" -i ${D}/usr/lib64/amdvdi_staticTargets.cmake

	cmake_src_install
}
