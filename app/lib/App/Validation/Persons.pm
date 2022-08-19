package App::Validation::Persons;

use App::Validation::Common;
use Validation::Class;

adopt "App::Validation::Common", mixin => 'bool';
adopt "App::Validation::Common", mixin => 'id';
adopt "App::Validation::Common", mixin => 'name_field';

# field entity_id => { mixin => 'id' }; #we will generate this

#Todo discuss 5char max
#prefix
field salutation  => { mixin => 'name_field', required => 0 };

field first_name  => { mixin => 'name_field', };

field last_name   => { mixin => 'name_field', };

field middle_name => { mixin => 'name_field', required => 0 };

field nick_name   => { mixin => 'name_field', required => 0 };

#degree

field honorific => {
    required => 0,
    mixin    => [':str'],
    # messages => {
        # required => 'field %s is required',
    # },
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

# field managed_by => { mixin   => 'id'   };

field is_locked  => { mixin   => 'bool' };

# field is_active  => { mixin   => 'bool' };

# field created_by => { mixin   => 'id'   };


1;
