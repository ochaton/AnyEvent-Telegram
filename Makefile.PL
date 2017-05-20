use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'AnyEvent::Telegram',
    AUTHOR           => q{Vladislav Grubov <vlagrubov@gmail.com>},
    VERSION_FROM     => 'lib/AnyEvent/Telegram.pm',
    ABSTRACT_FROM    => 'lib/AnyEvent/Telegram.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.010,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'AnyEvent::HTTP' => 0,
        'JSON::XS' => 0,
    },
    PREREQ_PM => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'AnyEvent-Telegram-*' },
);
