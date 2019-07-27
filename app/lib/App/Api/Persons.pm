package App::Api::Persons;

use strict;
use warnings;
use File::FindLib 'lib';
use SQL::Abstract;
use App::Validation::Persons;
use App::Utils;
#constructor
use Data::Dumper;
use Clone qw<clone>;

sub new {
    return bless ( { table => "persons", _utils => App::Utils->new() }, shift );
}

sub create {
    my ($self,$data) = (@_);

    my $result;

    ($result->{result}, $result->{message}) =  $self->_validate_data($data);

    #invalid request
    return $result unless ($result->{result});

    #check if Persons exists
    ($result->{result}, $result->{message}) = $self->_user_exists($data);
    return $result if ($result->{result} == -1);

    if (!$result->{result}) {

        my $sql = SQL::Abstract->new;
        my($stmt, @bind) = $sql->insert($self->{table}, $data);

        my $param = {
            action => 'create',
            stmt   => $stmt,
            bind   => [@bind],
            entity => 'Person'
        };

        $result = $self->{_utils}->send_to_db($param); #execute on db

    }

    return $result;
}

sub update {
    my ($self, $data) = (@_);

    my $result;

    ($result->{result}, $result->{message}) = $self->_validate_data($data);
    #invalid request
    return $result unless ($result->{result});

   ($result->{result}, $result->{message}) = $self->_user_exists($data);

    if ($result->{result} == -1 ) {
        my $sql = SQL::Abstract->new;
        #where clause we dont update username
        my $where = { username => delete $data->{username}};
        my($stmt, @bind) = $sql->update($self->{table}, $data, $where);

        my $param = {
            action => 'updat',
            stmt   => $stmt,
            bind   => [@bind],
            entity => 'User'
        };

        $result = $self->{_utils}->send_to_db($param); #execute on db
    }

    return $result;

}

sub delete {
    my ($self,$data) = (@_);

    my $result;
    #validate only user_name
    ($result->{result}, $result->{message}) =  $self->_validate_data($data,['username']);

    #invalid request
    return $result unless ($result->{result});

    #go ahead and delete 
    my $sql = SQL::Abstract->new;
    my $where = {username => $data->{username}};
    my($stmt, @bind) = $sql->delete($self->{table}, $where);
    my $param = {
        action => 'delet',
        stmt   => $stmt,
        bind   => [@bind],
        entity => 'User'
    };

    $result = $self->{_utils}->send_to_db($param); #execute on db

    $result;

}

sub _user_exists {
    my ($self,$data) = @_;

    #get db connection and check username

    my $result;

    my $sql = SQL::Abstract->new;

    # select 1 from users where username = $data->{username};

    my($stmt, @bind) = $sql->select($self->{table}, ['1'],{username => $data->{username} });

    my $param = {
        action => 'select',
        stmt   => $stmt,
        bind   => [@bind],
        entity => 'User',
        output => 1, #since we need output
    };

    $result = $self->{_utils}->send_to_db($param); #execute on db

    if( $result->{output} eq '0E0' ) {
        $result->{result} = 0;
        $result->{message} = "user $data->{username} not exists";

    } else {
        $result->{result} = -1;
        $result->{message} = "user $data->{username} already exists";
    }

    return ($result->{result},$result->{message});
}


sub _validate_data {
    my ($self,$data ,$fields) = @_;

    my $valid = 0;

    my $message = "Invalid Request Required Parameters Missing";

    return ($valid,$message) unless (keys %$data);

    $valid = 1; #validation will set this flag off
    $message = undef;
    my $data_copy = clone ($data);

    my $users = App::Validation::Users->new(%$data_copy);
    if (defined $fields && ref $fields eq 'ARRAY') {
        #validated given fields only
        unless ($users->validate(@$fields)){
            $valid = 0;
            $message = $users->errors_to_string;
        }
    } else {
        unless ($users->validates($users->fields->keys)) {
            $valid = 0;
            $message = $users->errors_to_string;
        }
    }

    return ($valid,$message);
}

1;