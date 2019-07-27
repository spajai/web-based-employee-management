package App::Validation::Users;

use Validation::Class;


field entity_id => {
    required => 1,
    pattern  => qr/^[0-9]*$/,
    messages => {
        required => 'field %s is required',
        pattern  => 'field %s should contain digit only',
    },
    filters => [qw/trim/],
};



#Rules for username
field username => {
    required   => 1,
    pattern    => qr/^(?![0-9]+$)[A-Za-z0-9_\-\@]{8,30}$/,
    min_length => 8,
    max_length => 30,

    # between  => [ 18, 20 ],
    # between => 'field %s has min length 8 and max length 30'
    messages => {
        required => 'field %s is required',
        pattern  => 'field %s should contain only contains digit,alphabet,under_score,hyphen and @ symbol',
        min_length => 'field %s has min length 8',
        max_length => 'field %s has max length 30'

    },
    filters => [qw/trim/]
};




#Rules for is_admin
field is_admin => {
    required => 1,
    pattern  => qr/^[0-1]$/,
    mixin    => [':int'],
    messages => {
        required => 'field %s is required',
        pattern  => 'field %s should contain only boolen value',
    },
    filters => [qw/trim/]
};


#Rules for gets_notifications
field gets_notifications => {

    # required => 1,
    pattern  => qr/^[0-1]$/,
    mixin    => [':int'],
    messages => {
        # required => 'field %s is required',
        pattern  => 'field %s should contain only contains only boolen value',
    },
    filters => [qw/trim/]
};


#Rules for permissions
field permissions => {

    required => 1,
    pattern  => qr/^[0-9]*$/i,
    messages => {
        required => 'field %s is required',
        pattern  => 'field %s should contain only contains only integer',
    },
    filters => [qw/trim/]
};

#Rules for is_active

#actually a deletion soft deletion
# we don't support hard delete

field is_active => {
    required => 1,
    between  => [ 0, 1 ],
    messages => {
        required => 'field %s is required',
        pattern  => 'field %s should contain only contains only boolen value',
        between =>  'field %s has min length 8 and max length 30'
    },
    filters => [qw/trim/]
};



#Rules for created_by
field created_by => {
    required => 1,
    pattern  => qr/^[0-9]*$/i,
    messages => {
        required => 'field %s is required',
        pattern  => 'field %s should contain only contains only integer',
    },
    filters => [qw/trim/]
};

#at the time of update
field modified_by => {
    # required => 1,
    pattern  => qr/^[0-9]*$/i,
    messages => {
        # required => 'field %s is required',
        pattern => 'field %s should contain only contains only integer',
    },
    filters => [qw/trim/]
};

1;