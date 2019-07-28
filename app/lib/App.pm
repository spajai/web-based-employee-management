package App;
use Dancer2;

use App::Api::Users;
use App::Api::Persons;
use App::Api::Contacts;

prefix '/api/v1';

####################
# user
####################
get '/user' => sub {
    return App::Api::Users->new->get();
};
post '/user' => sub {
    my %body_parameters  = params('body');
    return App::Api::Users->new->create(\%body_parameters || {});
};

put '/user' => sub {
    my %body_parameters  = params('body');
    return App::Api::Users->new->update(\%body_parameters || {});
};

del '/user' => sub {
    my %body_parameters  = params('body');
    return App::Api::Users->new->delete(\%body_parameters || {});
};
####################
# person
####################
get '/person' => sub {
    return App::Api::Persons->new->get();
};

post '/person' => sub {
    my %body_parameters  = params('body');
    return App::Api::Persons->new->create(\%body_parameters || {});
};

put '/person' => sub {
    my %body_parameters  = params('body');
    return App::Api::Persons->new->update(\%body_parameters || {});
};

del '/person' => sub {
    my %body_parameters  = params('body');
    return App::Api::Persons->new->delete(\%body_parameters || {});
};
####################
# Contacts
####################
get '/contact' => sub {
    return App::Api::Contacts->new->get();
};

post '/contact' => sub {
    my %body_parameters  = params('body');
    return App::Api::Contacts->new->create(\%body_parameters || {});
};

put '/contact' => sub {
    my %body_parameters  = params('body');
    return App::Api::Contacts->new->update(\%body_parameters || {});
};

del '/contact' => sub {
    my %body_parameters  = params('body');
    return App::Api::Contacts->new->delete(\%body_parameters || {});
};



true;

=pod
# get '/api/v1/ticket/count' => sub {
    # header('Content-Type' => 'application/json');
    # return to_json $report->get_ticket_count(params->{dev} || undef);
# };
# post '/api/v1/admin/ticket/set-hidden' => sub {
    # header('Content-Type' => 'application/json');
    # return to_json { 'status' => $report->set_hidden_tickets(params->{id} || undef)};
# };
# get all parameters as a single hash
    # my %all_parameters = params;
 
    # // request all parmameters from a specific source: body, query, route
    # my %body_parameters  = params('body');
    # my %route_parameters = params('route');
    # my %query_parameters = params('query');
# get '/api/v1/ticket/meta/:id?' => sub {
    # header('Content-Type' => 'application/json');
    # my $id = route_parameters->get('id') || undef;
    # return to_json $report->get_ticket_meta($id, params->{start} || undef);
# };
# put '/api/v1/admin/dev' => sub {
    # header('Content-Type' => 'application/json');
    # my $data = from_json(request->body);
    # return to_json { status => $dev->update_dev($data) };
# };

