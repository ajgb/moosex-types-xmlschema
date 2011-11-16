
use strict;
use warnings;

use Test::More tests => 110;
use Test::Exception;

use Math::BigFloat;
use Math::BigInt;
use DateTime;
use DateTime::Duration;
use IO::File;
use URI;

{
    package TestTypesXMLSchema;
    use Moose;

    use MooseX::Types::XMLSchema qw( :all );

    has 'string'       => ( is => 'rw', isa => 'xs:string' );
    has 'int'          => ( is => 'rw', isa => 'xs:int' );
    has 'integer'      => ( is => 'rw', isa => 'xs:integer' );
    has 'integer_co'   => ( is => 'rw', isa => 'xs:integer', coerce => 1 );
    has 'posint'       => ( is => 'rw', isa => 'xs:unsignedInt' );
    has 'boolean'      => ( is => 'rw', isa => 'xs:boolean' );
    has 'float'        => ( is => 'rw', isa => 'xs:float' );
    has 'double'       => ( is => 'rw', isa => 'xs:double' );
    has 'decimal'      => ( is => 'rw', isa => 'xs:decimal' );
    has 'float_co'        => ( is => 'rw', isa => 'xs:float', coerce => 1 );
    has 'double_co'       => ( is => 'rw', isa => 'xs:double', coerce => 1 );
    has 'decimal_co'      => ( is => 'rw', isa => 'xs:decimal', coerce => 1 );

    has 'duration'     => ( is => 'rw', isa => 'xs:duration' );
    has 'datetime'     => ( is => 'rw', isa => 'xs:dateTime' );
    has 'time'         => ( is => 'rw', isa => 'xs:time' );
    has 'date'         => ( is => 'rw', isa => 'xs:date' );
    has 'gYearMonth'   => ( is => 'rw', isa => 'xs:gYearMonth' );
    has 'gYear'        => ( is => 'rw', isa => 'xs:gYear' );
    has 'gMonthDay'    => ( is => 'rw', isa => 'xs:gMonthDay' );
    has 'gDay'         => ( is => 'rw', isa => 'xs:gDay' );
    has 'gMonth'       => ( is => 'rw', isa => 'xs:gMonth' );

    has 'duration_co'     => ( is => 'rw', isa => 'xs:duration', coerce => 1 );
    has 'datetime_co'     => ( is => 'rw', isa => 'xs:dateTime', coerce => 1 );
    has 'time_co'         => ( is => 'rw', isa => 'xs:time', coerce => 1 );
    has 'date_co'         => ( is => 'rw', isa => 'xs:date', coerce => 1 );
    has 'gYearMonth_co'   => ( is => 'rw', isa => 'xs:gYearMonth', coerce => 1 );
    has 'gYear_co'        => ( is => 'rw', isa => 'xs:gYear', coerce => 1 );
    has 'gMonthDay_co'    => ( is => 'rw', isa => 'xs:gMonthDay', coerce => 1 );
    has 'gDay_co'         => ( is => 'rw', isa => 'xs:gDay', coerce => 1 );
    has 'gMonth_co'       => ( is => 'rw', isa => 'xs:gMonth', coerce => 1 );

    has 'base64Binary' => ( is => 'rw', isa => 'xs:base64Binary' );
    has 'base64Binary_co' => ( is => 'rw', isa => 'xs:base64Binary', coerce => 1 );

    has 'anyURI'       => ( is => 'rw', isa => 'xs:anyURI' );
    has 'anyURI_uri'       => ( is => 'rw', isa => 'xs:anyURI', coerce => 1 );

    has 'nonPositiveInteger' => ( is => 'rw', isa => 'xs:nonPositiveInteger' );
    has 'positiveInteger'    => ( is => 'rw', isa => 'xs:positiveInteger' );
    has 'nonNegativeInteger' => ( is => 'rw', isa => 'xs:nonNegativeInteger' );
    has 'negativeInteger'    => ( is => 'rw', isa => 'xs:negativeInteger' );

}

ok my $o = TestTypesXMLSchema->new(), 'created base object';

diag "xs:string";
lives_ok { $o->string('text value') } 'valid xs:string <- text';
is $o->string, 'text value', '...value correct';

diag "xs:int";
lives_ok { $o->int(123) } 'valid xs:int<- 123';
is $o->int, 123, '...value correct';
dies_ok { $o->int('text') } 'invalid xs:int<- text';

diag "xs:integer";
lives_ok { $o->integer( new Math::BigInt 123 ) } 'valid xs:integer <- Math::BigInt(123)';
is $o->integer, 123, '...value correct';
lives_ok { $o->integer_co( 123 ) } 'valid xs:integer <- 123 (coerce)';
is $o->integer, 123, '...value correct';
dies_ok { $o->integer('text') } 'invalid xs:integer <- text';
dies_ok { $o->integer_co('text') } 'invalid xs:integer <- text (coerce)';
isa_ok($o->integer, 'Math::BigInt', '$o->integer');
isa_ok($o->integer_co, 'Math::BigInt', '$o->integer_co (coerce)');

