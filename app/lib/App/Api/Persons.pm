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

# ========================================================================== #

=item B<new>

Params : NA

Returns: 

Desc   : 

=cut

sub new {
    return bless( { table => "persons", _utils => App::Utils->new() }, shift );
}

# ========================================================================== #

=item B<>

Params : NA

Returns: 

Desc   : 

=cut

sub get {
    my ( $self, $param ) = ( @_ );

    my $dbh = $self->{_utils}->get_dbh();    #get dbh

    my $sql = $self->_get_query();

    my $result = $dbh->selectrow_hashref($sql);

    $result->{validation_profile} = $self->js_validation_data();

    return $result;
}

# ========================================================================== #

=item B<>

Params : NA

Returns: 

Desc   : 

=cut

sub create {
    my ( $self, $data ) = ( @_ );

    my $result;

    ( $result->{result}, $result->{message} ) = $self->_validate_data( $data );

    #invalid request
    return $result unless ( $result->{result} );

    #check if person exists
    ( $result->{result}, $result->{message} ) = $self->_person_exists( $data );
    return $result if ( $result->{result} == -1 );

#TODO:-
#update note_id sms phone

    if ( !$result->{result} ) {
        my $stmt = $self->_create_query();
        #Push the bind values dont change the position
        my @bind;
        my $object_name = $data->{first_name}.$data->{middle_name}.$data->{last_name}."<$data->{email_address}>";
        push (@bind,                              
             'person'                             ,    #entity_name
             $object_name                         ,    #object_name
             $data->{comments}       || ''        ,    #comment
             $data->{salutation}                  ,
             $data->{first_name}     || ''        ,
             $data->{last_name}                   ,
             $data->{middle_name}                 ,
             $data->{nick_name}                   ,
             $data->{honorific}                   ,
             $data->{email_address}               ,
             $data->{phone_id}                    ,
             $data->{sms_id}                      ,
             $data->{note_id}                     ,
             $data->{managed_by}                  ,
             $data->{timezone}                    ,
             $data->{is_locked}                   ,
             $data->{is_active}                   ,
             $data->{created_by}                  ,
        );
        my $param = {
            action => 'creat',
            stmt   => $stmt,
            bind   => [@bind],
            entity => 'Person'
        };

        $result = $self->{_utils}->send_to_db( $param );    #execute on db

    }

    return $result;
}

# ========================================================================== #

=item B<>

Params : NA

Returns: 

Desc   : 

=cut

sub update {
    my ( $self, $data ) = ( @_ );

    my $result;

    # ( $result->{result}, $result->{message} ) = $self->_validate_data( $data, ['email_address'] );
    ( $result->{result}, $result->{message} ) = $self->_validate_data( $data,);

    #invalid request
    return $result unless ( $result->{result} );

    ( $result->{result}, $result->{message} ) = $self->_person_exists( $data );

    if ( $result->{result} == -1 ) {
        my $sql = SQL::Abstract->new;

        #where clause we dont update email_address last_name first_name middle_name
        my $where = {
            email_address  => delete $data->{email_address},
            last_name      => delete $data->{last_name},
            first_name     => delete $data->{first_name},
            middle_name    => delete $data->{middle_name},
        };

        my ( $stmt, @bind ) = $sql->update( $self->{table}, $data, $where );

        my $param = {
            action => 'updat',
            stmt   => $stmt,
            bind   => [@bind],
            entity => 'Person'
        };

        $result = $self->{_utils}->send_to_db( $param );    #execute on db
    }

    return $result;

}

# ========================================================================== #

=item B<>

Params : NA

Returns: 

Desc   : 

=cut

sub delete {
    my ( $self, $data ) = ( @_ );

    my $result;

    #validate only email_address
    ( $result->{result}, $result->{message} ) = $self->_validate_data( $data, ['email_address'] );

    #invalid request
    return $result unless ( $result->{result} );

    #go ahead and delete
    my $sql   = SQL::Abstract->new;
    my $where = {
        id             => delete $data->{id},
        email_address  => delete $data->{email_address},
        last_name      => delete $data->{last_name},
        first_name     => delete $data->{first_name},
        middle_name    => delete $data->{middle_name},
    };
    $data = { "is_active" => 0 };
    my ( $stmt, @bind ) = $sql->update( $self->{table}, $data, $where );
    my $param = {
        action => 'delet',
        stmt   => $stmt,
        bind   => [@bind],
        entity => 'Person'
    };

    $result = $self->{_utils}->send_to_db( $param );    #execute on db

    $result;

}
# ========================================================================== #

