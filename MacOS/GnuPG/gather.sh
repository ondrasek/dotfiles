git commit -a -m "Commit before gathering updated dotfiles."
cp -vf ~/.ssh/config .
cp -vf ~/bin/gpg-agent-launch.sh .
cp -vf ~/.gnupg/gpg-agent.conf .
cp -vf ~/.gnupg/gpg.conf
cp -vf ~/Library/LaunchAgents/gpg-agent.plist .
cp -vf ~/Library/LaunchAgents/setenv.GNUPGHOME.plist .
cp -vf ~/Library/LaunchAgents/setenv.GPG_MASTER_KEY_ID.plist .
cp -vf ~/Library/LaunchAgents/setenv.SSH_AUTH_SOCK.plist .
cp -vf ~/Library/LaunchAgents/setenv.TEST.plist .
