package App::Validation::Common;

use Validation::Class;

mixin id => {
    required => 1,
    pattern  => qr/^[0-9]*$/,
    messages => {
        required => 'field %s is required',
        pattern  => 'field %s should contain digit only',
    },
    filters => [qw/trim/],
};

mixin bool => {
    required => 1,
    pattern  => qr/^[0-1]$/,
    mixin    => [':int'],
    messages => {
        required => 'field %s is required',
        pattern  => 'field %s should contain only boolen value',
    },
    filters => [qw/trim/]
};

mixin name_field => {
    required   => 1,
    min_length => 3,
    max_length => 15,
    messages   => {
        required   => 'field %s is required',
        min_length => 'field %s has min length 5',
        max_length => 'field %s has max length 15'
    },
    filters => [qw/trim/],
};

1;