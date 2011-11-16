package MooseX::Types::XMLSchema;

use warnings;
use strict;

use MooseX::Types -declare => [qw(
    xs:string
    xs:integer
    xs:positiveInteger
    xs:nonPositiveInteger
    xs:negativeInteger
    xs:nonNegativeInteger
    xs:long
    xs:unsignedLong 
    xs:int
    xs:unsignedInt
    xs:short 
    xs:unsignedShort 
    xs:byte 
    xs:unsignedByte 
    xs:boolean
    xs:float
    xs:double
    xs:decimal
    xs:duration
    xs:dateTime
    xs:time
    xs:date
    xs:gYearMonth
    xs:gYear
    xs:gMonthDay
    xs:gDay
    xs:gMonth
    xs:base64Binary
    xs:anyURI
    xs:nonPositiveInteger
    xs:negativeInteger
    xs:nonNegativeInteger
    xs:positiveInteger
)];
use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw(
    Str
    Int
    Num
    Bool
    ArrayRef
);

use Regexp::Common qw( number );
use MIME::Base64 qw( encode_base64 );
use Encode qw( encode );
use DateTime::Duration;
use DateTime;
use IO::Handle;
use URI;



=head1 NAME

MooseX::Types::XMLSchema - XMLSchema compatible Moose types library 

=cut

our $VERSION = '0.02';


=head1 SYNOPSIS

    package My::Class;
    use Moose;
    use MooseX::Types::XMLSchema qw( :all );

    has 'string'       => ( is => 'rw', isa => 'xs:string' );
    has 'int'          => ( is => 'rw', isa => 'xs:int' );
    has 'integer'      => ( is => 'rw', isa => 'xs:integer' );
    has 'boolean'      => ( is => 'rw', isa => 'xs:boolean' );
    has 'float'        => ( is => 'rw', isa => 'xs:float' );
    has 'double'       => ( is => 'rw', isa => 'xs:double' );
    has 'decimal'      => ( is => 'rw', isa => 'xs:decimal' );

    has 'integer_co'   => ( is => 'rw', isa => 'xs:integer', coerce => 1 );
    has 'float_co'     => ( is => 'rw', isa => 'xs:float', coerce => 1 );
    has 'double_co'    => ( is => 'rw', isa => 'xs:double', coerce => 1 );
    has 'decimal_co'   => ( is => 'rw', isa => 'xs:decimal', coerce => 1 );

    has 'duration'     => ( is => 'rw', isa => 'xs:duration' );
    has 'datetime'     => ( is => 'rw', isa => 'xs:dateTime' );
    has 'time'         => ( is => 'rw', isa => 'xs:time' );
    has 'date'         => ( is => 'rw', isa => 'xs:date' );
    has 'gYearMonth'   => ( is => 'rw', isa => 'xs:gYearMonth' );
    has 'gYear'        => ( is => 'rw', isa => 'xs:gYear' );
    has 'gMonthDay'    => ( is => 'rw', isa => 'xs:gMonthDay' );
    has 'gDay'         => ( is => 'rw', isa => 'xs:gDay' );
    has 'gMonth'       => ( is => 'rw', isa => 'xs:gMonth' );

    has 'duration_dt'     => ( is => 'rw', isa => 'xs:duration', coerce => 1 );
    has 'datetime_dt'     => ( is => 'rw', isa => 'xs:dateTime', coerce => 1 );
    has 'time_dt'         => ( is => 'rw', isa => 'xs:time', coerce => 1 );
    has 'date_dt'         => ( is => 'rw', isa => 'xs:date', coerce => 1 );
    has 'gYearMonth_dt'   => ( is => 'rw', isa => 'xs:gYearMonth', coerce => 1 );
    has 'gYear_dt'        => ( is => 'rw', isa => 'xs:gYear', coerce => 1 );
    has 'gMonthDay_dt'    => ( is => 'rw', isa => 'xs:gMonthDay', coerce => 1 );
    has 'gDay_dt'         => ( is => 'rw', isa => 'xs:gDay', coerce => 1 );
    has 'gMonth_dt'       => ( is => 'rw', isa => 'xs:gMonth', coerce => 1 );

    has 'base64Binary' => ( is => 'rw', isa => 'xs:base64Binary' );
    has 'base64Binary_io' => ( is => 'rw', isa => 'xs:base64Binary', coerce => 1 );

    has 'anyURI'       => ( is => 'rw', isa => 'xs:anyURI' );
    has 'anyURI_uri'       => ( is => 'rw', isa => 'xs:anyURI', coerce => 1 );

    has 'nonPositiveInteger' => ( is => 'rw', isa => 'xs:nonPositiveInteger' );
    has 'positiveInteger'    => ( is => 'rw', isa => 'xs:positiveInteger' );
    has 'nonNegativeInteger' => ( is => 'rw', isa => 'xs:nonNegativeInteger' );
    has 'negativeInteger'    => ( is => 'rw', isa => 'xs:negativeInteger' );

