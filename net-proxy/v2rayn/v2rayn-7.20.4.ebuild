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
    # 1. Копируем всё содержимое из рабочей папки в /opt/v2rayn
    # Используем '.', чтобы скопировать все файлы и подпапки (bin, guiConfigs и т.д.)
    insinto /opt/v2rayn
    doins -r .

    # 2. Устанавливаем права на исполнение основного бинарника
    # В ebuild-ах fperms работает относительно образа установки
    fperms +x /opt/v2rayn/v2rayN

    # 3. Устанавливаем права на исполнение для файлов в папке bin (там лежат xray/v2ray)
    # Если папка bin существует и там есть файлы
    if [[ -d "${ED}/opt/v2rayn/bin" ]]; then
        fperms +x /opt/v2rayn/bin/v2ray
        fperms +x /opt/v2rayn/bin/xray
    fi

    # 4. Создаем симлинк в /usr/bin для удобного запуска
    dosym /opt/v2rayn/v2rayN /usr/bin/v2rayn

    # 5. Добавляем иконку и .desktop файл для меню приложений
    newicon -s 512 v2rayN.png v2rayn.png
    make_desktop_entry v2rayn "v2rayN" v2rayn "Network;Proxy;"
}
