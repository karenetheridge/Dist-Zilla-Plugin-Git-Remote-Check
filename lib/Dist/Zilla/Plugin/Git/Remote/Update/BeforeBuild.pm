use strict;
use warnings;

package Dist::Zilla::Plugin::Git::Remote::Update::BeforeBuild;

# ABSTRACT: Update a remote with Git before build.

use Moose;

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Dist::Zilla::Plugin::Git::Remote::Update::BeforeBuild",
    "interface":"class",
    "inherits":"Moose::Object",
    "does":[
        "Dist::Zilla::Role::Plugin",
        "Dist::Zilla::Role::BeforeBuild",
        "Dist::Zilla::Role::Git::LocalRepository",
        "Dist::Zilla::Role::Git::RemoteNames",
        "Dist::Zilla::Role::Git::RemoteName",
        "Dist::Zilla::Role::Git::Remote::Update"
    ]
}

=end MetaPOD::JSON

=head1 SYNOPSIS

This Module is mostly intended to be used in conjunction with other things,
and won't on its own provide a lot of useful results.

Having this in your configuration will effectively cause git to run C<git remote update $remotename>
before you build, and remotes don't usually have any impact on things in the rest of DZil-land.

  [Git::Remote::Update::BeforeBuild]
  ; Provided by Dist::Zilla::Role::Git::Remote
  ; String
  ; The name of the remote to update.
  ; Must exist in Git.
  ; default is 'origin'
  remote_name = origin

  ; Provided by Dist::Zilla::Role::Git::Remote::Update
  ; Boolean
  ; turn updating on/off
  ; default is 'on' ( 1 / true )
  do_update = 1

=cut

=role C<Dist::Zilla::Role::BeforeBuild>

Causes this plugin to be executed during L<Dist::Zilla>'s "Before Build" phase.
( L</before_build> )

=cut

=method C<before_build>

Updates the L</remote> via L<Dist::Zilla::Role::Git::Remote::Update/remote_update>, before Building the release.


=role C<Dist::Zilla::Role::Git::LocalRepository>

Provides a L</git> method that returns a C<Git::Wrapper> instance for the
current C<Dist::Zilla> project.


=method C<git>

Returns a L<Git::Wrapper> instance for the current L<Dist::Zilla> projects
C<git> Repository.

=cut

=role C<Dist::Zilla::Role::Git::Remote>

Provides a L</remote> method which always returns a validated C<remote> name,
optionally accepting it being specified manually to something other than
C<origin> via the parameter L</remote_name>

=method C<remote>

Returns a validated remote name. Configured via L</remote_name> parameter.

=cut

=param C<remote_name>

The name of the repository to use as specified in C<.git/config>.

Defaults to C<origin>, which is usually what you want.

=cut

=role C<Dist::Zilla::Role::Git::Remote::Update>

Provides a L</remote_update> method which updates a L</remote> in L</git>

=method C<remote_update>

Performs C<git remote update $remote_name> on L</git> for the remote L</remote>

=param C<do_update>

A boolean value that specifies whether or not to execute the update.

Default value is C<1> / true.

=cut

with 'Dist::Zilla::Role::Plugin';
with 'Dist::Zilla::Role::BeforeBuild';
with 'Dist::Zilla::Role::Git::LocalRepository';
with 'Dist::Zilla::Role::Git::RemoteNames';
with 'Dist::Zilla::Role::Git::RemoteName';
with 'Dist::Zilla::Role::Git::Remote::Update';

sub before_build {
  my $self = shift;
  $self->remote_update;
  return 1;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

