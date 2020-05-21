# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/"
	EGIT_BRANCH="amd-stg-open"
	inherit git-r3
	S="${WORKDIR}/${P}/lib/comgr"
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ROCm-CompilerSupport-rocm-${PV}/lib/comgr"
	KEYWORDS="~amd64"
fi


DESCRIPTION="Radeon Open Compute Code Object Manager"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocm-device-libs-${PV}
	>=sys-devel/llvm-aomp-11.5.0"
DEPEND="${RDEPEND}
	>=dev-util/rocm-cmake-3.3.0"

PATCHES=(
	"${FILESDIR}/${PN}-3.1.0-dependencies.patch"
	"${FILESDIR}/${PN}-amd-stg-open-find-clang.patch"
	"${FILESDIR}/${PN}-amd-stg-open-find-lld-includes.patch"
	"${FILESDIR}/${PN}-amd-stg-open-change-auto-type.patch"
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/aomp/"
		-DROCM_DIR="/usr/"
	)
	cmake_src_configure
}