diag "xs:unsignedint";
lives_ok { $o->posint(123) } 'valid xs:unsignedInt <- 123';
is $o->posint, 123, '...value correct';
dies_ok { $o->posint('text') } 'invalid xs:unsignedInt <- text';
dies_ok { $o->posint(-1) } ' invalid xs:unsignedInt <- -1';
my $too_big = 2 ** 32;
dies_ok { $o->posint($too_big) } " invalid xs:unsignedInt <- $too_big";

diag "xs:boolean";
lives_ok { $o->boolean(1) } 'valid xs:boolean <- 1';
is $o->boolean, 1, '...value correct';
dies_ok { $o->boolean('false') } 'invalid xs:boolean <- false';

diag "xs:float";
lives_ok { $o->float( new Math::BigFloat 123.4567) } 'valid xs:float <- 123.4567';
is $o->float, 123.4567, '...value correct';
lives_ok { $o->float_co(123.4567) } 'valid xs:float <- 123.4567 (coerce)';
is $o->float_co, 123.4567, '...value correct';
lives_ok { $o->float( new Math::BigFloat 12.78e-2) } 'valid xs:float <- 12.78e-2';
is $o->float, 12.78e-2, '...value correct';
dies_ok { $o->float_co( '12.78f-2') } 'invalid xs:float <- 12.78f-2';

diag "xs:double";
lives_ok { $o->double( new Math::BigFloat 123.4567) } 'valid xs:double <- 123.4567';
is $o->double, 123.4567, '...value correct';
lives_ok { $o->double_co(123.4567) } 'valid xs:double <- 123.4567 (coerce)';
is $o->double, 123.4567, '...value correct';
lives_ok { $o->double( new Math::BigFloat 12.78e-2) } 'valid xs:double <- 12.78e-2';
is $o->double, 12.78e-2, '...value correct';
dies_ok { $o->double( new Math::BigFloat '12.78f-2') } 'invalid xs:double <- 12.78f-2';

diag "xs:decimal";
lives_ok { $o->decimal( new Math::BigFloat 123.45) } 'valid xs:decimal <- 123.45';
is $o->decimal, 123.45, '...value correct';
lives_ok { $o->decimal_co(123.45) } 'valid xs:decimal <- 123.45 (coerce)';
is $o->decimal, 123.45, '...value correct';
lives_ok { $o->decimal( new Math::BigFloat 12.3456e+2) } 'valid xs:decimal <- 12.3456e+2';
is $o->decimal, 12.3456e+2, '...value correct';

diag "xs:duration";
my $duration = DateTime::Duration->new(
    years => 3,
    days => 15,
    seconds => 37,
);
my $dt1 = DateTime->new( year   => 1964,
                       month  => 10,
                       day    => 16,
                       hour   => 16,
                       minute => 12,
                       second => 47,
                       time_zone  => 'America/Chicago',
                     );
my $dt2 = DateTime->new( year   => 1964,
                       month  => 12,
                       day    => 26,
                       hour   => 16,
                       minute => 36,
                       second => 24,
                       time_zone  => 'America/Chicago',
                     );
 
dies_ok { $o->duration( '3 years' ) } 'invalid xs:duration <- Str';
dies_ok { $o->duration( $duration ) } 'invalid xs:duration <- DateTime::Duration';
lives_ok { $o->duration( 'P3Y0M15DT0H0M37S' ) } 'valid xs:duration <- Str';
is $o->duration, 'P3Y0M15DT0H0M37S', '...value correct';
lives_ok { $o->duration_co( $duration ) } 'valid xs:duration <- DateTime::Duration';
is $o->duration_co, 'P3Y0M15DT0H0M37S', '...value correct';
lives_ok { $o->duration_co( $dt1 - $dt2 ) } 'valid xs:duration <- DateTime1 - DateTime2';
is $o->duration_co, '-P0Y2M10DT0H23M37S', '...value correct';

diag "xs:datetime";
lives_ok { $o->datetime( '1964-10-16T16:12:47-05:00' ) } 'valid xs:dateTime <- Str';
is $o->datetime, '1964-10-16T16:12:47-05:00', '...value correct';
lives_ok { $o->datetime_co( $dt1 ) } 'valid xs:dateTime <- DateTime';
is $o->datetime_co, '1964-10-16T16:12:47-05:00', '...value correct';

$dt1->set_time_zone('Asia/Tokyo');
lives_ok { $o->datetime_co( $dt1 ) } 'valid xs:dateTime <- DateTime(Tokyo)';
is $o->datetime_co, '1964-10-17T06:12:47+09:00', '...value correct';

$dt1->set_time_zone('UTC');
lives_ok { $o->datetime_co( $dt1 ) } 'valid xs:dateTime <- DateTime(UTC)';
is $o->datetime_co, '1964-10-16T21:12:47Z', '...value correct';

