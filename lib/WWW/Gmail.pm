#module-starter --module=gmail --author="Daniel Torres" --email=daniel.torres0085@gmail.com
# Aug 27 2012
# wordpress API interface
package WWW::Gmail;
use strict;
use warnings FATAL => 'all';
use Carp qw(croak);
use Moose;
use Data::Dumper;
use Mail::POP3Client;
use Net::SMTP::TLS;

our $VERSION = '1.0';



{
has 'mail', is => 'rw', isa => 'Str',required => 1;	
has 'password', is => 'rw', isa => 'Str',required => 1;	
has pop3  => ( isa => 'Object', is => 'rw', lazy => 1, builder => '_build_pop3' );

sub mailNumber
{
my $self = shift;
my $count = $self->pop3->Count();
return $count;
}

sub deleteMails
{
my $self = shift;

my $count = $self->pop3->Count();
print "mails $count \n";
for my $i (1 .. $count) 
{
  print "Deleting mail $i \n ";
  $self->pop3->Delete($i)
}
$self->pop3->Close();
}


sub getbody
{
my $self = shift;
my ($i) = @_; 
    
my $body = $self->pop3->Body($i); 
$self->pop3->Close();
return $body;
}

sub sendMail
{
my $self = shift;
my ($reciever,$subject,$body) = @_;
my $sender = $self->mail;
my $password = $self->password;
 
my $mailer = new Net::SMTP::TLS('smtp.gmail.com',
	Hello => 'smtp.gmail.com',
	Port => 465,
	User => $sender,
	Password=> $password);
	
$mailer->mail($sender);
$mailer->to($reciever);

$mailer->data;

$mailer->datasend("To: <$reciever> \n");
$mailer->datasend("From: <$sender> \n");
$mailer->datasend("Content-Type: text/html \n");
$mailer->datasend("Subject: $subject");
$mailer->datasend("\n");
$mailer->datasend($body);

$mailer->dataend;
$mailer->quit;
	
}

sub getLinks
{
my $self = shift;    
my $count = $self->pop3->Count();
print "mails $count \n";
my @links = ();
for my $i (1 .. $count) 
{
  print "Getting mail $i \n ";
  my $body = $self->pop3->Body($i);
  print "$body \n";  
  while ($body =~ m@(((http://)|(www\.))\S+[^.,!? ])@g) 
   {push(@links, $1);}     
}
$self->pop3->Close();

return @links;
}


###################################### internal functions ###################

sub _build_pop3 {    
my $self = shift;

my $mail = $self->mail;
my $password = $self->password;

my $pop = new Mail::POP3Client(
	USER     => $mail,
	PASSWORD => $password,
	HOST     => "pop.gmail.com",
	PORT     => 995,
	USESSL   => 'true',
);    
    
return $pop;
}

}

1;


__END__

=head1 NAME

WWW::Gmail - Gmail interface 


=head1 SYNOPSIS


Usage:

use WWW::Gmail;

my $gmail = WWW::Gmail->new( mail => USERNAME@gmail.com,
					password => PASS);
					

=head1 DESCRIPTION

Gmail interface.

=head1 FUNCTIONS

=head2 constructor

    my $gmail = WWW::Gmail->new( mail => USERNAME@gmail.com,
					password => PASS);

=head2 mailNumber

    $total_mails  = $gmail->mailNumber;
	print "total_mails $total_mails \n";

Get the total number of mails

=head2 deleteMails

   $gmail->deleteMails;

Delete all mail in the inbox
   
=head2 getbody

  $body = $gmail->getbody(0);
  print "body $body \n";

Get the body of the mail N (N start in 0)
   
=head2 sendMail

	$subject = 'My subject';
	$body = 'My Body';
	$gmail->sendMail('ANOTHER_MAIL@gmail.com',$subject,$body);	
   
=head2 getLinks
 Internal function         
                  
=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html
=cut

