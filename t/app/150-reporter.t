#! perl -w
use strict;

use Test::More 'no_plan';

use File::Spec::Functions;
use Test::Smoke::App::Options;
use Test::Smoke::App::Reporter;

my $ddir = 't';
{
    fake_out($ddir);
    local @ARGV = ('-d', $ddir);
    my $app = Test::Smoke::App::Reporter->new(
        Test::Smoke::App::Options->reporter_config()
    );
    isa_ok($app, 'Test::Smoke::App::Reporter');
}

# done_testing();
END { unlink catfile($ddir, Test::Smoke::App::Options->outfile->default) }

sub fake_out {
    my $outfile = catfile(shift, Test::Smoke::App::Options->outfile->default);
    open my $fh, '>', $outfile or die "Cannot create($outfile): $!";
    print $fh <<"    EOH";
Started smoke at 1370775768
Smoking patch 5f425cbef56bf693b214e78fe4ac4fbc3cba54d9 v5.19.0-450-g5f425cb
Smoking branch blead
Stopped smoke at 1370775768
Started smoke at 1370775768

Configuration: -Dusedevel -Duse64bitint
------------------------------------------------------------------------------

Compiler info: cc version Sun C 5.12 SunOS_i386 2011/11/16
TSTENV = stdio  u=4.55  s=2.31  cu=304.84  cs=32.93  scripts=2193  tests=680120

Inconsistent test results (between TEST and harness):
    ../t/cpan/Socket/t/getnameinfo.t........ ..................................... FAILED at test 10
    ../t/porting/pending-author.t........... ...................................... FAILED at test 1

TSTENV = perlio u=4.02  s=2.20  cu=277.19  cs=28.62  scripts=2194  tests=680289

Inconsistent test results (between TEST and harness):
    ../t/cpan/Socket/t/getnameinfo.t........ ..................................... FAILED at test 10
    ../t/porting/pending-author.t........... ...................................... FAILED at test 1

TSTENV = locale:en_US.UTF-8     u=4.02  s=2.32  cu=283.41  cs=29.00  scripts=2192  tests=680181

Inconsistent test results (between TEST and harness):
    ../t/cpan/Socket/t/getnameinfo.t........ ..................................... FAILED at test 10
    ../t/porting/pending-author.t........... ...................................... FAILED at test 1

Finished smoking 5f425cbef56bf693b214e78fe4ac4fbc3cba54d9 v5.19.0-450-g5f425cb blead
Stopped smoke at 1370777975
    EOH
    close $fh;
}
