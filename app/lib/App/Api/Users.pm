use strict;
use warnings;
use File::FindLib 'lib';
use lib '.';
use SQL::Abstract;
use App::Validation::Users;


#constructor

sub new {
    return bless ({table => "users" },shift);
}

sub insert {
    my ($self,$data) = (@_);

    my $result;

    ($result->{result}, $result->{message}) =  $self->_validate_data($data);

    #invalid request
    return if ($result->{result});

    $self->_user_exists($data);

}

sub update {
    my ($self,$data) = (@_);

    my $result;

    ($result->{result}, $result->{message}) =  $self->_validate_data($data);

    #invalid request
    return if ($result->{result});

   ($result->{result}, $result->{message}) =  $self->_user_exists($data);

    if ($result->{result} == 1 ) {
        #go ahead and update 

    }

}

sub delete  {
    my ($self,$data) = (@_);

    my $result;

    ($result->{result}, $result->{message}) =  $self->_validate_data($data);

    #invalid request
    return if ($result->{result});

   ($result->{result}, $result->{message}) =  $self->_user_exists($data);

    if ($result->{result} == 1 ) {
        #go ahead and delete 
        my $sql = SQL::Abstract->new;
        my($stmt, @bind) = $sql->delete($self->{table}, \%where);

    }

    $result;

}



sub _user_exists {
    my ($self,$data) = @_;
 
    #get db connection and check username
 
    my $result;

    my $sql = SQL::Abstract->new;

    # select 1 from users where username = $data->{username};

    my($stmt, @bind) = $sql->select($self->{table}, [1],{username => $data->{username}});

    my $sth = $dbh->prepare($stmt);

    $sth->execute(@bind);

    #change ds here.


    if( ###exist? ) {

        $result->{result} = 1;
        $result->{message} = "'$data->{username}' already exists";

    } else {

        $result->{result} = 0;
        $result->{message} = "'$data->{username}' not exists";

    }

    return $result;
}

sub _validate_data {
    my ($self,$data,$action) = @_;

    my ($valid,@messages) = (0, undef);

    push (@messages, "Invalid Request Required Parameters Missing");

    return ($valid,\@messages) unless (keys %$data);

    my $users = App::Validation::Users->new;
    my $users_rules = $users->rules();

    # manipulate the rule depending on $action

    unless ($users->validate_document($users_rules => $data)) {
        if ($users->error_count) {
            $valid = 0;
            push (@messages,$users->errors_to_string);
        }
    }

    return ($valid,\@messages);
}

1;