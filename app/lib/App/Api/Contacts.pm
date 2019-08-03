package App::Api::Contacts;

use strict;
use warnings;
use File::FindLib 'lib';
use SQL::Abstract;
use App::Validation::Contacts;
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
    return bless( { table => "contacts", _utils => App::Utils->new() }, shift );
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
    ( $result->{result}, $result->{message} ) = $self->_contact_exists( $data );
    return $result if ( $result->{result} == -1 );

    if ( !$result->{result} ) {
        my $stmt = $self->_create_query();
        #Push the bind values dont change the position
#short_name distinct
#insert into note as well get the id

        my @bind;
        push (@bind, 
            'contact'                           ,     #entity_name
            'contact'                           ,     #entity_name #verify 
            $data->{comments}        || ''      ,     #comment
            $data->{short_name}                 ,
            $data->{description}     || ''      ,
            $data->{person_id}                  ,
            $data->{address_list_id}            ,
            $data->{note_id}                    ,
            $data->{is_active}                  ,
        );

        my $param = {
            action => 'creat',
            stmt   => $stmt,
            bind   => [@bind],
            entity => 'Contact'
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

    ( $result->{result}, $result->{message} ) = $self->_contact_exists( $data );

    if ( $result->{result} == -1 ) {
        my $sql = SQL::Abstract->new;
        my $where = $data;
        my ( $stmt, @bind ) = $sql->update( $self->{table}, $data,$where);

        my $param = {
            action => 'updat',
            stmt   => $stmt,
            bind   => [@bind],
            entity => 'Contact'
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
    ( $result->{result}, $result->{message} ) = $self->_validate_data( $data );

    #invalid request
    return $result unless ( $result->{result} );

    #go ahead and delete
    my $sql   = SQL::Abstract->new;
    my $where = $data;

    $data = { "is_active" => 0 };
    my ( $stmt, @bind ) = $sql->update( $self->{table}, $data, $where );
    my $param = {
        action => 'delet',
        stmt   => $stmt,
        bind   => [@bind],
        entity => 'Contact'
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

sub _contact_exists {
    my ( $self, $data ) = @_;

    #get db connection and check person

    my $result;

    my $sql = SQL::Abstract->new;

    #to avoid duplciate since we dont have unique combination

    # select 1 from contacts where short_name = <value> 
 
    #remove
 #and description =<value> and person_id = <value> and address_list_id = <value> and note_id = <value> and is_active = <value>;

    my ( $stmt, @bind ) = $sql->select( $self->{table}, ['1'], $data);

    my $param = {
        action => 'select',
        stmt   => $stmt,
        bind   => [@bind],
        entity => 'Contact',
        output => 1,          #since we need output
    };

    $result = $self->{_utils}->send_to_db( $param );    #execute on db

    if ( $result->{output} eq '0E0' ) {
        $result->{result}  = 0;
        $result->{message} = "Contact not exists";

    } elsif ( $result->{output} == 1 ) {
        $result->{result}  = -1;
        $result->{message} = "Contact already exists";
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

    my $contacts = App::Validation::Contacts->new( %$data_copy );
    if ( defined $fields && ref $fields eq 'ARRAY' ) {

        #validated given fields only
        unless ( $contacts->validate( @$fields ) ) {
            $valid   = 0;
            $message = $contacts->errors_to_string;
        }
    } else {
        unless ( $contacts->validates( $contacts->fields->keys ) ) {
            $valid   = 0;
            $message = $contacts->errors_to_string;
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
sub js_validation_data {
    my ( $self ) = @_;

    my $contacts = App::Validation::Contacts->new();
    my $js_profile = $contacts->plugin('javascript_objects')->render(
        namespace => 'model',
        fields    => [$contacts->fields->keys],
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

sub _create_query {

    my $binds_symbol = join (',' , ( ('?') x 6 ));
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
            contacts
                (entity_id, short_name, description, person_id, address_list_id, note_id, is_active)
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
         select array_to_json(array_agg(row_to_json(contact_data))) as data
        from (
            select 
                id, entity_id, short_name, description, person_id, address_list_id, note_id, is_active
            from 
                contacts
            order by 
                id asc
        ) contact_data;
    );

    return $sql;
}
1;