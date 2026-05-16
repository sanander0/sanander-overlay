# Copyright 2026
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit git-r3 meson python-any-r1 xdg

DESCRIPTION="GTK4 application that downloads catgirl images from nekos.moe"
HOMEPAGE="https://github.com/NyarchLinux/CatgirlDownloader"
EGIT_REPO_URI="https://github.com/NyarchLinux/CatgirlDownloader.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	gui-libs/gtk:4
	gui-libs/libadwaita
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
"

RDEPEND="${DEPEND}"

BDEPEND="
	${PYTHON_DEPS}
	dev-build/meson
	dev-build/ninja
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		--prefix=/usr
	)

	meson_src_configure
}