Then, elsewhere:

    my $object = My::Class->new(
        string          => 'string',
        decimal         => 20.12,
        duration_dt     => DateTime->now - DateTime->(year => 1990),
        base64Binary_io => IO::File->new($0),
    );

=cut

class_type 'Math::BigInt';
class_type 'Math::BigFloat';
class_type 'DateTime::Duration';
class_type 'DateTime';
class_type 'IO::Handle';
class_type 'URI';

=head1 DESCRIPTION

This class provides a number of XMLSchema compatible types for your Moose
classes.

=head1 TYPES

=head2 xs:string

    has 'string'       => ( is => 'rw', isa => 'xs:string' );

A wrapper around built-in Str.

=cut

subtype 'xs:string' =>
    as 'Str';


=head2 xs:integer

    has 'integer'      => ( is => 'rw', isa => 'xs:integer', coerce => 1 );

A L<Math::BigInt> object. Set to coerce from Int.

This is defined in XSchema to be an arbitrary size integer.

=cut

subtype 'xs:integer' =>
    as 'Math::BigInt',
    where { ! $_->is_nan && ! $_->is_inf };

coerce 'xs:integer' => from 'Int', via { new Math::BigInt $_ };

=head2 xs:positiveInteger

    has 'integer' => (
        is => 'rw',
        isa => 'xs:positiveInteger',
        coerce => 1,
    );

A L<Math::BigInt> object. Set to coerce from Int.

This is defined in XSchema to be an arbitrary size integer greater than zero.

=cut

subtype 'xs:positiveInteger' => as 'Math::BigInt', where { $_ > 0 };
coerce 'xs:positiveInteger' => from 'Int', via { new Math::BigInt $_ };

=head2 xs:nonPositiveInteger

    has 'integer' => (
        is => 'rw',
        isa => 'xs:nonPositiveInteger',
        coerce => 1,
    );

A L<Math::BigInt> object. Set to coerce from Int.

This is defined in XSchema to be an arbitrary size integer less than or equal
to zero.

=cut

subtype 'xs:nonPositiveInteger' => as 'Math::BigInt', where { $_ <= 0 };
coerce 'xs:nonPositiveInteger' => from 'Int', via { new Math::BigInt $_ };

=head2 xs:negativeInteger

    has 'integer' => (
        is => 'rw',
        isa => 'xs:negativeInteger',
        coerce => 1,
    );

A L<Math::BigInt> object. Set to coerce from Int.

This is defined in XSchema to be an arbitrary size integer less than zero.

=cut

subtype 'xs:negativeInteger' => as 'Math::BigInt', where { $_ < 0 };
coerce 'xs:negativeInteger' => from 'Int', via { new Math::BigInt $_ };

=head2 xs:nonNegativeInteger

    has 'int' => ( is => 'rw', isa => 'xs:nonNegativeInteger' );


A L<Math::BigInt> object. Set to coerce from Int.

This is defined in XSchema to be an arbitrary size integer greater than or
equal to zero.

=cut

subtype 'xs:nonNegativeInteger' => 
    as 'Math::BigInt',
        where { $_ >= 0 };
coerce 'xs:nonNegativeInteger' => from 'Int', via { new Math::BigInt $_ };

=head2 xs:long

    has 'long' => ( is => 'rw', isa => 'xs:long' );

A 64-bit Integer. Represented as a L<Math::Bigint> object, but limited to the
64-bit (signed) range.

=cut

subtype 'xs:long' =>
    as 'Math::BigInt',
        where { $_ <= 9223372036854775807 && $_ > -9223372036854775808 };
coerce 'xs:long' => from 'Int', via { new Math::BigInt $_ };

