#!/group/bioinfo/apps/apps/perl-5.20.1/bin/perl

use feature qw{ say state } ;
use strict ;
use warnings ;
use Data::Dumper ;

use lib '/depot/gcore/apps/lib/' ;
use oDB ;

use Globus ;

my $g        = Globus->new() ;
my $username = 'jacoby' ;
$g->set_username($username) ;
$g->set_key_path('/home/djacoby/.ssh/id_globus') ;

my $root     = '/depot/gcore/web/users/' ;
my $d        = oDB->new('genomics') ;
my $q        = <<SQL;
        SELECT * FROM projects ORDER BY pi_id,request_id
SQL
my $projects = $d->arrayref( $q, { controls => {} } ) ;

# create a shared endpoint for each directory

my @endpoints = $g->endpoint_list() ;
my %endpoints = map { $_ => 1 } @endpoints ;

for my $p (@$projects) {
    state $c = 0 ;
    next if $c > 3 ;
    next if $p->{is_old_system} ;
    $c++ ;
    my $request_id = $p->{request_id} ;
    my $end        = $p->{project_name} ;
    my $endpoint   = join '#', $username, $end ;
    my $directory  = $root . $p->{project_path} . '/' ;
    say '=' x 60 ;
    say $endpoint ;
    say '-' x 60 ;

    unless ( $endpoints{$endpoint} ) {
        $g->endpoint_add_shared( 'purdue#rcac', $directory, $end ) ;
        $g->acl_add( $endpoint . '/', 'djacoby@purdue.edu' ) ;
        say 'added' ;
        }

    # if ( $endpoints{$endpoint} ) {
    #     say "\tNuking\t" . $endpoint ;
    #     my ( $username, $end ) = split m{#}, $endpoint ;
    #     $g->endpoint_remove($end) ;
    #     }

    say '' ;

    # say $endpoint ;
    # say $directory ;
    # say Dumper $p ;
    # exit;
    }

exit ;

{
    for my $dir (qw{ gcalcli genomics }) {
        my $end       = uc $dir ;
        my $directory = join '/', '', 'home', 'djacoby', 'dev', $dir, '' ;
        my $endpoint  = join '#', $username, $end ;
        $g->endpoint_add_shared( 'purdue#rcac', $directory, $end ) ;
        $g->acl_add( $endpoint . '/', 'jacoby.david@gmail.com' ) ;

        say '=' x 60 ;
        say $endpoint ;
        say '-' x 60 ;

        for my $node ( $g->ls( $endpoint . '/' ) ) { say "\t", $node }

        say '-' x 60 ;

        my @out = $g->acl_list($endpoint) ;
        for my $acl (@out) {
            my ( $principal, $id, $permissions )
                = map { $acl->{$_} } qw{principal id permissions} ;
            say join "\t", $endpoint, $id, $permissions, $principal, ;
            next ;
            if ( $principal ne 'jacoby' ) { $g->acl_remove( $endpoint, $id ) }
            }
        say '' ;
        }
    my @endpoints = $g->endpoint_list() ;
    for my $endpoint (@endpoints) {
        next if $endpoint !~ m{jacoby} ;
        next if $endpoint =~ m{Lion} ;
        say "\tNuking\t" . $endpoint ;
        my ( $username, $end ) = split m{#}, $endpoint ;
        $g->endpoint_remove($end) ;
        }
    }

say '' ;
exit ;
