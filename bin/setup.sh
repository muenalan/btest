#!/usr/bin/perl

use Env qw($CONFIGURE_PKGNAME); 

die 'Need env $CONFIGURE_PKGNAME' unless $CONFIGURE_PKGNAME;

my @files = qx{find . -name configure_package | grep -v packages};

for( @files )
   {
       
       chomp; 

       $a=$_; 

       $a=~s/configure_package/$CONFIGURE_PKGNAME/gm; 

       print qq{mv $_ $a\n};
   }
