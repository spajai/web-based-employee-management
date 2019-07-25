package App;
use Dancer2;

use App::Api::Users;
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

post '/user' => sub {
    my %body_parameters  = params('body');
    return App::Api::Users->new->insert(\%body_parameters || {});
};

put '/user' => sub {
    my %body_parameters  = params('body');
    return App::Api::Users->new->update(\%body_parameters || {});
};

true;
