use strict;
use warnings;

my @bad_users = ();
 
Xchat::register('Auto Reply', '0.1', 'Tell people you do not use pm');

# Initial dialog opening
Xchat::hook_print('Open Dialog', \&initial_contact); 

# Repeated private messages
Xchat::hook_print('Private Message', \&auto_reply);
Xchat::hook_print('Private Message to Dialog', \&auto_reply);
Xchat::hook_print('Private Action', \&auto_reply);
Xchat::hook_print('Private Action to Dialog', \&auto_reply);

# Add a user to the bad user list
Xchat::hook_command('blackhole', \&black_hole); 

sub initial_contact
{
        Xchat::command('say you have started a new dialog with me, I hope you asked before doing so (automated response)');
        return Xchat::EAT_NONE;
}

sub auto_reply 
{
        foreach my $bad_user (@bad_users)
        {
                if (Xchat::strip_code($_[0][0]) eq $bad_user) 
                {
                        Xchat::command('say go away (automated response)');
                        return Xchat::EAT_NONE;
                }
        }
}

sub black_hole
{
        push(@bad_users, $_[1][1]);
        return Xchat::EAT_ALL;
}
