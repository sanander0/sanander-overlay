# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A dynamic tiling Wayland compositor"
HOMEPAGE="https://github.com/trip-zip/somewm"
SRC_URI="https://github.com/trip-zip/somewm/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-libs/wayland
	gui-libs/wlroots:0.18
	media-libs/libglvnd
	x11-libs/libxkbcommon
	x11-libs/pixman
	x11-libs/pango
	sys-libs/libcap
"
DEPEND="${RDEPEND}
	dev-libs/wayland-protocols
"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_prepare() {
	default
	# Исправляем жесткие пути и флаги в Makefile
	sed -i -e 's/^LDFLAGS =/LDFLAGS +=/' \
	       -e 's/^CFLAGS =/CFLAGS +=/' \
	       -e 's/cc/$(CC)/' Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	dodoc README.md
}
