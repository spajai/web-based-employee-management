package App;
use Dancer2;

use App::Api::Users;
get '/' => sub {
    my $data =  App::Api::Users->new->get();
# set content_type => 'text/html';
    # send_as html => template 'users.tt', { users => {data => encode_json($data) }};
    send_as html => template 'users.tt', { users => {data => encode_json($data) }};
     # template 'users.tt', { users => {data => encode_json($data) }};
};

true;