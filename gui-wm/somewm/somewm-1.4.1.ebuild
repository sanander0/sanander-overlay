# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Добавляем lua-single для корректной работы с LuaJIT
LUA_COMPAT=( luajit )

inherit meson lua-single

DESCRIPTION="A dynamic tiling Wayland compositor using LuaJIT and LGI"
HOMEPAGE="https://github.com/trip-zip/somewm"
SRC_URI="https://github.com/trip-zip/somewm/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${LUA_REQUIRED_USE}"

# Список зависимостей расширился согласно логу Meson
RDEPEND="
	${LUA_DEPS}
	dev-lua/lgi[${LUA_USEDEP}]
	dev-libs/wayland
	dev-libs/glib:2
	gui-libs/wlroots:0.18
	media-libs/libglvnd
	media-libs/libinput
	media-libs/mesa
	x11-libs/libxkbcommon
	x11-libs/pixman
	x11-libs/pango
	x11-libs/cairo[X]
	x11-libs/libxcb
	x11-libs/xcb-util-icccm
	dev-libs/dbus-glib
	gui-libs/gtk:3[wayland]
"
DEPEND="${RDEPEND}
	dev-libs/wayland-protocols
"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dignore_lgi=false
	)
	meson_src_configure
}
