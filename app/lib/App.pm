package App;
use Dancer2;

use Data::Dumper;

use App::Api::Users;
use App::Api::Persons;
use App::Api::Contacts;
use App::Api::Organizations;

get '/' => sub {
    my $model = query_parameters->get('view') || 'users';
    forward '/view/'.$model;
};

get '/view/users' => sub {
    my $data =  App::Api::Users->new->get();
    send_as html => template 'users.tt', {result_set =>  $data};
};

get '/view/organizations' => sub {
    my $data =  App::Api::Organizations->new->get();
    send_as html => template 'organizations.tt', {result_set =>  $data};
};

get '/view/persons' => sub {
    my $data =  App::Api::Persons->new->get();
    send_as html => template 'persons.tt', {result_set =>  $data};
};

get '/view/contacts' => sub {
    my $data =  App::Api::Contacts->new->get();
    send_as html => template 'contacts.tt', {result_set =>  $data};
};

true;
=pod
get '/view/users' => sub {

    my $data =  App::Api::Users->new->get();
    send_as html => template 'users.tt', {result_set =>  $data};
    # template 'users.tt', {result_set =>  $data};

};