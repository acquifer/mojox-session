use Test::More;

BEGIN {
    eval "use DBD::SQLite";
    plan skip_all => "DBD::SQLite is required to run this test" if $@;
}

use lib 't/lib';

plan tests => 11;

use_ok('MojoX::Session');
use_ok('MojoX::Session::Store::DBI');

use NewDB;

my $dbh = NewDB->dbh;

my $session =
  MojoX::Session->new(store => MojoX::Session::Store::DBI->new(dbh => $dbh));

# create
my $sid = $session->create();
ok($sid);
ok($session->flush);

# load
ok($session->load($sid));
is($session->sid, $sid);

# update
$session->data(foo => 'bar');
ok($session->flush);
ok($session->load($sid));
is($session->data('foo'), 'bar');

# delete
$session->expire;
ok($session->flush);
ok(not defined $session->load($sid));
