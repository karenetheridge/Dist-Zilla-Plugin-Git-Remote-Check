
use strict;
use warnings;

package Dist::Zilla::Role::Git::RemoteNames;

# ABSTRACT: Query a list of remotes from C<Git>

use Moose::Role;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Dist::Zilla::Role::Git::RemoteNames",
    "interface":"role"
}

=end MetaPOD::JSON

=cut

=head1 COMPOSITION

Recommended application order if using this role:

    with "Dist::Zilla::Role::Plugin";
    with "Dist::Zilla::Role::Git::LocalRepository";
    with "Dist::Zilla::Role::Git::RemoteNames";

=requires C<log_fatal>

=requires C<git>

=cut

requires 'log_fatal';
requires 'git';

has 'remote_names' => (
  isa        => 'ArrayRef[ Str ]',
  is         => 'rw',
  lazy_build => 1,
  traits     => [qw( Array )],
  handles    => { _has_remote_name => 'first' },
  init_arg   => undef,
);

=method C<has_remote_name>

    if ( $self->has_remote_name( $name ) ) {

    }

Returns true if C<git> reports C<$name> is a remote name that exists.

=cut

sub has_remote_name {
  my ( $self, $remote_name ) = @_;
  return $self->_has_remote_name( sub { $_ eq $remote_name } );
}

=method C<get_valid_remote_name>

    my $remote = $self->get_valid_remote_name( $remotename );

Returns C<$remotename> as long as C<$remotename> is a valid remote according to C<git>

Raises a fatal error otherwise.

=cut

sub get_valid_remote_name {
  my ( $self, $remote_name ) = @_;
  return $remote_name if $self->has_remote_name($remote_name);

  require Data::Dump;

  my $msg = qq[Git reports remote name '%s' does not exist.\n Remotes: %s];

  return $self->log_fatal( [ $msg, $remote_name, Data::Dump::dump( $self->remote_names ), ] );
}

sub _build_remote_names {
    my ( $self, ) = @_;
    return [ $self->git->remote ]
}

no Moose::Role;

1;
