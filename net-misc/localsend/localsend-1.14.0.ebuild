# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An open-source cross-platform alternative to AirDrop (From Source)"
HOMEPAGE="https://github.com/localsend/localsend"
SRC_URI="https://github.com/localsend/localsend/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Требуется установленный Flutter SDK (обычно ищется в сторонних репозиториях)
BDEPEND="
	|| ( dev-util/flutter-bin dev-util/flutter )
"
RDEPEND="
	x11-libs/gtk+:3
	dev-libs/glib:2
"

src_unpack() {
	default
	# В реальном ebuild здесь также должна происходить распаковка
	# заранее подготовленного .pub-cache архива с зависимостями.
}

src_compile() {
	# Переходим в директорию с исходниками приложения для Linux (обычно app)
	cd "${S}/app" || die

	# Отключаем аналитику и собираем в офлайн режиме (требует pub-cache)
	flutter config --no-analytics
	flutter build linux --release || die "Build failed"
}

src_install() {
	cd "${S}/app/build/linux/x64/release/bundle" || die

	diropts -m0755
	dodir /usr/share/localsend
	cp -r * "${ED}/usr/share/localsend/" || die

	dodir /usr/bin
	dosym ../share/localsend/localsend_app /usr/bin/localsend

	# Иконка и desktop-файл (аналогично бинарной версии)
	doicon "${S}/app/assets/img/logo-256.png"
	make_desktop_entry "localsend" "LocalSend" "logo-256" "Network"
}
