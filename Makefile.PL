use 5.010;
use strict;
use warnings;
use ExtUtils::MakeMaker 6.3002;

WriteMakefile(
    NAME                => 'Number::Closest::XS',
    AUTHOR              => q{Pavel Shaydo <zwon@cpan.org>},
    VERSION_FROM        => 'lib/Number/Closest/XS.pm',
    ABSTRACT_FROM       => 'lib/Number/Closest/XS.pm',
    LICENSE             => 'perl',
    PL_FILES            => {},
    PREREQ_PM => {
    },
    BUILD_REQUIRES => {
        'Test::More' => 0.94,
    },
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 6.3002,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Number-Closest-XS-*' },
    META_MERGE => {
        no_index => {
            file => 'README.pod'
        },
        resources => {

            license    => 'http://dev.perl.org/licenses/',
        },
    },
);
