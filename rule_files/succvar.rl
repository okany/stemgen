BEGIN rules
# plural
END rules
#
# stem
#
BEGIN stem
segment reset
BEGIN for-each prefix
if cutoff
then segment add i
else if lookup this
then segment add i
else if successor this > pred and successor this > succ
then segment add i
else if entropy this >= 5
then segment add i
END for-each prefix
set len length word
segment add len
segment get
END stem
