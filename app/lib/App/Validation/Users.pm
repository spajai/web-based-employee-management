package App::Validation::Users;

use Validation::Class;

#Rules for username
field username => {
    required   => 1,
    pattern    => qr/^(?![0-9]+$)[A-Za-z0-9_\-\@]{8,30}$/,
    min_length => 8,
    max_length => 30,
    messages => {
        required => 'field %s is required',
        pattern  => 'field %s should contain only contains digit,alphabet,under_score,hyphen and @ symbol',
        min_length => 'field %s has min length 8',
        max_length => 'field %s has max length 30'

    },
    filters => [qw/trim strip/]
};


#Rules for is_admin
field is_admin => {
    mixin    => [':flg'],
    messages => {
        required => 'field %s is required',
    },

};


#Rules for gets_notifications
field gets_notifications => {

    # required => 1,
    mixin    => [':flg'],
    messages => {
        # required => 'field %s is required',
        pattern  => 'field %s should contain only contains only boolen value',
    },
};


#Rules for permissions
field permissions => {
    mixin    => [':num'],
    messages => {
        required => 'field %s is required',
    },
};

field is_active => {
    mixin    => [':num'], 
    messages => {
        required => 'field %s is required',
    },
};


#Rules for created_by
# field created_by => {
    # required => 1,
    # pattern  => qr/^[0-9]*$/i,
    # messages => {
        # required => 'field %s is required',
        # pattern  => 'field %s should contain only contains only integer',
    # },
    # filters => [qw/trim/]
# };

#at the time of update
# field modified_by => {
    # pattern  => qr/^[0-9]*$/i,
    # messages => {
        # pattern => 'field %s should contain only contains only integer',
    # },
    # filters => [qw/trim/]
# };

1;