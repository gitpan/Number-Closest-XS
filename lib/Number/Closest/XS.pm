package Number::Closest::XS;
use strict;
use warnings;
our $VERSION = "0.06";
my $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

require XSLoader;
XSLoader::load( "Number::Closest::XS", $XS_VERSION );

use base 'Exporter';
our @EXPORT_OK = qw(find_closest_numbers find_closest_numbers_around);
our %EXPORT_TAGS = (all => [@EXPORT_OK]);

=head1 NAME

Number::Closest::XS - find numbers closest to a given

=head1 VERSION

0.01

=head1 SYNOPSIS

    use Number::Closest::XS qw(:all);
    my $res = find_closest_numbers($num, \@list, $amount);
    my $res2 = find_closest_numbers_around($num, \@list, $amount);

=head1 DESCRIPTION

Module provides functions to extract from the list numbers closest to the
given.

=head1 SUBROUTINES

=head2 find_closest_numbers($num, \@list, [$amount])

selects from the I<@list> up to I<$amount> numbers closest to the I<$num>. If
I<$amount> is not specified, is assumed to be 1.  Returns reference to the
array containing found numbers sorted by the distance from the I<$num>.
Distance between C<$num> and C<$x> computed as C<abs($num - $x)>.

=head2 find_closest_numbers_around($num, \@list, [$amount])

selects from the I<@list> up to I<$amount> numbers closest to the I<$num>.
Tries to select equal amounts of numbers from both sides of the I<$num>, but if
there are not enough numbers from one side will select more numbers from the
other. If I<$amount> is odd, then the last number will be closest to I<$num>,
e.g. if $num is 5, @list is 1, 2, 6, 7, and amount is 3 it will return 2, 6,
and 7, because 7 is closer to 5 than 1.  If I<$amount> is not specified, is
assumed to be 2. Returns reference to the array containing closest numbers
sorted by their values.

=cut

1;

__END__

=head1 SEE ALSO

L<Number::Closest>, L<Number::Closest::NonOO>

=head1 AUTHOR

Pavel Shaydo C<< <zwon at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2014 Pavel Shaydo

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
