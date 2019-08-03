#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use App;
use App::Api;

# use this block if you want to mount several applications on different path

use Plack::Builder;

builder {
    mount '/'            => App->to_app;
    mount '/api/v1'      => App::Api->to_app;
}