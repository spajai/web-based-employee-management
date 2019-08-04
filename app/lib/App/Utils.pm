package App::Utils;

use strict;
use warnings;

use File::FindLib 'lib';
use DateTime;
# use URL::Encode qw (url_encode);
# use URL::Encode;

use App::DB;
use App::Conf;

sub new {
    return bless(
        {
            _db   => App::DB->new->connect_db(),
            _conf => App::Conf->new,
        },
        shift
    );
}

sub today {
    my $self   = shift;
    my $method = shift || 0;
    my $dt     = DateTime->today;
    return $method ? $dt : $dt->date;
}

sub parse_datetime {
    my ($self, $date) = (@_);
    # return DateTime::Format::Flexible->parse_datetime($date);
}

sub to_db_timestamp {
    return shift->parse_datetime(@_)->datetime;
}

sub send_to_db {
    my ($self,$param) = (@_);

    my $action = $param->{action};
    my $stmt   = $param->{stmt};
    my $entity = $param->{entity};
    my $bind   = $param->{bind};
    my $output = $param->{output} // undef;

    my $dbh = $self->{_db}; #database handle
    my $sth = $dbh->prepare($stmt);

    my $result = {
        result  => 0,
        message => "Error occured while ${action}ing $entity",
    };

    eval {
        my $res = $sth->execute(@$bind);
        use Data::Dumper;
        print Dumper $stmt;
        
        $result->{output} = $res if (defined $output);
        $result->{result} = 1;
        $result->{message} = "$entity ${action}ed successfully";
    };

    #todo add logger
    if($@) {
        warn "$@";
    }

    return $result;
}

sub get_dbh { return shift->{_db}; }

sub selectrow_hashref {
    my ($self, $param) = (@_);

    my $action = $param->{action};
    my $stmt   = $param->{stmt};
    my $entity = $param->{entity};

    my $dbh = $self->{_db}; #database handle

    my $result;

    eval {
        $result = $dbh->selectrow_hashref($stmt);
    };

    #todo add logger
    if($@) {
        warn "$@";
    }

    return $result;

}

sub get_users {
    my $self = shift;
    my $type = shift || 'name';

    my $dev = $self->{_db}->selectcol_arrayref("select user_id,name from users", { Columns => [ 1, 2 ] }) || [];
    # my %dev_hash = @$dev;

    # my @dev_list = (lc($type) eq 'id') ? (sort keys %dev_hash) : (sort values %dev_hash);

    # return wantarray ? @dev_list : \%dev_hash;
}

1;