package App::Validation::Contacts;

use Validation::Class;

# use App::Validation::Persons;
# adopt App::Validation::Persons, 'mixin' => 'bool';
# adopt App::Validation::Persons, 'mixin' => 'id';
# adopt App::Validation::Persons, 'mixin' => 'name_field';

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
        pattern    => 'field %s should contain only contains digit,alphabet,under_score,hyphen and @ symbol',
        min_length => 'field %s has min length 5',
        max_length => 'field %s has max length 15'
    },
    filters => [qw/trim/],
};

# field entity_id => { mixin => 'id' }; #we will generate this

field short_name  => { mixin   => 'name_field' };

field is_active  =>  { mixin   => 'bool'       };

field address_list_id  => { mixin   => 'id'   };

field note_id    => { mixin   => 'id'   };

1;
