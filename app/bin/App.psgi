#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

# BEGIN { $ENV{PERL_JSON_BACKEND} = 'JSON::XS' };
 
# use JSON -support_by_pp;
# $JSON::true = 1;
# $JSON::false = 0;

# use this block if you don't need middleware, and only have a single target Dancer app to run here
use App;
use App::Api;

=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use app;
use Plack::Builder;

builder {
    enable 'Deflater';
    app->to_app;
}

=end comment

=cut

# =begin comment
# use this block if you want to mount several applications on different path

use Plack::Builder;

builder {
    mount '/'             => App->to_app;
    mount '/api/v1'      => App::Api->to_app;
}

# =end comment



