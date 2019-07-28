package App::Validation::Contacts;

use Validation::Class;
use App::Validation::Common;
use Validation::Class::Plugin::JavascriptObjects;

adopt "App::Validation::Common", mixin => 'bool';
adopt "App::Validation::Common", mixin => 'id';
adopt "App::Validation::Common", mixin => 'name_field';



# field entity_id => { mixin => 'id' }; #we will generate this

field short_name  => { mixin   => 'name_field' };

field is_active  =>  { mixin   => 'bool'       };

field address_list_id  => { mixin   => 'id'   };
field person_id  => { mixin   => 'id'   };

field note_id    => { mixin   => 'id'   };

1;
