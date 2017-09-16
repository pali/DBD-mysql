use strict;
use warnings;

use Test::More;
use DBI;
use DBI::Const::GetInfoType;
use lib 't', '.';
require 'lib.pl';
$|= 1;

use vars qw($test_dsn $test_user $test_password);

my $dbh = DbiTestConnect($test_dsn, $test_user, $test_password,
                      {
                          mysql_auto_reconnect  => 1,
                          RaiseError => 1,
                          PrintError => 1,
                          AutoCommit => 1 });

my $dbh2= DbiTestConnect($test_dsn, $test_user, $test_password);

plan tests => 5;

ok(defined $dbh, "Handle 1 Connected to database");
ok(defined $dbh2, "Handle 2 Connected to database");

#kill first db connection to trigger an auto reconnect
ok ($dbh2->do('kill ' . $dbh->{'mysql_thread_id'}));

#insert a temporary delay, try uncommenting this if it's not seg-faulting at first,
# one of my initial tests without this delay didn't seg fault
sleep 1;

#ping first dbh handle to trigger auto-reconnect
$dbh->ping;

ok ($dbh);
ok ($dbh2);
