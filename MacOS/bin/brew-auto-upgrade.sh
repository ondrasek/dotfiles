# Temp files
PREFIX=brew-upgrade-check-
_CS_DARWIN_USER_TEMP_DIR=/tmp
OUTDATED_FILE=$(mktemp -t $PREFIX)
MAIL_FILE=$(mktemp -t $PREFIX)

BREW=/usr/local/bin/brew
EMAIL=ondrej@krajicek.co
NOTIFICATION=

$BREW update -fv 2>&1
$BREW outdated --greedy 2>&1 1> $OUTDATED_FILE
COUNT=$(wc -l < $OUTDATED_FILE)
SUBJECT="GLAURUNG: No Homebrew package(s) have available upgrades."
[ $COUNT -gt 0 ] && SUBJECT="GLAURUNG: $COUNT Homebrew package(s) to upgrade."

cat > $MAIL_FILE << __EOF__
$(date "+CURRENT DATE/TIME: %Y-%m-%d %H:%M:%S")
Homebrew package(s) with available upgrades: $COUNT
OUTDATED FILE: $OUTDATED_FILE
MAIL FILE: $MAIL_FILE
SUBJECT: $SUBJECT

__EOF__

if [ $COUNT -gt 0 ]; then 
	echo "package(s) with available upgrades:" >> $MAIL_FILE
	cat $OUTDATED_FILE >> $MAIL_FILE
	echo >> $MAIL_FILE
	echo "brew upgrade --greedy --dry-run:" >> $MAIL_FILE
	brew upgrade --greedy --dry-run 2>&1 >> $MAIL_FILE
else
	echo "No package(s) have available upgrades." >> $MAIL_FILE
fi

echo >> $MAIL_FILE
echo "brew cleanup:" >> $MAIL_FILE
$BREW cleanup --prune=2 --dry-run 2>&1 >> $MAIL_FILE

echo
echo The following mail will be sent out to $EMAIL:
cat $MAIL_FILE
cat $MAIL_FILE | mail -s "$SUBJECT" $EMAIL

NOTIFICATION="Homebrew has $COUNT package(s) to upgrade."
NOTIFICATION_TITLE="Homebrew"
NOTIFICATION_SUB="Periodic upgrade check"
NOTIFICATION="display notification \"$NOTIFICATION\" with title \"$NOTIFICATION_TITLE\" subtitle \"$NOTIFICATION_SUB\""
echo $NOTIFICATION
echo $NOTIFICATION | /usr/bin/osascript -i 
