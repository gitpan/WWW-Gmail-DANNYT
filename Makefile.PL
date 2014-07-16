#!perl -w

require 5.008001;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'WWW::Gmail',
    DISTNAME		 => 'WWW-Gmail',
    VERSION_FROM     => 'lib/WWW/Gmail.pm',
    ABSTRACT   		 => 'Gmail from perl',
    AUTHOR           => q{Daniel Torres <daniel.torres@owasp.org>},  
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.008001,
    PREREQ_PM => {
        'Moose' => 0,
        'Mail::POP3Client' => 0,
        'Net::SMTP::TLS' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'WWW-Gmail-*' },
);
