package App::Validation::Organizations;

use Validation::Class;
use App::Validation::Common;
use Validation::Class::Plugin::JavascriptObjects;

adopt "App::Validation::Common", mixin => 'bool';
adopt "App::Validation::Common", mixin => 'id';
adopt "App::Validation::Common", mixin => 'name_field';

field organization_name          => { mixin   => 'name_field' };
field organization_type_id       => { mixin   => 'id'         };
field organization_contact_id    => { mixin   => 'id'         };
field organization_address_id    => { mixin   => 'id'         };
field note_id                    => { mixin   => 'id'         };
# field created_by                 => { mixin   => 'id'         };
# field is_active                  => { mixin   => 'bool'       };

1;
