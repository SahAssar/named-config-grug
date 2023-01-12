pkgname=named-config-grug
pkgver() {
  # Use number of revisions and hash as version
  cd "$pkgname"
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}
pkgrel=1
arch=('any')
pkgdesc="Named config for grug"
url="https://git.grug.se/admin/named-config-grug"
license=('MIT')
depends=('bind' 'server-config-grug')
makedepends=()
provides=()
conflicts=()
install="script.install"
package() {
  mkdir -p "$pkgdir/etc/systemd/system/named.service.d"
  cp override.conf "$pkgdir/etc/systemd/system/named.service.d/"
  cp named-reload.path "$pkgdir/etc/systemd/system/"
  cp named-reload.service "$pkgdir/etc/systemd/system/"
  cp -r named-config-grug "$pkgdir/etc/named-config-grug"
}
