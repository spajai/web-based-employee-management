package App::Validation::Persons;

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
        pattern    => 'field %s should contain only contains digit,alphabet,under_score,hyphen and @ symbol',
        min_length => 'field %s has min length 5',
        max_length => 'field %s has max length 15'
    },
    filters => [qw/trim/],
};

# field entity_id => { mixin => 'id' }; #we will generate this

#Todo discuss 5char max
#prefix
field salutation  => { mixin => 'name_field', };

field first_name  => { mixin => 'name_field', };

field last_name   => { mixin => 'name_field', };

field middle_name => { mixin => 'name_field', };

field nick_name   => { mixin => 'name_field', };

#degree

field honorific => {
    required => 1,
    mixin    => [':str'],
    messages => {
        required => 'field %s is required',
    },
    filters => [qw/trim/]
};

field email_address => {
    required => 1,
    email    => 1,
    messages => {
        required => 'field %s is required',
    },
    filters => [qw/trim/]
};

#create if not exist
#update upsert
field phone_id   => { mixin   => 'id'   };

field sms_id     => { mixin   => 'id'   };

field note_id    => { mixin   => 'id'   };

field managed_by => { mixin   => 'id'   };

field is_locked  => { mixin   => 'bool' };

field is_active  => { mixin   => 'bool' };

field created_by => { mixin   => 'id'   };


# CREATE TABLE public.persons (
# entity_id int8 NULL,

# salutation text NOT NULL DEFAULT ''::text,
# first_name text NOT NULL DEFAULT ''::text,
# last_name text NOT NULL DEFAULT ''::text,
# middle_name text NOT NULL DEFAULT ''::text,
# nick_name text NOT NULL DEFAULT ''::text,

# honorific text NOT NULL DEFAULT ''::text,
# email_address text NOT NULL DEFAULT ''::text,
# phone_id text NOT NULL DEFAULT ''::text,
# sms_id text NOT NULL DEFAULT ''::text,
# note_id text NOT NULL DEFAULT ''::text,
# created_by int4 NULL,
# modified_by int4 NULL,
# managed_by int4 NULL,

# timezone text NOT NULL DEFAULT 'UTC'::text,
# is_locked bool NULL DEFAULT false,
# is_active bool NOT NULL DEFAULT true,

# );

1;
