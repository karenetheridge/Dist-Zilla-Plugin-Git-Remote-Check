use strict;
use warnings;

use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib/";

{

  package t::Role::Git::Remote::Update;
  use Moose;
  use namespace::autoclean;
  with "Dist::Zilla::Role::Git::Remote::Update";

  sub git    { }
  sub remote { }
  sub log    { }

  __PACKAGE__->meta->make_immutable;
}

use tutil;

strict_nsmap(
  't::Role::Git::Remote::Update',
  [
    do_update     =>,
    git           =>,
    log           =>,
    remote        =>,
    remote_update =>,
    packages_moose( { clean => 1, immutable => 1 } )
  ]
);

done_testing;