=head2 xs:unsignedLong

    has 'long' => ( is => 'rw', isa => 'xs:unsignedLong' );

A 64-bit Integer. Represented as a L<Math::Bigint> object, but limited to the
64-bit (unsigned) range.

=cut

subtype 'xs:unsignedLong' => 
    as 'Math::BigInt',
        where { $_ >= 0 && $_ <= 18446744073709551615 };
coerce 'xs:unsignedLong' => from 'Int', via { new Math::BigInt $_ };

=head2 xs:int

    has 'int' => ( is => 'rw', isa => 'xs:int' );

A 32-bit integer. Represented natively.

=cut

subtype 'xs:int' =>
    as 'Int',
        where { $_ <= 2147483647 && $_ >= -2147483648 };

=head2 xs:unsignedInt

    has 'int' => ( is => 'rw', isa => 'xs:unsignedInt' );

A 32-bit integer. Represented natively.

=cut

subtype 'xs:unsignedInt' =>
    as 'Int',
        where { $_ <= 4294967295 && $_ >= 0};

=head2 xs:short

    has 'int' => ( is => 'rw', isa => 'xs:short' );

A 16-bit integer. Represented natively.

=cut

subtype 'xs:short' => 
    as 'Int',
        where { $_ <= 32767 && $_ >= -32768 };

=head2 xs:unsignedShort

    has 'int' => ( is => 'rw', isa => 'xs:unsignedShort' );

A 16-bit integer. Represented natively.

=cut

subtype 'xs:unsignedShort' => 
    as 'Int',
        where { $_ <= 65535 && $_ >= 0 };

=head2 xs:byte

    has 'int' => ( is => 'rw', isa => 'xs:byte' );

An 8-bit integer. Represented natively.

=cut

subtype 'xs:byte' => 
    as 'Int',
        where { $_ <= 127 && $_ >= -128 };

=head2 xs:unsignedByte

    has 'int' => ( is => 'rw', isa => 'xs:unsignedByte' );

An 8-bit integer. Represented natively.

=cut

subtype 'xs:unsignedByte' => 
    as 'Int',
        where { $_ <= 255 && $_ >= 0 };

=head2 xs:boolean

    has 'boolean'      => ( is => 'rw', isa => 'xs:boolean' );

A wrapper around built-in Bool.

=cut

subtype 'xs:boolean' =>
    as 'Bool';


=head2 xs:float

    has 'float'        => ( is => 'rw', isa => 'xs:float' );

A 64-bit Float. Represented as a L<Math::BigFloat> object, but limited to the
64-bit (unsigned) range.

=cut

subtype 'xs:float' =>
    as 'Math::BigFloat',
    where { ! $_->is_nan && ! $_->is_inf };
coerce 'xs:float' => from 'Num', via { new Math::BigFloat $_ };

=head2 xs:double

    has 'double'       => ( is => 'rw', isa => 'xs:double' );

A 64-bit Float. Represented as a L<Math::BigFloat> object, but limited to the
64-bit (unsigned) range.

=cut

subtype 'xs:double' =>
    as 'Math::BigFloat',
    where { ! $_->is_nan && ! $_->is_inf };
coerce 'xs:double' => from 'Num', via { new Math::BigFloat $_ };

=head2 xs:decimal

    has 'decimal'      => ( is => 'rw', isa => 'xs:decimal' );

A 64-bit Float. Represented as a L<Math::BigFloat> object, but limited to the
64-bit (unsigned) range.

=cut

subtype 'xs:decimal' =>
    as 'Math::BigFloat',
    where { ! $_->is_nan && ! $_->is_inf };
coerce 'xs:decimal' => from 'Num', via { new Math::BigFloat $_ };


=head2 xs:duration

    has 'duration'     => ( is => 'rw', isa => 'xs:duration' );
    has 'duration_dt'  => ( is => 'rw', isa => 'xs:duration', coerce => 1 );

A wrapper around Str.
If you enable coerce you can pass a DateTime::Duration object.

=cut

subtype 'xs:duration' =>
    as 'Str' =>
        where { /^\-?P\d+Y\d+M\d+DT\d+H\d+M\d+S$/ };

coerce 'xs:duration'
    => from 'DateTime::Duration' =>
        via {
            my $is_negative;
            if ($_->is_negative) {
                $is_negative = 1;
                $_ = $_->inverse;
            }
            return sprintf('%sP%dY%dM%dDT%dH%dM%dS',
                $is_negative ? '-' : '',
                $_->in_units(qw(
                    years
                    months
                    days
                    hours
                    minutes
                    seconds
                ))
            );
        };

