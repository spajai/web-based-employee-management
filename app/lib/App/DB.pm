package App::DB;

# Postgres database configuration
use strict;
use warnings;
use File::FindLib 'lib';

use App::Conf;
require DBI;
sub new {
    my $class = shift;
    return bless({}, $class);
}

# connect to Postgres database
sub connect_db {
    my $self     = shift;
    my $c        = App::Conf->new();
    my $dsn      = $c->{database_dsn};
    my $username = $c->{database_user};
    my $password = $c->{database_pw};
    my %attr     = (
        PrintError           => 0,    # turn off error reporting via warn()
        RaiseError           => 1,    # turn on error reporting via die()
        AutoCommit           => 1,
        mysql_auto_reconnect => 1,
    );
    return DBI->connect($dsn, $username, $password, \%attr) || die "Unable to connect to DB $@";
}

1;

##########################
# Auther  :- spajai
# Created :- 07/24/2019
##########################