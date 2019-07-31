package App;
use Dancer2;
# $INC{"JSON/PP/Boolean.pm"} = 0;

use App::Api::Users;
get '/' => sub {
    my $data =  App::Api::Users->new->get();
    use Data::Dumper;
    print Dumper $data;
    
    
# set content_type => 'text/html';
    # send_as html => template 'users.tt', { users => {data => encode_json($data) }};
    send_as html => template 'users.tt', {result_set =>  $data};
     # template 'users.tt', { users => {data => encode_json($data) }};
};

true;