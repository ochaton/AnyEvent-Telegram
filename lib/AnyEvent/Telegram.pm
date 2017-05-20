package AnyEvent::Telegram;

use 5.010;
use strict;
use warnings;

use constant {
	TELEGRAM_URL => 'https://api.telegram.org',
};

use AnyEvent::HTTP;
use JSON::XS;

use utf8;

our $VERSION = '0.01';
our $JSON = JSON::XS->new;
our $AUTOLOAD;

sub new {
	my $pkg = shift;
	my $self = bless { @_ }, $pkg;
	defined $self->{token} or die 'Bot-token is required';
	return $self;
}

sub AUTOLOAD {
	my $self = shift;
	(my $method = $AUTOLOAD) =~ s/.*:://; # remove pkg-name at the beginnning
	$self->request($method, @_);
}

sub request {
	my $self = shift;
	my $method = shift;
	my $cb = pop;
	my (%args) = @_;

	my $q = $self->_make_request($method, %args);

	http_request
		POST => $q->{url},
		body => $q->{body},
		headers => {
			'Content-Type' => 'application/json',
			'Content-Length' => length $q->{body},
		},
		sub {
			my ($b,$hdr) = @_;

			my $data;
			if ($hdr->{'content-type'} eq 'application/json') {
				eval {
					$data = $JSON->decode($b); 1;
				}; if ($@) {
					 warn "JSON-decode failed with $@";
					 $data = { FATAL => $b };
				}
			}

			unless ($hdr->{Status} == 200) {
				warn "Error $hdr->{Status} $hdr->{Reason} $hdr->{URL}";
				return $cb->(undef, $hdr, $data);
			}

			return $cb->(defined $data->{FATAL} ? (undef, $data) : $data);
		}
	;
	return;
}

sub _make_request {
	my ($self, $method, %args) = @_;
	my %res;

	if (ref $args{params} eq 'HASH') {
		my $path = url_escape_path($args{params});
		$res{url} = sprintf "%s/bot%s/%s?%s", TELEGRAM_URL, $self->{token}, $method, $path;
	} else {
		$res{url} = sprintf "%s/bot%s/%s", TELEGRAM_URL, $self->{token}, $method;
	}

	$res{body} = $JSON->encode(\%args);
	return \%res;
}

sub url_escape_path($) {
	my $path = shift;
	utf8::encode($path) if utf8::is_utf8($path);
	$path =~ s{([^A-Za-z0-9\-._~/])}{ sprintf '%%%02X',ord($1) }sge;
	$path;
}

sub url_escape($) {
	my ($string) = @_;
	utf8::encode($string) if utf8::is_utf8($string);
	$string =~ s/([^A-Za-z0-9\-._~])/sprintf('%%%02X',ord($1))/ge;
	return $string;
}

=head1 AUTHOR

Vladislav Grubov, C<< <vlagrubov at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-anyevent-telegram at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=AnyEvent-Telegram>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc AnyEvent::Telegram


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=AnyEvent-Telegram>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/AnyEvent-Telegram>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/AnyEvent-Telegram>

=item * Search CPAN

L<http://search.cpan.org/dist/AnyEvent-Telegram/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2017 Vladislav Grubov.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of AnyEvent::Telegram
