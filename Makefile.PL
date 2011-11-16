use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'MooseX::Types::XMLSchema',
    AUTHOR              => q{Alex J. G. Burzyński <ajgb@cpan.org>},
    VERSION_FROM        => 'lib/MooseX/Types/XMLSchema.pm',
    ABSTRACT_FROM       => 'lib/MooseX/Types/XMLSchema.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => '0.92',
        'MooseX::Types' => '0.20',
        'Regexp::Common' => '2.12',
        'MIME::Base64' => '3.07',
        'Encode' => 0,
        'DateTime' => '0.50',
        'IO::Handle' => '1.27',
        'URI' => '1.37',
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'MooseX-Types-XMLSchema-*' },
);
