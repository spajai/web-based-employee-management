package App::Api;

use Dancer2;

use App::Api::Users;
use App::Api::Persons;
use App::Api::Contacts;
use App::Api::Organizations;

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
####################
# Organizations
####################
get '/organizations' => sub {
    return App::Api::Organizations->new->get();
};

post '/organizations' => sub {
    my %body_parameters  = params('body');
    return App::Api::Organizations->new->create(\%body_parameters || {});
};

put '/organizations' => sub {
    my %body_parameters  = params('body');
    return App::Api::Organizations->new->update(\%body_parameters || {});
};

del '/organizations' => sub {
    my %body_parameters  = params('body');
    return App::Api::Organizations->new->delete(\%body_parameters || {});
};

true;