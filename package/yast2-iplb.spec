#
# spec file for package yast2-cluster
#
# Copyright (c) 2013 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#



Name:           yast2-iplb
Version:        3.1.0
Release:        0
License:	GPL-2.0
Group:		System/YaST

BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Source0:        %{name}-%{version}.tar.bz2

Requires:	yast2
BuildRequires:	perl-XML-Writer update-desktop-files yast2 yast2-devtools yast2-testsuite

BuildArchitectures:	noarch

Requires:       yast2-ruby-bindings >= 1.0.0

Summary:	Configuration of iplb

%description
-

%prep
%setup -n %{name}-%{version}

%build
%yast_build

%install
%yast_install

%files
%defattr(-,root,root)
%dir @yncludedir@/iplb
@yncludedir@/iplb/*
@clientdir@/iplb.rb
@clientdir@/iplb_*.rb
@moduledir@/Iplb.*
@moduledir@/Iplb2.*
@desktopdir@/iplb.desktop
%doc @docdir@
