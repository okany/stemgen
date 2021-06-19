BEGIN rules
len length stem < 2
a-e-ies match suffix eies or aies
ies replace suffix ies y
a-e-o-es match suffix aes or ees or oes
es replace suffix es e
u-s-s match suffix us or ss
s remove suffix s
END rules
#
# stem 
#
BEGIN stem
if len
then set stop 1
else if a-e-ies
then set stop 1
else if ies 
then set word stem
else if a-e-o-es
then set stop 1
else if es 
then set word stem
else if u-s-s 
then set stop 1
else if s 
then set word stem
END stem