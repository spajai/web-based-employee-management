package App::Form;

use Dancer2;

use App::Api::Users;
use App::Api::Persons;
use App::Api::Contacts;
use App::Api::Organizations;


####################
# person
####################
get '/edit/person/:id' => sub {
    my $id  = route_parameters->get('id');
    return App::Api::Persons->new->get();
};