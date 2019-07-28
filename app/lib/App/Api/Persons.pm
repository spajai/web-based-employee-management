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
    my $result;
    my $sql = $self->_get_query();

    # $result = $dbh->selectall_hashref($sql,"id");
    $result = $dbh->selectall_arrayref( $sql );

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

    if ( !$result->{result} ) {
        my $stmt = $self->_create_query();
        #Push the bind values dont change the position
        my @bind;
        push (@bind, 'person'                             );     #entity_name
        push (@bind, $data->{email_address}               );     #object_name
        push (@bind, $data->{comments}       || ''        );     #comment
        push (@bind, $data->{salutation}                  );
        push (@bind, $data->{first_name}     || ''        );
        push (@bind, $data->{last_name}                   );
        push (@bind, $data->{middle_name}                 );
        push (@bind, $data->{nick_name}                   );
        push (@bind, $data->{honorific}                   );
        push (@bind, $data->{email_address}               );
        push (@bind, $data->{phone_id}                    );
        push (@bind, $data->{sms_id}                      );
        push (@bind, $data->{note_id}                     );
        push (@bind, $data->{managed_by}                  );
        push (@bind, $data->{timezone}                    );
        push (@bind, $data->{is_locked}                   );
        push (@bind, $data->{is_active}                   );
        push (@bind, $data->{created_by}                  );

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

        #where clause we dont update email_address
        my $where = { email_address => delete $data->{email_address} };
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
    my $where = { email_address => $data->{email_address} };

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

    my $persons = App::Validation::Persons->new();
    my $js_profile = $persons->plugin('javascript_objects')->render(
        namespace => 'model',
        fields    => [$persons->fields->keys],
        include   => [qw/required min_length max_length messages pattern/]
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

    # select 1 from persons where email_address = $data->{email_address};

    my ( $stmt, @bind ) = $sql->select( $self->{table}, ['1'], { email_address => $data->{email_address} });

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
        select 
            salutation, first_name, last_name, middle_name, nick_name, honorific, email_address, phone_id, sms_id, note_id, managed_by, timezone, is_locked, is_active, created_by
        from 
            persons;
    );

    return $sql;
}
1;