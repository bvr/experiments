
use 5.10.1; use strict; use warnings;

use Win32API::File qw(getLogicalDrives GetVolumeInformation);
use Data::Dump     qw(dd pp);

dd(get_drives_w_info());

sub get_drives_w_info {
    my @ret = ();
    my @drives = getLogicalDrives();
    foreach my $d (@drives) {
        my @x = (undef) x 7;
        GetVolumeInformation($d, @x);
        push @ret, {
            drive    => $d,
            name     => $x[0],
            fs_name  => $x[5],
            fs_flags => decode_fs_flags($x[4]),
        };
    }
    return @ret;
}

sub decode_fs_flags {
    my ($fs_flags) = @_;

    my %flags_bin = (
        FILE_CASE_PRESERVED_NAMES         => 0x00000002,
        FILE_CASE_SENSITIVE_SEARCH        => 0x00000001,
        FILE_FILE_COMPRESSION             => 0x00000010,
        FILE_NAMED_STREAMS                => 0x00040000,
        FILE_PERSISTENT_ACLS              => 0x00000008,
        FILE_READ_ONLY_VOLUME             => 0x00080000,
        FILE_SEQUENTIAL_WRITE_ONCE        => 0x00100000,
        FILE_SUPPORTS_ENCRYPTION          => 0x00020000,
        FILE_SUPPORTS_EXTENDED_ATTRIBUTES => 0x00800000,
        FILE_SUPPORTS_HARD_LINKS          => 0x00400000,
        FILE_SUPPORTS_OBJECT_IDS          => 0x00010000,
        FILE_SUPPORTS_OPEN_BY_FILE_ID     => 0x01000000,
        FILE_SUPPORTS_REPARSE_POINTS      => 0x00000080,
        FILE_SUPPORTS_SPARSE_FILES        => 0x00000040,
        FILE_SUPPORTS_TRANSACTIONS        => 0x00200000,
        FILE_SUPPORTS_USN_JOURNAL         => 0x02000000,
        FILE_UNICODE_ON_DISK              => 0x00000004,
        FILE_VOLUME_IS_COMPRESSED         => 0x00008000,
        FILE_VOLUME_QUOTAS                => 0x00000020,
    );

    my @present_flags = ();
    for my $fl (sort keys %flags_bin) {
        push @present_flags, $fl
            if $flags_bin{$fl} & $fs_flags;
    }
    return join ' | ', @present_flags;
}

__END__
BOOL WINAPI GetVolumeInformation(
  _In_opt_   LPCTSTR lpRootPathName,

  [0] _Out_opt_  LPTSTR lpVolumeNameBuffer,
  [1] _In_       DWORD nVolumeNameSize,
  [2] _Out_opt_  LPDWORD lpVolumeSerialNumber,
  [3] _Out_opt_  LPDWORD lpMaximumComponentLength,
  [4] _Out_opt_  LPDWORD lpFileSystemFlags,
  [5] _Out_opt_  LPTSTR lpFileSystemNameBuffer,
  [6] _In_       DWORD nFileSystemNameSize
);
