#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use App;

app->to_app;

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

=begin comment
# use this block if you want to mount several applications on different path

use app;
use app_admin;

use Plack::Builder;

builder {
    mount '/'      => app->to_app;
    mount '/admin'      => app_admin->to_app;
}

=end comment

=cut

