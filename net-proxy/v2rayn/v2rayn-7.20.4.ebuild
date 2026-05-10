# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="GUI client for Windows and Linux, support Xray core and v2fly core"
HOMEPAGE="https://github.com/2dust/v2rayN"

# Используем прямую ссылку, которую ты нашел.
# -> ${P}.zip переименовывает скачанный файл в v2rayn-7.20.4.zip для порядка в distfiles
SRC_URI="https://github.com/2dust/v2rayN/releases/download/${PV}/v2rayN-linux-64.zip -> ${P}.zip"

LICENSE="GPL-3.0"
SLOT="0"
KEYWORDS="~amd64"

# Зависимости для запуска .NET Avalonia приложения
RDEPEND="
    dev-libs/icu
    sys-libs/zlib
    media-libs/libsdl2
    x11-libs/libX11
    x11-libs/libICE
    x11-libs/libSM
"
BDEPEND="app-arch/unzip"

# Указываем путь к папке ВНУТРИ архива
S="${WORKDIR}/v2rayN-linux-64"

src_unpack() {
    default
    # Если вдруг папка внутри называется иначе, можно проверить это командой ls
}

src_prepare() {
    default
}

src_configure() {
    :
}

src_compile() {
    :
}

src_install() {
    # 1. Создаем директорию в /opt и копируем туда всё содержимое S
    insinto /opt/v2rayn
    doins -r .

    # 2. Устанавливаем права на исполнение основного бинарника
    # ED указывает на временный образ установки (image)
    fperms +x /opt/v2rayn/v2rayN

    # 3. Устанавливаем права на исполнение для ядер (xray/v2ray), если они есть в bin/
    if [[ -d "${ED}/opt/v2rayn/bin" ]]; then
        find "${ED}/opt/v2rayn/bin" -type f -exec chmod +x {} + || die
    fi

    # 4. Создаем исполняемый файл в /usr/bin
    dosym /opt/v2rayn/v2rayN /usr/bin/v2rayn

    # 5. Иконка и пункт в меню (проверь наличие v2rayN.png в корне архива)
    if [[ -f "v2rayN.png" ]]; then
        newicon -s 512 v2rayN.png v2rayn.png
        make_desktop_entry v2rayn "v2rayN" v2rayn "Network;Proxy;"
    fi
}
