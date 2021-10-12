# GNUPG
export GNUPGHOME=~/.gnupg
export GPG_MASTER_KEY_ID=0xD25CFDABC5A100AD
export GPG_SIGN_KEY_ID=0x26088861F65BDC2D
export GPG_ENCR_KEY_ID=0xCCE14FD8925623BC
export GPG_AUTH_KEY_ID=0xABD9E29E1FFF3490
export GPG_TTY=$(tty)

gpg-connect-agent updatestartuptty /bye 2>&1 > /dev/null
gpg-connect-agent reloadagent /bye 2>&1 > /dev/null
