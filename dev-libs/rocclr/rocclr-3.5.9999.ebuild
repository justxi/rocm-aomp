#
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Radeon Open Compute Common Language Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCclr"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocm-comgr-9999
	>=sys-devel/llvm-aomp-11.6.1"
DEPEND="${RDEPEND}
	>=dev-util/rocm-cmake-3.5.0"

PATCHES=(
	${FILESDIR}/${PN}-3.5.0-cmake-install-destination.patch
)

src_unpack() {
	EGIT_BRANCH="roc-3.5.x"
	git-r3_fetch "https://github.com/ROCm-Developer-Tools/ROCclr"

	EGIT_BRANCH="roc-3.5.x"
	git-r3_fetch "https://github.com/radeonopencompute/ROCm-OpenCL-Runtime"

	git-r3_checkout "https://github.com/ROCm-Developer-Tools/ROCclr"
	git-r3_checkout "https://github.com/radeonopencompute/ROCm-OpenCL-Runtime" ${WORKDIR}/opencl-on-vdi
}

src_configure() {
	local mycmakeargs=(
		-DUSE_COMGR_LIBRARY=YES
		-DOPENCL_DIR=${WORKDIR}/opencl-on-vdi/
		-DCMAKE_INSTALL_PREFIX="/usr"
	)
	cmake_src_configure
}

src_install() {
        # This should be fixed in the CMakeLists.txt to get this installed automatically
        sed -e "s:/var/tmp/portage/dev-libs/${PF}/work/rocclr-${PV}_build:/usr/lib64:" -i "${BUILD_DIR}/amdrocclr_staticTargets.cmake"
        insinto /usr/lib64/cmake/rocclr
        doins "${BUILD_DIR}/amdrocclr_staticTargets.cmake"

	cmake_src_install
}
