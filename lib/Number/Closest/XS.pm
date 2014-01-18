package Number::Closest::XS;
use 5.010;
use strict;
use warnings;
our $VERSION = "0.02";
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

B<Warning:> this is an alpha version. Behaviour is likely to change in the future.

Module provides functions to extract from the list numbers closest to the
given.

=head1 SUBROUTINES

=head2 find_closest_numbers($num, \@list, [$amount])

selects from the I<@list> up to I<$amount> numbers closest to the I<$num>. If
I<$amount> is not specified, is assumed to be 1.  Returns reference to the
array containing found numbers sorted by the distance from the I<$num>.
Distance between C<$num> and C<$x> computed as C<abs($num - $x)>.

=head2 find_closest_numbers_around($num, \@list, [$amount])

selects from the I<@list> up to I<$amount> numbers closest to the I<$num>, but
first tries to ensure that there are numbers from both sides of the I<$num>, so
if $num is 5, @list is 2, 6, 7 and amount is 2 it will return 2 and 6, despite
7 being closer to 5. If I<$amount> is not specified, is assumed to be 2.
Returns reference to the array containing found numbers sorted by the distance
from the I<$num>.  Distance between C<$num> and C<$x> computed as
C<abs($num - $x)>.

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