=item B<>

Params : NA

Returns: 

Desc   : 

=cut
sub js_validation_data {
    my ( $self ) = @_;

    my $js_validation_data;
    my $users = App::Validation::Users->new();
    my $js_profile = $users->plugin('javascript_objects')->render(
        namespace => 'model',
        fields    => [$users->fields->keys],
        include   => [qw/required min_length max_length messages/]
    );
      return $js_profile;
}

# ========================================================================== #

=item B<>

Params : NA

Returns: 

Desc   : 

=cut

sub _person_exists {
    my ( $self, $data ) = @_;

    #get db connection and check person

    my $result;

    my $sql = SQL::Abstract->new;
    #todo fname lname and middle and email
    # select 1 from persons where email_address = $data->{email_address};
    my $where = {
        email_address  => $data->{email_address},
        last_name      => $data->{last_name},
        first_name     => $data->{first_name},
        middle_name    => $data->{middle_name},
    };
    my ( $stmt, @bind ) = $sql->select( $self->{table}, ['1'], $where);

    my $param = {
        action => 'select',
        stmt   => $stmt,
        bind   => [@bind],
        entity => 'Person',
        output => 1,          #since we need output
    };

    $result = $self->{_utils}->send_to_db( $param );    #execute on db

    if ( $result->{output} eq '0E0' ) {
        $result->{result}  = 0;
        $result->{message} = "Person with email $data->{email_address} not exists";

    } elsif ( $result->{output} == 1 ) {
        $result->{result}  = -1;
        $result->{message} = "Person with email $data->{email_address} already exists";
    }

    return ( $result->{result}, $result->{message} );
}

# ========================================================================== #

=item B<>

Params : NA

Returns: 

Desc   : 

=cut

sub _validate_data {
    my ( $self, $data, $fields ) = @_;

    my $valid = 0;

    my $message = "Invalid Request Required Parameters Missing";

    return ( $valid, $message ) unless ( keys %$data );

    $valid   = 1;       #validation will set this flag off
    $message = undef;
    my $data_copy = clone( $data );

    my $persons = App::Validation::Persons->new( %$data_copy );
    if ( defined $fields && ref $fields eq 'ARRAY' ) {

        #validated given fields only
        unless ( $persons->validate( @$fields ) ) {
            $valid   = 0;
            $message = $persons->errors_to_string;
        }
    } else {
        unless ( $persons->validates( $persons->fields->keys ) ) {
            $valid   = 0;
            $message = $persons->errors_to_string;
        }
    }

    return ( $valid, $message );
}

# ========================================================================== #

=item B<>

Params : NA

Returns: 

Desc   : 

=cut

sub _create_query {

    my $binds_symbol = join (',' , ( ('?') x15 ));
    my $sql =qq(
    with entity_object as (
            select
                id
            FROM
                entity_objects
            where
                lower(object_name) = ?
        ), entity_id as (
                insert into
                    entity
                        (entity_object,entity_name,comments)
                        select (select id from entity_object ) as entity_object, ?, ?
                RETURNING
                    id
        ) INSERT into
            persons
                (entity_id, salutation, first_name, last_name, middle_name, nick_name, honorific, email_address, phone_id, sms_id, note_id, managed_by, timezone, is_locked, is_active, created_by)
                select (select id from entity_id) as entity_id, $binds_symbol;
    );
    return $sql;
}

# ========================================================================== #

=item B<>

Params : NA

Returns: 

Desc   : 

=cut

sub _get_query {
 
    my $sql = q(
        select array_to_json(array_agg(row_to_json(person_data))) as data
                from (
                    select
                        salutation, first_name, last_name, middle_name, nick_name, honorific, email_address, phone_id, sms_id, note_id, managed_by, timezone, is_locked, is_active, created_by
                    from
                        persons
                    order by
                        id asc
        ) person_data;
    );

    return $sql;
}
1;