# -*-makefile-*-
#
# Copyright (C) 2022 by <Falk Werner>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_HELLO) += hello

#
# Paths and names
#
HELLO_VERSION	:= 1.0.0
HELLO		:= hello-$(HELLO_VERSION)
HELLO_URL		:= file://local_src/hello
HELLO_DIR		:= $(BUILDDIR)/$(HELLO)
HELLO_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(HELLO_SOURCE):
#	@$(call targetinfo)
#	@$(call get, HELLO)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#HELLO_CONF_ENV	:= $(CROSS_ENV)

#
# cmake
#
HELLO_CONF_TOOL	:= cmake
#HELLO_CONF_OPT	:= $(CROSS_CMAKE_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/hello.targetinstall:
	@$(call targetinfo)

	@$(call install_init, hello)
	@$(call install_fixup, hello, PRIORITY, optional)
	@$(call install_fixup, hello, SECTION, base)
	@$(call install_fixup, hello, AUTHOR, "<Falk Werner>")
	@$(call install_fixup, hello, DESCRIPTION, missing)

#	# This is an example only. Adapt it to your requirements. Read the
#	# documentation's section "Make it Work" in chapter "Adding new Packages"
#	# how to prepare this content or/and read chapter
#	# "Rule File Macro Reference" to get an idea of the available macros
#	# you can use here and how to use them.

	@$(call install_copy, hello, 0, 0, 0755, -, /usr/bin/hello)

	@$(call install_finish, hello)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/hello.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, HELLO)

# vim: syntax=make
