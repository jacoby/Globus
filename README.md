# Globus

Perl module that uses the Globus SSH API

## What is Globus?

[Globus](https://www.globus.org/) is a project created to allow researchers to easily share data 
across organizations and even continents.

Roughly speaking, you create an **endpoint**, which could be an organization's large file server 
or simply your laptop, as long as it holds your data. You then grant **permission** to another 
user and indicate what directory in that endpoint you want to share. 

That user is notified that this permission has been granted, then starts a **transfer** of the 
contents of that directory to another endpoint. 

## What is Globus.pm?

Globus exports two APIs: a REST API and one based on SSH. I had need to automate the creation 
of endpoints and the granting of permissions, so I wrote a Perl module to allow me to do so, 
and because getting going was easier with the [SSH API](https://docs.globus.org/cli/), 
I wrote it using Net::OpenSSH. 

## Dependencies

+ [Perl](https://www.perl.org/)
+ [Net::OpenSSH](https://metacpan.org/pod/Net::OpenSSH)

## To-Do

Since this tool was written to "scratch my itch", the module only includes functions I needed for
my project. I intend to add functionality.

I have only tested this code on Linux machines. I expect this to be just as cross-platform as Perl
and Net::OpenSSH, but cannot prove it yet.

I also intend, eventually, to put this on cpan as *Net::Globus*.

## Installation

As of this moment, installation is copying the Globus.pm file into your personal lib directory and 
setting use lib and use Globus.

## Configuration

Your account information is managed by GlobusID.org, and this includes setting your SSH keys. 
Within your application, you will need to set your Globus username and the path to your SSH keys.

For example:
```perl
    use lib '/home/globus_user/lib' ;
    use Globus ;
    my $g        = Globus->new() ;
    my $username = 'globus_user' ;
    $g->set_key_path('/home/globus_user/.ssh/id_globus') ;
```

## Documentation

More info in perldoc.
