
# answer to http://stackoverflow.com/questions/6579495/how-to-concatenate-pathname-and-relative-pathname

use Test::More;

use File::Spec::Win32;
use File::Spec::Unix;

is(File::Spec::Win32->catdir('dir1/dir2/dir3', '../filename')
    => 'dir1\\dir2\\filename');
is(File::Spec::Win32->catdir('dir1/dir2/dir3', '../../filename')
    => 'dir1\\filename');

is(File::Spec::Unix->catdir('dir1/dir2/dir3', '../filename')
    => 'dir1/dir2/dir3/../filename');
is(File::Spec::Unix->catdir('dir1/dir2/dir3', '../../filename', )
    => 'dir1/dir2/dir3/../../filename');

done_testing;
