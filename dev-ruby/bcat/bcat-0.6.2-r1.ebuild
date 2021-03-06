# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20"

RUBY_FAKEGEM_TASK_DOC="man"
RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="Pipe to browser utility for use at the shell and within editors"
HOMEPAGE="https://github.com/rtomayko/bcat"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

# Collides on /usr/bin/bcat, bug 418301
RDEPEND="${RDEPEND} !!<app-accessibility/speech-tools-2.1-r3"

ruby_add_bdepend "doc? ( app-text/ronn )"

ruby_add_rdepend "dev-ruby/rack"

each_ruby_prepare() {
	sed -i -e "s/a2h/#{ENV['RUBY']} -S a2h/" test/test_bcat_a2h.rb || die
}

each_ruby_test() {
	# The Rakefile uses weird trickery with load path that causes gems
	# not to be found. Run tests directly instead and do the trickery
	# here to support popen calls for the bins in this package.
	RUBY=${RUBY} RUBYLIB=lib:${RUBYLIB} PATH=bin:${PATH} ${RUBY} -S testrb test/test_*.rb || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/*.1
}
