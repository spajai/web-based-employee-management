package App::Api::Organizations;

use strict;
use warnings;
use File::FindLib 'lib';
use SQL::Abstract;
use App::Validation::Organizations;
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
    return bless( { table => "organizations", _utils => App::Utils->new() }, shift );
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

    # my $sth = $dbh->prepare($sql);
    # $sth->execute;
    # while (my $row = $sth->fetchrow_hashref())
    # {print Dumper $row;}

    # $result = $dbh->selectall_hashref($sql,"username");

    # print Dumper $result;

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

    #check if user exists
    ( $result->{result}, $result->{message} ) = $self->_user_exists( $data );
    return $result if ( $result->{result} == -1 );

    if ( !$result->{result} ) {

        my $stmt               = $self->_create_query();
        my $object_name        = 'organization';
#   note id 
        my @bind;
        push (@bind, 
            'organization'                                  ,     #object_name
            $data->{organization_name}                      ,     #entity_name
            $data->{comments}                    || ''      ,
            $data->{organization_type_id}        || undef   ,
            $data->{organization_contact_id}     || undef   ,
            $data->{organization_address_id}     || undef   ,
            $data->{note_id}                     || ''      ,
            $data->{is_active}                              ,
        );

        my $param = {
            action => 'creat',
            stmt   => $stmt,
            bind   => [@bind],
            entity => 'Organization'
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

    ( $result->{result}, $result->{message} ) = $self->_validate_data( $data );

    #invalid request
    return $result unless ( $result->{result} );

    ( $result->{result}, $result->{message} ) = $self->_user_exists( $data );

    if ( $result->{result} == -1 ) {
        my $sql = SQL::Abstract->new;

        #where clause we dont update organization_name
        my $where = { organization_name => delete $data->{organization_name} };
        my ( $stmt, @bind ) = $sql->update( $self->{table}, $data, $where );

        my $param = {
            action => 'updat',
            stmt   => $stmt,
            bind   => [@bind],
            entity => 'Organization'
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

    #validate only user_name
    ( $result->{result}, $result->{message} ) = $self->_validate_data( $data, ['username'] );

    #invalid request
    return $result unless ( $result->{result} );

    #go ahead and delete
    my $sql   = SQL::Abstract->new;
    my $where = { username => $data->{username} };

    # my($stmt, @bind) = $sql->delete($self->{table}, $where);
    $data = { "is_active" => 0 };
    my ( $stmt, @bind ) = $sql->update( $self->{table}, $data, $where );
    my $param = {
        action => 'delet',
        stmt   => $stmt,
        bind   => [@bind],
        entity => 'Organization'
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

sub _user_exists {
    my ( $self, $data ) = @_;

    #get db connection and check username

    my $result;

    my $sql = SQL::Abstract->new;

    # select 1 from organizations where organization_name = $data->{organization_name};

    my ( $stmt, @bind ) = $sql->select( $self->{table}, ['1'], { organization_name => $data->{organization_name} } );

    my $param = {
        action => 'select',
        stmt   => $stmt,
        bind   => [@bind],
        entity => 'Organizations',
        output => 1,          #since we need output
    };

    $result = $self->{_utils}->send_to_db( $param );    #execute on db

    if ( $result->{output} eq '0E0' ) {
        $result->{result}  = 0;
        $result->{message} = "Organizations $data->{organization_name} not exists";

    } elsif ( $result->{output} == 1 ) {
        $result->{result}  = -1;
        $result->{message} = "Organizations $data->{organization_name} already exists";
    }

    return ( $result->{result}, $result->{message} );
}
# ========================================================================== #

=item B<>

Params : NA

Returns: 

Desc   : 

=cut
sub js_validation_data {
    my ( $self ) = @_;

    my $users = App::Validation::Users->new();
    my $js_profile = $users->plugin('javascript_objects')->render(
        namespace => 'model',
        fields    => [$users->fields->keys],
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

sub _validate_data {
    my ( $self, $data, $fields ) = @_;

    my $valid = 0;

    my $message = "Invalid Request Required Parameters Missing";

    return ( $valid, $message ) unless ( keys %$data );

    $valid   = 1;       #validation will set this flag off
    $message = undef;
    my $data_copy = clone( $data );

    my $organizations = App::Validation::Organizations->new( %$data_copy );
    if ( defined $fields && ref $fields eq 'ARRAY' ) {

        #validated given fields only
        unless ( $organizations->validate( @$fields ) ) {
            $valid   = 0;
            $message = $organizations->errors_to_string;
        }
    } else {
        unless ( $organizations->validates( $organizations->fields->keys ) ) {
            $valid   = 0;
            $message = $organizations->errors_to_string;
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

    my $binds_symbol = join (',' , ( ('?') x 6 ));

    my $sql = qq(
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
            organizations
                (entity_id,organization_name, organization_type_id, organization_contact_id, organization_address_id, note_id, is_active)
                select (select id from entity_id) as entity_id,$binds_symbol;
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
            id, entity_id, organization_name, organization_type_id, organization_contact_id, organization_address_id, note_id, is_active
        from 
            organizations;
    );

    return $sql;
}
1;
