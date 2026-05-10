# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="GUI client for Windows and Linux, support Xray core and v2fly core"
HOMEPAGE="https://github.com/2dust/v2rayn"
SRC_URI="https://github.com/2dust/v2rayN/releases/download/${PV}/v2rayN-linux-64.zip -> ${P}.zip"

LICENSE="GPL-3.0"
SLOT="0"
KEYWORDS="~amd64"

# Зависимости для работы .NET GUI (Avalonia UI / SDL2)
RDEPEND="
    dev-libs/icu
    sys-libs/zlib
    media-libs/libsdl2
    x11-libs/libX11
"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
    default
    # Бинарник во многих сборках называется v2rayN.Desktop
    # Если в архиве другое имя, подправьте ниже
}

src_install() {
    # Устанавливаем в /opt, так как это готовый бандл со всеми библиотеками
    insinto /opt/v2rayn
    doins -r *

    # Делаем основной файл исполняемым
    fperms +x /opt/v2rayn/v2rayN

    # Создаем симлинк в /usr/bin
    dosym /opt/v2rayn/v2rayN.Desktop /usr/bin/v2rayn

    # Иконка и desktop-файл
    newicon -s 512 guiConfigs/logo.png v2rayn.png
    make_desktop_entry v2rayn "v2rayN" v2rayn "Network;Proxy;"
}
