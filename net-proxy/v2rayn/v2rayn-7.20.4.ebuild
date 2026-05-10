# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="GUI client for Windows and Linux, support Xray core and v2fly core"
HOMEPAGE="https://github.com/2dust/v2rayN"
SRC_URI="https://github.com/2dust/v2rayN/releases/download/${PV}/v2rayN-linux-64.zip -> ${P}.zip"

LICENSE="GPL-3.0"
SLOT="0"
KEYWORDS="~amd64"

# ВАЖНО: Запрещаем Portage удалять символы из бинарника
RESTRICT="strip"

RDEPEND="
    dev-libs/icu
    sys-libs/zlib
    media-libs/libsdl2
    x11-libs/libX11
"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/v2rayN-linux-64"

src_install() {
    # Создаем целевую директорию
    dodir /opt/v2rayn

    # Копируем всё содержимое, сохраняя атрибуты (-p) и структуру (-R)
    cp -pPR . "${ED}/opt/v2rayn/" || die "Copy failed"

    # Явно выставляем права на запуск основного файла
    chmod +x "${ED}/opt/v2rayn/v2rayN" || die

    # Выставляем права на запуск для ядер в bin/
    if [[ -d "${ED}/opt/v2rayn/bin" ]]; then
        find "${ED}/opt/v2rayn/bin" -type f -exec chmod +x {} + || die
    fi

    # Симлинк
    dosym /opt/v2rayn/v2rayN /usr/bin/v2rayn

    # Иконка и меню
    if [[ -f "v2rayN.png" ]]; then
        newicon -s 512 v2rayN.png v2rayn.png
        make_desktop_entry v2rayn "v2rayN" v2rayn "Network;Proxy;"
    fi
}
