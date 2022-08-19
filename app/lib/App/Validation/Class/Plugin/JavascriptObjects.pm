# ABSTRACT: Javascript Object Rendering for Validation::Class

package Validation::Class::Plugin::JavascriptObjects;

use strict;
use warnings;

use JSON -convert_blessed_universally;

use Validation::Class::Util;

sub new {

    my $class     = shift;
    my $prototype = shift;

    my $self = {prototype => $prototype};

    return bless $self, $class;

}

sub proto {

    goto &prototype;

}

sub prototype {

    my ($self) = @_;

    return $self->{prototype};

}


sub render {
    my ($self, %options)  = @_;

    my $model     = $self->prototype;
    my $namespace = $options{namespace} || $model->package || 'object';
    my $next      = my $root = {};

    $next = $next->{$_} = {} for split /\W+/, $namespace;

    my @fields = isa_arrayref($options{fields}) ?
        map { $model->fields->get($_) || () } @{$options{fields}} :
        $model->fields->values
    ;

    foreach my $field (@fields) {
        my %data = map {
            # automatically excludes validation, etc
            isa_coderef($field->{$_}) ? () : ($_ => $field->{$_})
        }   $field->keys;

        my $name = $field->name;

        if (isa_arrayref $options{include}) {
            %data = map { $_ => $data{$_} } @{$options{include}};
        }

        if (isa_arrayref $options{exclude}) {
            delete $data{$_} for @{$options{exclude}};
        }

        $next->{$name} ||= {%data};

    }

    # generate the JS object
    my @data = each(%{$root});
    my $prof = $self->format_rules($data[1]);
    my $js_validation_data;
    # my $data = JSON->new->allow_nonref->allow_blessed->convert_blessed->utf8->pretty->encode($prof);
     $js_validation_data->{rules}    = JSON->new->allow_nonref->allow_blessed->convert_blessed->utf8->pretty->encode($prof->{rules});
    $js_validation_data->{messages} = JSON->new->allow_nonref->allow_blessed->convert_blessed->utf8->pretty->encode($prof->{messages});


    return $js_validation_data;
}

sub format_rules
{
    my $self  = shift;
    my $rules = shift;

    my %opt_map = (min_length => 'minlength', max_length => 'maxlength', matches => 'equalTo', max_sum => 'max');
    my %opt_convert = (decimal => 'number', telephone => 'phoneUS', between => 'rangelength', zipcode => 'zipcodeUS');
    my $messages;
    my $rules_profile;

    foreach my $k (sort keys %{$rules}) {
        foreach my $r (sort keys %{$rules->{$k}}) {
            # since jquery date validation accepts only (mm/dd/yyyy)date format
            next if ($r eq 'date');

            if (exists $opt_map{$r}) {
                $rules_profile->{'rules'}->{$k}->{$opt_map{$r}} = $rules->{$k}->{$r}
                  if ($rules->{$k}->{$r});
                $rules_profile->{'rules'}->{$k}->{$opt_map{$r}} = "[name=$rules->{$k}->{$r}]"
                  if ($rules->{$k}->{$r} and $r eq 'matches');
            }
            
            elsif ($r eq 'messages') {
                foreach my $m (sort keys %{$rules->{$k}->{$r}}) {

                    my $msg = $self->construct_message($rules->{$k}{$r}{$m}, $k);

                    if (exists $opt_map{$m}) {
                        $messages->{$k}->{$opt_map{$m}} = $msg;
                    }
                    elsif (exists $opt_convert{$m}) {
                        $messages->{$k}->{$opt_convert{$m}} = $msg;
                    }
                    else {
                        $messages->{$k}->{$m} = $msg;
                    }
                }
            }
            elsif (defined $rules->{$k}->{$r} and $r eq 'pattern') {
                # Removing inline modifiers since javascript will not support inline modifiers
                $rules->{$k}->{$r} =~ s/\?\^\://;
                $rules->{$k}->{$r} =~ s/^\(\)$//;
                $rules_profile->{'rules'}->{$k}->{$r} = "$rules->{$k}->{$r}";
            }
            else {
                $rules_profile->{'rules'}->{$k}->{$r} = $rules->{$k}->{$r}
                  if ($rules->{$k}->{$r});
            }
        }
        my $new_key = $rules->{$k}->{'alias'}
          if (exists $rules->{$k}->{'alias'});
        if (defined $new_key) {
            $rules_profile->{'rules'}->{$new_key} =
              $rules_profile->{'rules'}->{$k};
            delete $rules_profile->{'rules'}->{$new_key}->{'alias'};
            delete $rules_profile->{'rules'}->{$k};
            $messages->{$new_key} = $self->construct_message($messages->{$k}, $new_key);
            delete $messages->{$k};
        }
    }
    $rules_profile->{'messages'} = $messages if ($messages);

    return $rules_profile;
}

sub construct_message
{
    my ($self, $msg, $arg) = @_;

    if ($msg =~ /%s/) {
        $msg = sprintf($msg, $arg);
    }
    return $msg;
}

1;

__END__
=pod

=head1 NAME

Validation::Class::Plugin::JavascriptObjects - Javascript Object Rendering for Validation::Class

=head1 VERSION


=head1 SYNOPSIS

    # this plugin is in working condition but untested!!!

    use Validation::Class::Simple;
    use Validation::Class::Plugin::JavascriptObjects;

    # given

    my $rules = Validation::Class::Simple->new(
        fields => {
            username => { required => 1 },
            password => { required => 1 },
        }
    );

    # when

    my $objects = $rules->plugin('javascript_objects');

    print $objects->render(namespace => 'form.signup', include => [qw/errors/]);

    # then, output should be ...

    var form.signup = {
        "password": {
            "errors": ["password is required"]
        },
        "username": {
            "errors": ["username is required"]
        }
    };

=head1 DESCRIPTION

Validation::Class::Plugin::JavascriptObjects is a plugin for L<Validation::Class>
which can leverage your validation class field definitions to render JavaScript
objects for the purpose of introspection.

=head1 METHODS

=head2 render

The render method converts the attached validation class into a javascript
object for introspection purposes. This method accepts a list of key/value pairs
as options.

    $self->render;

    # or

    $self->render(
        namespace => 'Foo.Bar',
        exclude   => [qw/pattern/]
    );

    # or

    $self->render(
        namespace => 'Foo.Baz',
        include   => [qw/minlength maxlength required/]
    );

    # or, to also limit the fields output

    $self->render(
        namespace => 'Foo.Baz',
        fields    => [qw/this that/],
        include   => [qw/minlength maxlength required/]
    );

=head1 AUTHOR

spajai

=cut

