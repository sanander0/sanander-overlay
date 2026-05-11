# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit meson lua-single

DESCRIPTION="A dynamic tiling Wayland compositor using LuaJIT and LGI"
HOMEPAGE="https://github.com/trip-zip/somewm"
SRC_URI="https://github.com/trip-zip/somewm/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Добавляем флаги для портала и randr
IUSE="screencast"

REQUIRED_USE="${LUA_REQUIRED_USE}"

# Список зависимостей
RDEPEND="
	${LUA_DEPS}
	$(lua_gen_cond_dep 'dev-lua/lgi[${LUA_USEDEP}]')
	dev-libs/wayland
	gui-libs/wlroots:0.19
	dev-libs/libinput
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/cairo[X]
	x11-libs/gdk-pixbuf:2
	screencast? ( gui-libs/xdg-desktop-portal-wlr )
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
}

src_configure() {
	lua_setup
	export SOMEWM_IGNORE_LGI=1

	local emesonargs=(
		--wrap-mode nodownload
	)
	meson_src_configure
}
