## Create symlink to SSH_AUTH_SOCKET and run gpg-agent.
## Script is intended to be invoked from a launch agent
## (~/Library/LaunchAgents).
## Stolen from: https://jms1.net/yubikey/make-ssh-use-gpg-agent.md

PREFIX=/usr/local/bin
GPGCONF=$PREFIX/gpgconf
GPG_CONNECT_AGENT=$PREFIX/gpg-connect-agent
DEBUGFILE=/tmp/gpg-agent-launch.debug

## This is the randomly generated socket by launchctl. Difficult to override.
SSH_AUTH_SOCK_SYMLINK=$SSH_AUTH_SOCK
SSH_AUTH_SOCK_TARGET=$($GPGCONF --list-dirs agent-ssh-socket)
rm -rf $SSH_AUTH_SOCK_SYMLINK
ln -sf $SSH_AUTH_SOCK_TARGET $SSH_AUTH_SOCK_SYMLINK

rm  -f $DEBUGFILE
echo $(date) | tee -a $DEBUGFILE
echo SSH_AUTH_SOCK_TARGET: $SSH_AUTH_SOCK_TARGET | tee -a $DEBUGFILE
echo SSH_AUTH_SOCK_SYMLINK: $SSH_AUTH_SOCK_SYMLINK | tee -a $DEBUGFILE
$GPGCONF --list-dirs 2>&1 | tee -a $DEBUGFILE
$GPG_CONNECT_AGENT killagent /bye 2>&1 | tee -a $DEBUGFILE
$GPG_CONNECT_AGENT /bye 2>&1 | tee -a $DEBUGFILE
$GPG_CONNECT_AGENT reloadagent /bye 2>&1 | tee -a $DEBUGFILE
echo | tee -a $DEBUGFILE
