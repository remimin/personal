Name:           ssdb
Version:        1.9.4
Release:        1%{?dist}
Summary:        ssdb-server

License:        Author Liscense
URL:            https://github.com/ideawu/ssdb
Source0:        ssdb.tar.gz

%description
build ssdb rpm package

%prep
%setup -q


%build
make

%install
make install PREFIX=${RPM_BUILD_ROOT}
ln -sf /var/ssdb/ssdb-cli ${RPM_BUILD_ROOT}%{_bindir}/ssdb-cli
ln -sf /var/ssdb/ssdb-server ${RPM_BUILD_ROOT}%{_bindir}/ssdb-server
ln -sf /var/ssdb/ssdb-bench ${RPM_BUILD_ROOT}%{_bindir}/ssdb-bench
ln -sf /var/ssdb/ssdb-repair ${RPM_BUILD_ROOT}%{_bindir}/ssdb-repair

%files
%defattr(-,root,root)
/usr/bin/*
/var/ssdb
/etc/ssdb
%doc



%changelog
