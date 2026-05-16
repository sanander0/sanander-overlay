# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An open-source cross-platform alternative to AirDrop"
HOMEPAGE="https://localsend.org https://github.com/localsend/localsend"
SRC_URI="https://github.com/localsend/localsend/releases/download/v${PV}/LocalSend-${PV}-linux-x86-64.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Минимальные зависимости для работы Flutter-приложений в Linux
RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:3
	x11-libs/pango
	media-libs/fontconfig
	media-libs/freetype:2
"
DEPEND="${RDEPEND}"
BDEPEND=""

QA_PREBUILT="usr/bin/localsend_app
	usr/lib/localsend/lib/*"

EAPI=8

inherit desktop xdg # xdg екласс поможет автоматически обновить кэш меню при установке

# ...
src_install() {
	diropts -m0755
	dodir /usr/share/localsend
	cp -r * "${ED}/usr/share/localsend/" || die

	dodir /usr/bin
	dosym ../share/localsend/localsend_app /usr/bin/localsend

	# Устанавливаем иконку в системный Pixmaps для надежности
	newicon "${ED}/usr/share/localsend/data/flutter_assets/assets/img/logo-256.png" "localsend.png"

	# Создаем десктоп-файл (третий параметр — имя иконки без расширения)
	make_desktop_entry "localsend" "LocalSend" "localsend" "Network;Utility;"
}
