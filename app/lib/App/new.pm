use Dancer2;

get '/' => sub {
    my $data =  App::Api::Users->new->get();

    template 'users.tt', { users => {data => $data }};
};

true;