=head2 xs:datetime

    has 'datetime'    => ( is => 'rw', isa => 'xs:dateTime' );
    has 'datetime_dt' => ( is => 'rw', isa => 'xs:dateTime', coerce => 1 );

A wrapper around Str.
If you enable coerce you can pass a DateTime object.

=cut


subtype 'xs:dateTime' =>
    as 'Str' =>
        where { /^\d{4}\-\d{2}\-\d{2}T\d{2}:\d{2}:\d{2}Z?(?:[\-\+]\d{2}:?\d{2})?$/ };

coerce 'xs:dateTime'
    => from 'DateTime' =>
        via {
            my $tz = $_->strftime("%z");
            if ($tz) {
                $tz =~ s/^[\-\+]0000$/Z/ or
                    $tz =~ s/^([\-\+]\d{2})(\d{2})$/$1:$2/;
            }
            return $_->strftime("%FT%T$tz");
        };


=head2 xs:time

    has 'time'    => ( is => 'rw', isa => 'xs:time' );
    has 'time_dt' => ( is => 'rw', isa => 'xs:time', coerce => 1 );

A wrapper around Str.
If you enable coerce you can pass a DateTime object.

=cut

subtype 'xs:time' =>
    as 'Str' =>
        where { /^\d{2}:\d{2}:\d{2}Z?(?:[\-\+]\d{2}:?\d{2})?$/ };

coerce 'xs:time'
    => from 'DateTime' =>
        via {
            my $tz = $_->strftime("%z");
            if ($tz) {
                $tz =~ s/^[\-\+]0000$/Z/ or
                    $tz =~ s/^([\-\+]\d{2})(\d{2})$/$1:$2/;
            }
            return $_->strftime("%T$tz");
        };


=head2 xs:date

    has 'date'     => ( is => 'rw', isa => 'xs:date' );
    has 'date_dt'  => ( is => 'rw', isa => 'xs:date', coerce => 1 );

A wrapper around Str.
If you enable coerce you can pass a DateTime object.

=cut

subtype 'xs:date' =>
    as 'Str' =>
        where { /^\d{4}\-\d{2}\-\d{2}$/ };

coerce 'xs:date'
    => from 'DateTime' =>
        via {
            return $_->strftime("%F");
        };


=head2 xs:gYearMonth

    has 'gYearMonth'    => ( is => 'rw', isa => 'xs:gYearMonth' );
    has 'gYearMonth_dt' => ( is => 'rw', isa => 'xs:gYearMonth', coerce => 1 );

A wrapper around Str.
If you enable coerce you can pass a DateTime object or a ArrayRef of two
integers.

=cut

subtype '__xs:IntPair' =>
    as 'ArrayRef[Int]' => 
        where { @$_ == 2 };


subtype 'xs:gYearMonth' =>
    as 'Str' =>
        where { /^\d{4}\-\d{2}$/ };

coerce 'xs:gYearMonth'
    => from '__xs:IntPair' =>
        via {
            return sprintf("%02d-%02d", @$_);
        }
    => from 'DateTime' =>
        via {
            return $_->strftime("%Y-%m");
        };


=head2 xs:gYear

    has 'gYear'    => ( is => 'rw', isa => 'xs:gYear' );
    has 'gYear_dt' => ( is => 'rw', isa => 'xs:gYear', coerce => 1 );

A wrapper around Str.
If you enable coerce you can pass a DateTime object.

=cut

subtype 'xs:gYear' =>
    as 'Str' =>
        where { /^\d{4}$/ };

coerce 'xs:gYear'
    => from 'DateTime' =>
        via {
            return $_->strftime("%Y");
        };


=head2 xs:gMonthDay

    has 'gMonthDay'        => ( is => 'rw', isa => 'xs:gMonthDay' );
    has 'gMonthDay_dt' => ( is => 'rw', isa => 'xs:gMonthDay', coerce => 1 );

A wrapper around Str.
If you enable coerce you can pass a DateTime object or a ArrayRef of two
integers.

=cut

subtype 'xs:gMonthDay' =>
    as 'Str' =>
        where { /^\-\-\d{2}\-\d{2}$/ };

