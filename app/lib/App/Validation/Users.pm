package App::Validation::Users;

use Validation::Class;

sub rules {
    my $rules = {
        entity_id => {
            required => 1,
            pattern  => qr/^[0-9]*$/,
            messages => {
                # required => 'field %s is required',
                # pattern  => 'field %s should contain digit only',
            },
            filters => [qw/trim/],
        },
        username => {
            required => 1,
            pattern  => qr/^(?![0-9]+$)[A-Za-z0-9_\-\@]{8,30}$/,
            # pattern  => qr/^[A-Za-z0-9_\-\@]*$/,
            min_length => 8,
            max_length => 30,
            # between  => [ 18, 20 ],
            messages => {
                required => 'field %s is required',
                pattern  => 'field %s should contain only contains digit,alphabet,under_score,hyphen and @ symbol',

                min_length => 'field %s has min length 8',
                max_length => 'field %s has max length 30'
                # between => 'field %s has min length 8 and max length 30'
            },
            filters => [qw/trim/]
        },
        is_admin => {
            # required => 1,

            pattern  => qr/^[0|1|t|f|y|n]$/i,
            messages => {
                required => 'field %s is required',
                pattern  => 'field %s should contain only boolen value',
            },
            filters => [qw/trim/]
        },
        gets_notifications => {
            # required => 1,
            pattern  => qr/^[0|1|t|f|y|n]$/i,
            messages => {
                required => 'field %s is required',
                pattern  => 'field %s should contain only contains only boolen value',
            },
            filters => [qw/trim/]
        },
        permissions => {
            # required => 1,
            pattern  => qr/^[0-9]*$/i,
            messages => {
                required => 'field %s is required',
                pattern  => 'field %s should contain only contains only integer',
            },
            filters => [qw/trim/]
        },
        is_active => {
            # required => 1,
            pattern  => qr/^[0|1|t|f|y|n]$/i,
            messages => {
                required => 'field %s is required',
                pattern  => 'field %s should contain only contains only boolen value',
            },
            filters => [qw/trim/]
        },

        created_by => {

            # required => 1,
            pattern  => qr/^[0-9]*$/i,
            messages => {

                # required => 'field %s is required',
                pattern => 'field %s should contain only contains only integer',
            },
            filters => [qw/trim/]

        },
        modified_by => {

            # required => 1,
            pattern  => qr/^[0-9]*$/i,
            messages => {

                # required => 'field %s is required',
                pattern => 'field %s should contain only contains only integer',
            },
            filters => [qw/trim/]

        },
      };

      # entity_id int8 NULL,
      # username text NULL,
      # is_admin bool NOT NULL DEFAULT false,
      # gets_notifications bool NOT NULL DEFAULT false,
      # permissions int4 NOT NULL DEFAULT 0,
      # last_login timestamp NOT NULL DEFAULT now(),
      # last_pwd_change timestamp NOT NULL DEFAULT now(),
      # is_active bool NOT
      # NULL DEFAULT true,
      # created_by int4 NULL,
      # modified_by int4 NULL,
      # );
      return $rules;
}

1;

##########################
# Auther  :- spajai
# Created :- 07/24/2019
##########################
