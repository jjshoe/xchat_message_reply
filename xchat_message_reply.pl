use strict;
use warnings;

use Cwd;

my @bad_users = ();
 
Xchat::register('Auto Reply', '0.1', 'Tell people you do not use pm');

# Load blackhole script 
load_blackhole();

# Initial dialog opening
Xchat::hook_print('Open Dialog', \&initial_contact); 

# Repeated private messages
Xchat::hook_print('Private Message', \&auto_reply);
Xchat::hook_print('Private Message to Dialog', \&auto_reply);
Xchat::hook_print('Private Action', \&auto_reply);
Xchat::hook_print('Private Action to Dialog', \&auto_reply);

# Add a user to the bad user list
Xchat::hook_command('blackhole', \&black_hole); 

# List blackhole list
Xchat::hook_command('list_blackhole', \&list_black_hole);

sub load_blackhole
{
        my $dir = getcwd();
        my $filename = "$dir/.xchat2/blackholed_users.txt";

        if (open(my $fh, '<', $filename))
        {
                chomp(@bad_users = <$fh>);
                close $fh;
        }

        return Xchat::EAT_ALL;
}

sub initial_contact
{
        Xchat::command('say you have started a new dialog with me, I hope you asked before doing so (automated response)');
        return Xchat::EAT_NONE;
}

sub auto_reply 
{
        foreach my $bad_user (@bad_users)
        {
                if (lc(Xchat::strip_code($_[0][0])) eq lc($bad_user))
                {
                        Xchat::command('say You are blacklisted, go away (automated response)');
                        return Xchat::EAT_NONE;
                }
        }
}

sub black_hole
{
        push(@bad_users, $_[1][1]);

        my $dir = getcwd();
        my $filename = "$dir/.xchat2/blackholed_users.txt";

        if (open(my $fh, '>', $filename))
        {
                foreach my $bad_user (@bad_users)
                {
                        print $fh "$bad_user\n";
                }
        }

        return Xchat::EAT_ALL;
}

sub list_black_hole
{
        Xchat::command('echo Black listed users:');

        foreach my $user (@bad_users)
        {
                Xchat::command("echo   $user");
        }

        return Xchat::EAT_ALL;
}
