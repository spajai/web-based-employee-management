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

sub validate_credential {
    my $self = shift;
    my $user = shift || undef;
    my $pass = shift || undef;
    my $db   = $self->{_db};

    my ($user_db, $pass_db) = $db->selectrow_array("select user_id,pass from dashboard_admin where user_id = '$user'");
    my $valid = Core->new->valid_pass($pass_db, $pass);
    return ($user_db, $valid);

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
    my $result;
    $result->{result} = 0;
    $result->{message} = "Error occured while ${action}ing $entity";
    eval {
        my $res = $sth->execute(@$bind);
        $result->{output} = $res if (defined $output);
        $result->{result} = 1;
        $result->{message} = "$entity ${action}ed successfully";
    };

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