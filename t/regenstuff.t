#! perl -w
use strict;

use FindBin;
use lib $FindBin::Bin;
use TestLib;

use Test::More 'no_plan';

BEGIN { 
    use_ok( 'Test::Smoke::Util', qw( get_regen_headers run_regen_headers ) );
}

my $ddir = File::Spec->catdir( $FindBin::Bin, 'perl-current' );
mkpath( $ddir ) or die "Cannot mkpath($ddir): $!";

{
    my $regen = get_regen_headers( $ddir );
    is( $regen, undef, "Found none" );
}

SKIP: { # Find 'regen_headers.pl'
    my $to_skip = 2;
    local *FILE;
    my $regen_headers_pl = File::Spec->catfile( $ddir, 'regen_headers.pl' );
    open( FILE, "> $regen_headers_pl" ) 
        or skip "Cannot create '$regen_headers_pl': $!", $to_skip;
    print FILE <<EO_REGEN;
#! $^X -w
print "This is '$regen_headers_pl'"
EO_REGEN

    close FILE or skip "Cannot write '$regen_headers_pl': $!", $to_skip;

    my $regen = get_regen_headers( $ddir );

    is( $regen, "$^X $regen_headers_pl", "Found '$regen'" )
        or skip "Not found [$regen_headers_pl]", --$to_skip;

    local *REGENRUN;
    if ( ok open( REGENRUN, "$regen |" ), "Start pipe" ) {
        my $output = <REGENRUN>;
        close REGENRUN;
        is( $output, "This is '$regen_headers_pl'",
            "Run regen_headers manually" );
    } else {
        skip "Could not run regen_headers", $to_skip--;
    }
}

SKIP: { # Prefer 'regen_headers.pl' over 'regen.pl'
    my $to_skip = 2;
    local *FILE;
    my $regen_headers_pl = File::Spec->catfile( $ddir, 'regen_headers.pl' );
    my $regen_pl = File::Spec->catfile( $ddir, 'regen.pl' );
    open( FILE, "> $regen_pl" ) 
        or skip "Cannot create '$regen_pl': $!", $to_skip;
    print FILE <<EO_REGEN;
#! $^X -w
print "This is '$regen_pl'"
EO_REGEN

    close FILE or skip "Cannot write '$regen_pl': $!", $to_skip--;

    my $regen = get_regen_headers( $ddir );

    is( $regen, "$^X $regen_headers_pl", "Found '$regen'" )
        or skip "Not found [$regen_headers_pl]", $to_skip--;

    local *REGENRUN;
    if ( ok open( REGENRUN, "$regen |" ), "Start pipe" ) {
        my $output = <REGENRUN>;
        close REGENRUN;
        is( $output, "This is '$regen_headers_pl'",
            "Run regen_headers manually" );
    } else {
        skip "Could not run regen_headers", $to_skip--;
    }
}

SKIP: { # as of 18852: 'regen_headers.pl' is now 'regen.pl'
    my $to_skip = 2;
    my $regen_headers_pl = File::Spec->catfile( $ddir, 'regen_headers.pl' );
    my $regen_pl = File::Spec->catfile( $ddir, 'regen.pl' );

    unlink $regen_headers_pl 
        or skip "Cannot unlink($regen_headers_pl): $!", $to_skip--;

    my $regen = get_regen_headers( $ddir );

    is( $regen, "$^X $regen_pl", "Found '$regen'" )
        or skip "Not found [$regen_pl]", $to_skip--;

    local *REGENRUN;
    if ( ok open( REGENRUN, "$regen |" ), "Start pipe" ) {
        my $output = <REGENRUN>;
        close REGENRUN;
        is( $output, "This is '$regen_pl'",
            "Run regen_headers manually" );
    } else {
        skip "Could not run regen_headers", $to_skip--;
    }
}
    
END { -d $ddir and rmtree( $ddir ); }