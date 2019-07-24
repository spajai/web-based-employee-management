package App::Conf;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self;

    # ---------------------------------------------------- #
    # database settings                                    #
    # ---------------------------------------------------- #

    # The database host
    $self->{database_host} = 'localhost';

    # The database name
    $self->{database_name} = 'chuck';

    # The database user
    $self->{database_user} = 'root';

    # The password of database user.
    $self->{database_pw} = 'root';

    # The database DSN for postgres ==> more: "perldoc DBD::Pg"
    $self->{database_dsn} = "DBI:Pg:database=$self->{database_name}";

    $self->{database_dsn} .= ";host=$self->{database_host};" if (defined $self->{database_host});

    # ---------------------------------------------------- #
    # app root directory avoid last '/'
    # ---------------------------------------------------- #

    $self->{home} = '/app';

    # ---------------------------------------------------- #
    #
    # Log4Perl config file location
    # ---------------------------------------------------- #

    $self->{db_logger}             = '/app/config/config/log4perl.conf';
    $self->{db_logger_name}        = 'dblog';

    # ---------------------------------------------------- #
    # Send email setting                                   #
    # ---------------------------------------------------- #

    ##see https://metacpan.org/pod/MIME::Lite#send
    #to configure according to os
    $self->{send_email} = [ "sendmail", "/usr/lib/sendmail -t -oi -oem" ];

    return bless($self, $class);
}

1;
##########################
# Auther  :- spajai
# Created :- 07/24/2019
##########################