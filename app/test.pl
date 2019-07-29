use strict;
use warnings;
use File::FindLib 'lib';
use lib '.';
# package main;
use Data::Dumper;
use App::Validation::Users;
# package MyApp::Person;

#################################user api test################
use App::Api::Users;

my $users = App::Validation::Users->new();
my $u = App::Api::Users->new();

my $data = {
    entity_id => 2,
    username => "smart_hacker_1",
    is_admin  => 1,
    gets_notifications => 1,
    permissions => 1,
    created_by => 1,
    modified_by => '12334',
    is_active => 1,
};

# use JSON;

# print encode_json($data);


# print Dumper $u->create($data);

print Dumper $u->get();

#update
# $data->{is_admin} = 1;
# $data->{username} = "smart_hacker",

# print Dumper $u->update($data);

# print Dumper $u->delete($data);

#################JUNK###########################











=pod
#################################Contacts api test################
use App::Api::Contacts;

my $c = App::Api::Contacts->new();

my $data = {
    short_name => 'smart',
    description => 'do we need',
    person_id => 1,
    address_list_id => 2,
    note_id => 3,
    is_active => 1
};

# use JSON;

print encode_json($data);

# print Dumper $c->js_validation_data();
# print Dumper $c->create($data);

# print Dumper $c->get();
#update
# $data->{is_active} = 0;
# $data->{phone_id} = 222236;
# $data->{email_address} = undef;

# print Dumper $c->update($data);

# print Dumper $c->delete($data);
# print Dumper $c->get();

#################JUNK###########################










=pod

#################################persons api test################
use App::Api::Persons;

my $persons = App::Validation::Persons->new();
my $p = App::Api::Persons->new();

my $data = {
     salutation => 'mr         s',
     first_name => 'smart',
     last_name => 'hacker',
     middle_name => 'i know',
     nick_name => 'smarty',
     honorific => 'male',
     email_address => 'don\'t@gmail.com',
     phone_id  => 1,
     sms_id => 1, 
     note_id => 1,
     managed_by => '1',
     timezone => 'America/Chicago',
     is_locked => 1,
     is_active => 1,
     created_by => 1,
};

# use JSON;

# print encode_json($data);


# print Dumper $p->create($data);

print Dumper $p->get();
#update
# $data->{is_locked} = 0;
# $data->{phone_id} = 222236;
# $data->{email_address} = undef;

# print Dumper $p->update($data);

print Dumper $p->delete($data);
print Dumper $p->get();


=pod

#################################user api test################
use App::Api::Users;

my $users = App::Validation::Users->new();
my $u = App::Api::Users->new();

my $data = {
    entity_id => 2,
    username => "smart_hacker_1",
    is_admin  => 1,
    gets_notifications => 1,
    permissions => 1,
    created_by => 1,
    modified_by => '12334',
    is_active => 1,
};

# use JSON;

# print encode_json($data);


# print Dumper $u->create($data);

print Dumper $u->get();
#update
# $data->{is_admin} = 1;
# $data->{username} = "smart_hacker",

# print Dumper $u->update($data);

# print Dumper $u->delete($data);

#################JUNK###########################



=pod




my $data = {
    "entity_id"      => "111               ",
    "username"    => "sss",
    # "title"   => "Designer",
    # "company" => {
        # "name"       => "House of de Vil",
        # "supervisor" => {
            # "name"   => "Cruella de Vil",
            # "rating" => [
                # {   "support"  => -9,
                    # "guidance" => -9
                # }
            # ]
        # },
        # "tags" => [
            # "evil",
            # "cruelty",
            # "dogs"
        # ]
    # },
};
 
# my $spec = {
    # 'id'                            => { max_length => 2 },
    # 'name'                          => { mixin      => ':str' },
    # 'company.name'                  => { mixin      => ':str' },
    # 'company.supervisor.name'       => { mixin      => ':str' },
    # 'company.supervisor.rating.@.*' => { pattern    => qr/^(?!evil)\w+/ },
    # 'company.tags.@'                => { max_length => 20 },
# };
use Data::Dumper;

my $spec = $users->rules();
# my $person = MyApp::Person->new;

unless ($users->validate_document($spec => $data)) {
 print Dumper $data;
    warn $users->errors_to_string if $users->error_count;
}
 
1;

=pod
use File::FindLib 'lib';
use lib '.';
use App::Utils;

my $t = App::Utils->new();

use App::Validation::Users;
use Validation::Class;
 my $v = Validation::Class->new();
# my 
 
# my $person = App::Validation::User::profile();
my $spec = App::Validation::Users::profile();
 my $data = {
        'id'                            => '1111111111',
 };

unless ($v->validate_document($spec => $data)) {
    warn $v->errors_to_string if $v->error_count;
}



++++++++++++++++++DS+++++++++++++
$result = $dbh->selectall_hashref($sql,"id");

$VAR1 = {
          '18' => {
                    'entity_id' => 2,
                    'is_admin' => 1,
                    'gets_notifications' => 1,
                    'permissions' => 1,
                    'is_active' => 1,
                    'id' => 18,
                    'username' => 'smart_hacker',
                    'last_login' => '2019-07-27 09:41:38.228183'
                  },
          '16' => {
                    'id' => 16,
                    'username' => 'test_user@',
                    'last_login' => '2019-07-25 19:39:28.177537',
                    'gets_notifications' => 1,
                    'is_admin' => 0,
                    'entity_id' => 1,
                    'is_active' => 1,
                    'permissions' => 89
                  }
        };
        
        
$result = $dbh->selectall_arrayref($sql);

$VAR1 = [
          [
            16,
            1,
            'test_user@',
            0,
            1,
            89,
            '2019-07-25 19:39:28.177537',
            1
          ],
          [
            18,
            2,
            'smart_hacker',
            1,
            1,
            1,
            '2019-07-27 09:41:38.228183',
            1
          ]
        ];
