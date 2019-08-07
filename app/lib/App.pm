package App;
use Dancer2;

use Data::Dumper;

use App::Api::Users;
use App::Api::Persons;
use App::Api::Contacts;
use App::Api::Organizations;

any  ['get','post'] => '/' => sub {
    my $model = query_parameters->get('view');

    if(defined $model ) {
        forward '/view/'.$model;
    }

    my $form  = query_parameters->get('edit');
    my $id    = query_parameters->get('id');
    if(defined $form && defined $id) {
        forward "/edit/$form/$id";
    }

    #DEFAULT
    forward '/view/users';

};

get '/view/users' => sub {
    my $data =  App::Api::Users->new->get();
    send_as html => template 'users.tt', {result_set =>  $data};
};

get '/view/organizations' => sub {
    my $data =  App::Api::Organizations->new->get();
    send_as html => template 'organizations.tt', {result_set =>  $data};
};
####################
# person
####################
get '/view/persons' => sub {
    my $data =  App::Api::Persons->new->get();
    send_as html => template 'persons.tt', {result_set =>  $data};
};
    ######################
    # person form edit
    #######################
    any [qw/get post/] => '/edit/person/:id' => sub {
        my $id  = route_parameters->get('id');
        my $data =  App::Api::Persons->new->get_for_edit($id);
        send_as html => template 'persons_edit.tt', {wrapper => undef ,result_set =>  $data};

        # { wrapper => 'layouts/main.tt' };
        # send_file 'package-lock.json';
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