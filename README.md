# web-based-employee-management
Simple Custom Web based employee management system Built in Perl Dancer2 with REST api


to start 

install
```
requires "Dancer2" => "0.208000";

recommends "YAML"             => "0";
recommends "URL::Encode::XS"  => "0";
recommends "CGI::Deurl::XS"   => "0";
recommends "HTTP::Parser::XS" => "0";

on "test" => sub {
    requires "Test::More"            => "0";
    requires "HTTP::Request::Common" => "0";
};


# File::FindLib;
# SQL::Abstract
# DateTime::Format::Flexible
# Template::Plugin::JSON
# Dancer2::Logger::File 
```

to start
edit 
Conf.pm and add Postgres connection 
```
    # The database DSN for postgres ==> more: "perldoc DBD::Pg"
    $self->{database_dsn} = "DBI:Pg:database=$self->{database_name}";
```

use commnad to start

perl bin/app.pl

Api path := /api/v1
