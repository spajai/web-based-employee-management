package App;
use Dancer2;
# $INC{"JSON/PP/Boolean.pm"} = 0;
use Data::Dumper;

use App::Api::Users;
use App::Api::Persons;
use App::Api::Contacts;
use App::Api::Organizations;

# set serializers => undef;

get '/' => sub {
    my $model = query_parameters->get('view') || 'users';
    forward '/view/'.$model;
};

get '/view/users' => sub {

    my $data =  App::Api::Users->new->get();
    send_as html => template 'users.tt', {result_set =>  $data};
    # template 'users.tt', {result_set =>  $data};

};

get '/view/organizations' => sub {

    my $data =  App::Api::Users->new->get();
# set content_type => 'text/html';
    # send_as html => template 'users.tt', { users => {data => encode_json($data) }};
    send_as html => template 'users.tt', {result_set =>  $data};
     # template 'users.tt', { users => {data => encode_json($data) }};

};
get '/view/persons' => sub {

    my $data =  App::Api::Persons->new->get();
# set content_type => 'text/html';
    # send_as html => template 'users.tt', { users => {data => encode_json($data) }};
    send_as html => template 'persons.tt', {result_set =>  $data};
     # template 'users.tt', { users => {data => encode_json($data) }};

};
get '/view/contacts' => sub {

    my $data =  App::Api::Users->new->get();
# set content_type => 'text/html';
    # send_as html => template 'users.tt', { users => {data => encode_json($data) }};
    send_as html => template 'users.tt', {result_set =>  $data};
     # template 'users.tt', { users => {data => encode_json($data) }};

};


true;