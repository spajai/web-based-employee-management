package App::Api;

use Dancer2;
use Data::Dumper;
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
    my %body_parameters  = _log_entry('post user prams: ', params('body'));
    return _log_exit('post user result :', App::Api::Users->new->create(\%body_parameters || {}));
};

put '/user' => sub {
    my %body_parameters  = _log_entry('put user prams: ', params('body'));
    return _log_exit('put user result : ', App::Api::Users->new->update(\%body_parameters || {}));
};

del '/user' => sub {
    my %body_parameters  = _log_entry('del user prams: ', params('body'));
    return _log_exit('del user result : ', App::Api::Users->new->delete(\%body_parameters || {}));
};

####################
# person
####################

get '/person' => sub {
    return App::Api::Persons->new->get();
};

post '/person' => sub {
    my %body_parameters  = _log_entry('post person prams: ',params('body'));
    return _log_exit('post person result: ',App::Api::Persons->new->create(\%body_parameters || {}));
};

put '/person' => sub {
    my %body_parameters  = _log_entry('put person prams: ',params('body'));
    return _log_exit('put person result: ',App::Api::Persons->new->update(\%body_parameters || {}));
};

del '/person' => sub {
    my %body_parameters  = _log_entry('del person prams: ',params('body'));
    return _log_exit('del person result: ',App::Api::Persons->new->delete(\%body_parameters || {}));
};

####################
# Contacts
####################

get '/contact' => sub {
    return App::Api::Contacts->new->get();
};

post '/contact' => sub {
    my %body_parameters  = _log_entry('post contact prams: ',params('body'));
    return _log_exit('post contact result: ',App::Api::Contacts->new->create(\%body_parameters || {}));
};

put '/contact' => sub {
    my %body_parameters  = _log_entry('put contact prams: ',params('body'));
    return _log_exit('put contact result: ',App::Api::Contacts->new->update(\%body_parameters || {}));
};

del '/contact' => sub {
    my %body_parameters  = _log_entry('del contact prams: ',params('body'));
    return _log_exit('del contact result: ',App::Api::Contacts->new->delete(\%body_parameters || {}));
};

####################
# Organizations
####################

get '/organization' => sub {
    return App::Api::Organizations->new->get();
};

post '/organization' => sub {
    my %body_parameters  = _log_entry('post org prams: ',params('body'));
    return _log_exit('post org result: ',App::Api::Organizations->new->create(\%body_parameters || {}));
};

put '/organization' => sub {
    my %body_parameters  = _log_entry('put org prams: ', params('body'));
    return _log_exit('put org result: ',App::Api::Organizations->new->update(\%body_parameters || {}));
};

del '/organization' => sub {
    my %body_parameters  = _log_entry('del org prams: ', params('body'));
    return _log_exit('del org result: ', App::Api::Organizations->new->delete(\%body_parameters || {}));
};

sub _log_entry {
    my ($msg,%params) = @_;
    info("$msg ". Dumper(\%params));
    return %params;
}

sub _log_exit {
    my ($msg,$result) = @_;
    info("$msg ". Dumper($result));
    return $result
}

true;