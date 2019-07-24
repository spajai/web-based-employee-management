use strict;
use warnings;
use File::FindLib 'lib';
use lib '.';
# package main;

use App::Validation::Users;
# package MyApp::Person;
my $users = App::Validation::Users->new();
 
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