coerce 'xs:gMonthDay'
    => from '__xs:IntPair' =>
        via {
            return sprintf("--%02d-%02d", @$_);
        }
    => from 'DateTime' =>
        via {
            return $_->strftime("--%m-%d");
        };


=head2 xs:gDay

    has 'gDay'         => ( is => 'rw', isa => 'xs:gDay' );
    has 'gDay_dt_int'  => ( is => 'rw', isa => 'xs:gDay', coerce => 1 );

A wrapper around Str.
If you enable coerce you can pass a DateTime object or Int eg. 24.

=cut

subtype 'xs:gDay' =>
    as 'Str' =>
        where { /^\-\-\-\d{2}$/ };

coerce 'xs:gDay'
    => from 'Int' =>
        via {
            return sprintf("---%02d", $_);
        }
    => from 'DateTime' =>
        via {
            return $_->strftime("---%d");
        };


=head2 xs:gMonth

    has 'gMonth'        => ( is => 'rw', isa => 'xs:gMonth', coerce => 1 );
    has 'gMonth_dt_int' => ( is => 'rw', isa => 'xs:gMonth', coerce => 1 );

A wrapper around Str.
If you enable coerce you can pass a DateTime object or Int eg. 10.

=cut

subtype 'xs:gMonth' =>
    as 'Str' =>
        where { $_ => /^\-\-\d{2}$/ };

coerce 'xs:gMonth'
    => from 'Int' =>
        via {
            return sprintf("--%02d", $_);
        }
    => from 'DateTime' =>
        via {
            return $_->strftime("--%m");
        };


=head2 xs:base64Binary

    has 'base64Binary'    => ( is => 'rw', isa => 'xs:base64Binary' );
    has 'base64Binary_io' => ( is => 'rw', isa => 'xs:base64Binary', coerce => 1 );

A wrapper around Str.
If you enable coerce you can pass a IO::Handle object - the content of the
file will be encoded to UTF-8 before encoding with base64.

=cut

subtype 'xs:base64Binary' =>
    as 'Str' =>
        where { $_ =~ /^[a-zA-Z0-9=\+]+$/m };

coerce 'xs:base64Binary'
    => from 'IO::Handle' =>
        via {
            local $/;
            my $content = <$_>;
            return encode_base64(encode("UTF-8", $content));
        };


=head2 xs:anyURI

    has 'anyURI'     => ( is => 'rw', isa => 'xs:anyURI' );
    has 'anyURI_uri' => ( is => 'rw', isa => 'xs:anyURI', coerce => 1 );

A wrapper around Str.
If you enable coerce you can pass a URI object.

=cut

subtype 'xs:anyURI' =>
    as 'Str' =>
        where { $_ =~ /^\w+:\/\/.*$/ };

coerce 'xs:anyURI'
    => from 'URI' =>
        via {
            return $_->as_string;
        };


=head2 xs:nonPositiveInteger

    has 'nonPositiveInteger' => ( is => 'rw', isa => 'xs:nonPositiveInteger' );

A wrapper around built-in Int.

=cut

subtype 'xs:nonPositiveInteger' =>
    as 'Int' =>
        where { $_ <= 0 };


=head2 xs:negativeInteger

    has 'negativeInteger' => ( is => 'rw', isa => 'xs:negativeInteger' );

A wrapper around built-in Int.

=cut

subtype 'xs:negativeInteger' =>
    as 'Int' =>
        where { $_ < 0 };


=head2 xs:nonNegativeInteger

    has 'nonNegativeInteger' => ( is => 'rw', isa => 'xs:nonNegativeInteger' );

A wrapper around built-in Int.

=cut

subtype 'xs:nonNegativeInteger' =>
    as 'Int' =>
        where { $_ >= 0 };

=head2 xs:positiveInteger

    has 'positiveInteger'    => ( is => 'rw', isa => 'xs:positiveInteger' );

A wrapper around built-in Int.

=cut

subtype 'xs:positiveInteger' =>
    as 'Int' =>
        where { $_ > 0 };


no Moose::Util::TypeConstraints;
no Moose;


=head1 AUTHOR

Alex J. G. Burzyński, C<< <ajgb at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-types-xmlschema at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Types-XMLSchema>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 COPYRIGHT & LICENSE

Copyright 2009 Alex J. G. Burzyński.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of MooseX::Types::XMLSchema
