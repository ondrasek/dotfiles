LRTFILE=~/.run/brew-outdated.lastRunTime
ONEDAYAGO=$(gdate -d 'now - 1 day' +%s)
LRT=0

echo
[ -r $LRTFILE ] && LRT=$(gdate -r $LRTFILE +%s)
[ $LRT -lt $ONEDAYAGO ] || { 
	echo "$0: No need to check for outdated brew packages now, will do again tomorrow."; 
	return;
}

echo $0: Checking for outdated brew packages...
touch $LRTFILE

brew update > /dev/null 2>&1
COUNT=`brew outdated | wc -l`
if [ $COUNT -gt 0 ]; then
	echo $0: $COUNT packages have pending upgrades.
else
	echo $0: No packages have pending updates.
fi

echo
