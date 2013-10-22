package Pod::Weaver::Section::Bugs::DefaultRT;

use 5.010001;
use Moose;
use Text::Wrap ();
with 'Pod::Weaver::Role::Section';

#use Log::Any '$log';

use Moose::Autobox;

our $VERSION = '0.01'; # VERSION

sub weave_section {
  my ($self, $document, $input) = @_;

  my ($web,$mailto);
  if ($input->{distmeta}{resources}{bugtracker}) {
      my $bugtracker = $input->{distmeta}{resources}{bugtracker};
      ($web,$mailto) = @{$bugtracker}{qw/web mailto/};
  }
  if (!$web && !$mailto) {
      my $name = $input->{zilla}->name;
      $web = "http://rt.cpan.org/Public/Dist/Display.html?Name=$name";
  }
  my $text = "Please report any bugs or feature requests ";

  if (defined $web) {
    $text .= "on the bugtracker website $web";
    $text .= defined $mailto ? " or " : "\n";
  }

  if (defined $mailto) {
    $text .= "by email to $mailto\.\n";
  }

  $text = Text::Wrap::wrap(q{}, q{}, $text);

  $text .= <<'HERE';

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.
HERE

  $document->children->push(
    Pod::Elemental::Element::Nested->new({
      command  => 'head1',
      content  => 'BUGS',
      children => [
        Pod::Elemental::Element::Pod5::Ordinary->new({ content => $text }),
      ],
    }),
  );
}

no Moose;
1;
# ABSTRACT: Add a BUGS section to refer to bugtracker (or RT as default)

__END__

=pod

=encoding utf-8

=head1 NAME

Pod::Weaver::Section::Bugs::DefaultRT - Add a BUGS section to refer to bugtracker (or RT as default)

=head1 SYNOPSIS

In your C<weaver.ini>:

 [Bugs::DefaultRT]

To specify a bugtracker other than RT (L<http://rt.cpan.org>), in your dist.ini:

 [MetaResources]
 bugtracker=http://example.com/

or to specify email address:

 [MetaResources]
 bugtracker.mailto=someone@example.com

=head1 DESCRIPTION

This section plugin is like L<Pod::Weaver::Section::Bugs>, except that it gives
RT as the default.

=head1 SOURCE

The development version is on github at L<http://github.com/sharyanto/perl-Pod-Weaver-Section-Bugs-DefaultRT>
and may be cloned from L<git://github.com/sharyanto/perl-Pod-Weaver-Section-Bugs-DefaultRT.git>

=for Pod::Coverage weave_section

=head1 SEE ALSO

L<Pod::Weaver::Section::Bugs> which requires us setting C<bugtracker> metadata.

L<Pod::Weaver::Section::BugsRT> which always uses RT.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
http://rt.cpan.org/Public/Dist/Display.html?Name=Pod-Weaver-Section-Bugs-De
faultRT

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
