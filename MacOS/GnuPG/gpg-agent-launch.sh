## Create symlink to SSH_AUTH_SOCKET and run gpg-agent.
## Script is intended to be invoked from a launch agent
## (~/Library/LaunchAgents).
## Stolen from: https://jms1.net/yubikey/make-ssh-use-gpg-agent.md

#SSH_AUTH_SOCK_SYMLINK=$(gpgconf --list-dirs agent-ssh-socket)
#[ -z $SSH_AUTH_SOCK_SYMLINK ] && SSH_AUTH_SOCK_SYMLINK=/Users/ondra/.gnupg/S.gpg-agent.ssh
#[ -f $SSH_AUTH_SOCK_SYMLINK -o -d $SSH_AUTH_SOCK_SYMLINK -o -S $SSH_AUTH_SOCK_SYMLINK ] && rm -rf $SSH_AUTH_SOCK_SYMLINK
#ln -sf $SSH_AUTH_SOCK $SOCKET $SSH_AUTH_SOCK_SYMLINK
#export SSH_AUTH_SOCK_SYMLINK

GPG_CONNECT_AGENT=/usr/local/bin/gpg-connect-agent

echo $(date) | tee -a /tmp/gpg-agent-launch.debug
$GPG_CONNECT_AGENT killagent /bye 2>&1 | tee -a /tmp/gpg-agent-launch.debug
$GPG_CONNECT_AGENT /bye 2>&1 | tee -a /tmp/gpg-agent-launch.debug
$GPG_CONNECT_AGENT reloadagent /bye 2>&1 | tee -a /tmp/gpg-agent-launch.debug
echo | tee -a /tmp/gpg-agent-launch.debug