diag "xs:time";
lives_ok { $o->time( '06:12:47+09:00' ) } 'valid xs:time <- Str';
is $o->time, '06:12:47+09:00', '...value correct';
$dt1->set_time_zone('Asia/Tokyo');
lives_ok { $o->time_co( $dt1 ) } 'valid xs:time <- DateTime';
is $o->time_co, '06:12:47+09:00', '...value correct';

diag "xs:date";
lives_ok { $o->date( '1964-10-16' ) } 'valid xs:date <- Str';
is $o->date, '1964-10-16', '...value correct';
$dt1->set_time_zone('UTC');
lives_ok { $o->date_co( $dt1 ) } 'valid xs:date <- DateTime';
is $o->date_co, '1964-10-16', '...value correct';

diag "xs:gYearMonth";
lives_ok { $o->gYearMonth( '1964-10' ) } 'valid xs:gYearMonth <- Str';
is $o->gYearMonth, '1964-10', '...value correct';
lives_ok { $o->gYearMonth_co( [1856, 4] ) } 'valid xs:gYearMonth <- ArrayRef';
is $o->gYearMonth_co, '1856-04', '...value correct';
lives_ok { $o->gYearMonth_co( $dt1 ) } 'valid xs:gYearMonth <- DateTime';
is $o->gYearMonth_co, '1964-10', '...value correct';

diag "xs:gYear";
lives_ok { $o->gYear( '1964' ) } 'valid xs:gYear <- Str';
is $o->gYear, '1964', '...value correct';
lives_ok { $o->gYear_co( $dt1 ) } 'valid xs:gYear <- DateTime';
is $o->gYear_co, '1964', '...value correct';

diag "xs:gMonthDay";
lives_ok { $o->gMonthDay( '--10-16' ) } 'valid xs:gMonthDay <- Str';
is $o->gMonthDay, '--10-16', '...value correct';
lives_ok { $o->gMonthDay_co( [4, 3] ) } 'valid xs:gMonthDay <- ArrayRef';
is $o->gMonthDay_co, '--04-03', '...value correct';
lives_ok { $o->gMonthDay_co( $dt1 ) } 'valid xs:gMonthDay <- DateTime';
is $o->gMonthDay_co, '--10-16', '...value correct';

diag "xs:gDay";
lives_ok { $o->gDay( '---16' ) } 'valid xs:gDay <- Str';
is $o->gDay, '---16', '...value correct';
lives_ok { $o->gDay_co( 16 ) } 'valid xs:gDay <- Int';
is $o->gDay_co, '---16', '...value correct';
lives_ok { $o->gDay_co( $dt1 ) } 'valid xs:gDay <- DateTime';
is $o->gDay_co, '---16', '...value correct';

diag "xs:gMonth";
lives_ok { $o->gMonth( '--10' ) } 'valid xs:gMonth <- Str';
is $o->gMonth, '--10', '...value correct';
lives_ok { $o->gMonth_co( $dt1 ) } 'valid xs:gMonth <- DateTime';
is $o->gMonth_co, '--10', '...value correct';


diag "xs:base64Binary";
my $fh = IO::File->new($0, "r");
lives_ok { $o->base64Binary_co( $fh ) } 'valid xs:base64Binary <- IO::File';
like $o->base64Binary_co, qr/^[a-zA-Z0-9=\+]+$/m, '...value correct';


diag "xs:anyURI";
lives_ok { $o->anyURI( 'http://www.perl.org/?username=foo&password=bar' ) } 'valid xs:anyURI <- Str';
is $o->anyURI, 'http://www.perl.org/?username=foo&password=bar', '...value correct';

my $uri = URI->new('http://www.perl.org/');
$uri->query_form( username => 'foo', password => 'bar');
lives_ok { $o->anyURI_uri( $uri ) } 'valid xs:anyURI <- URI';
is $o->anyURI_uri, 'http://www.perl.org/?username=foo&password=bar', '...value correct';


diag "xs:nonPositiveInteger";
lives_ok { $o->nonPositiveInteger( -123 ) } 'valid xs:nonPositiveInteger <- Int';
is $o->nonPositiveInteger, -123, '...value correct';
dies_ok { $o->nonPositiveInteger( 123 ) } 'invalid xs:nonPositiveInteger <- Int';

diag "xs:positiveInteger";
lives_ok { $o->positiveInteger( 123 ) } 'valid xs:positiveInteger <- Int';
is $o->positiveInteger, 123, '...value correct';
dies_ok { $o->positiveInteger( -123 ) } 'invalid xs:positiveInteger <- Int';

diag "xs:nonNegativeInteger";
lives_ok { $o->nonNegativeInteger( 123 ) } 'valid xs:nonNegativeInteger <- Int';
is $o->nonNegativeInteger, 123, '...value correct';
dies_ok { $o->nonnegativeInteger( -123 ) } 'invalid xs:nonnegativeInteger <- Int';

diag "xs:negativeInteger";
lives_ok { $o->negativeInteger( -123 ) } 'valid xs:negativeInteger <- Int';
is $o->negativeInteger, -123, '...value correct';
dies_ok { $o->negativeInteger( 123 ) } 'invalid xs:negativeInteger <- Int';



