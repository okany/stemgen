BEGIN rules
# acceptable
vow isVowel stem first
con isConsonant stem first
len2 length stem >= 2
len3 length stem >= 3
hasv match any vowely
# a
ia remove suffix ia 
a remove suffix a 
# b
bb replace suffix bb b
# c
c match suffix c
ytic replace suffix ytic ys
ic remove suffix ic 
nc replace suffix nc nt
#d 
d match suffix d
dd replace suffix dd d
ied replace suffix ied y
ceed replace suffix ceed cess
eed replace suffix eed ee
ed remove suffix ed 
hood remove suffix hood 
# e
e remove suffix e 
# f
lief replace suffix lief liev
if remove suffix if 
# g
g match suffix g
ing remove suffix ing 
iag replace suffix iag y
ag remove suffix ag 
gg replace suffix gg g
# h
h match suffix h
th remove suffix th 
guish replace suffix guish ct
ish remove suffix ish 
# i
i match suffix i 
i0 remove suffix i 
i1 replace suffix i y
# j
j match suffix j
ij replace suffix ij id
fuj replace suffix fuj fus
uj replace suffix uj ud
oj replace suffix oj od
hej replace suffix hej her
verj replace suffix verj vert
misj replace suffix misj mit
nj replace suffix nj nd
j0 replace suffix j s
# l
l match suffix l
ifiabl remove suffix ifiabl 
iabl replace suffix iabl y
abl remove suffix abl 
ibl remove suffix ibl 
bil replace suffix bil bl
cl replace suffix cl c
iful replace suffix iful y
ful remove suffix ful 
ul remove suffix ul 
ial remove suffix ial 
ual remove suffix ual 
al remove suffix al 
ll replace suffix ll l
# m
m match suffix m
ium remove suffix ium 
um remove suffix um 
ism remove suffix ism 
mm replace suffix mm m
# n
n match suffix n
sion replace suffix sion j
xion replace suffix xion ct
ion remove suffix ion 
ian remove suffix ian 
an remove suffix an 
een match suffix een
en remove suffix en 
nn replace suffix nn n
# p
ship remove suffix ship 
pp replace suffix pp p
# r
r match suffix r
er remove suffix er 
ear match suffix ear
ar remove suffix ar 
or0 remove suffix or 
ur remove suffix ur 
rr replace suffix rr r
tr replace suffix tr t
ier replace suffix ier y
# s
s match suffix s
ies replace suffix ies y
sis replace suffix sis s
is remove suffix is 
ness remove suffix ness 
ss match suffix ss
ous remove suffix ous 
us remove suffix us 
s0 remove suffix s 
s1 replace suffix s s
# t
t match suffix t
plicat replace suffix plicat ply
at remove suffix at 
ment remove suffix ment 
ent remove suffix ent 
ant remove suffix ant 
ript replace suffix ript rib
orpt replace suffix orpt orb
duct replace suffix duct duc
sumpt replace suffix sumpt sum
cept replace suffix cept ceiv
olut replace suffix olut olv
sist match suffix sist
ist remove suffix ist 
tt replace suffix tt t
# u
iqu remove suffix iqu 
ogu replace suffix ogu og
# v
v match suffix v
siv replace suffix siv j
eiv match suffix eiv
iv remove suffix iv 
# y
y match suffix y
bly replace suffix bly bl
ily replace suffix ily y
ply match suffix ply 
ly remove suffix ly 
ogy replace suffix ogy og
phy replace suffix phy ph
omy replace suffix omy om
opy replace suffix opy op
ity remove suffix ity 
ety remove suffix ety 
lty replace suffix lty l
istry remove suffix istry 
ary remove suffix ary 
ory remove suffix ory 
ify remove suffix ify 
ncy replace suffix ncy nt
acy remove suffix acy 
# z
iz remove suffix iz 
yz replace suffix yz ys
END rules
#
# step c
#
BEGIN step c
if ytic and vow and len2
then set word stem and set stop 1
else if ytic and con and len3 and hasv
then set word stem and set stop 1
else if ic and vow and len2
then set word stem
else if ic and con and len3 and hasv
then set word stem
else if nc and vow and len2
then set word stem
else if nc and con and len3 and hasv
then set word stem
END step c
#
# step d
#
BEGIN step d
if dd and vow and len2
then set word stem and set stop 1
else if dd and con and len3 and hasv
then set word stem and set stop 1
else if ied and vow and len2
then set word stem
else if ied and con and len3 and hasv
then set word stem
else if ceed and vow and len2
then set word stem and set stop 1
else if ceed and con and len3 and hasv
then set word stem and set stop 1
else if eed and vow and len2
then set word stem and set stop 1
else if eed and con and len3 and hasv
then set word stem and set stop 1
else if ed and vow and len2
then set word stem
else if ed and con and len3 and hasv
then set word stem
else if hood and vow and len2
then set word stem
else if hood and con and len3 and hasv
then set word stem
END step d
#
# step g
#
BEGIN step g
if ing and vow and len2
then set word stem
else if ing and con and len3 and hasv
then set word stem
else if iag and vow and len2
then set word stem and set stop 1
else if iag and con and len3 and hasv
then set word stem and set stop 1
else if ag and vow and len2
then set word stem
else if ag and con and len3 and hasv
then set word stem
else if gg and vow and len2
then set word stem and set stop 1
else if gg and con and len3 and hasv
then set word stem and set stop 1
END step g
#
# step h
#
BEGIN step h
if intact and th and vow and len2
then set word stem and set stop 1
else if intact and th and con and len3 and hasv
then set word stem and set stop 1
else if guish and vow and len2
then set word stem and set stop 1
else if guish and con and len3 and hasv
then set word stem and set stop 1
else if ish and vow and len2
then set word stem
else if ish and con and len3 and hasv
then set word stem
END step h
#
# step i
#
BEGIN step i
if intact and i0 and vow and len2
then set word stem and set stop 1
else if intact and i0 and con and len3 and hasv
then set word stem and set stop 1
else if i1 and vow and len2
then set word stem
else if i1 and con and len3 and hasv
then set word stem
END step i
#
# step j
#
BEGIN step j
if ij and vow and len2
then set word stem and set stop 1
else if ij and con and len3 and hasv
then set word stem and set stop 1
else if fuj and vow and len2
then set word stem and set stop 1
else if fuj and con and len3 and hasv
then set word stem and set stop 1
else if uj and vow and len2
then set word stem and set stop 1
else if uj and con and len3 and hasv
then set word stem and set stop 1
else if oj and vow and len2
then set word stem and set stop 1
else if oj and con and len3 and hasv
then set word stem and set stop 1
else if hej and vow and len2
then set word stem and set stop 1
else if hej and con and len3 and hasv
then set word stem and set stop 1
else if verj and vow and len2
then set word stem and set stop 1
else if verj and con and len3 and hasv
then set word stem and set stop 1
else if misj and vow and len2
then set word stem and set stop 1
else if misj and con and len3 and hasv
then set word stem and set stop 1
else if nj and vow and len2
then set word stem and set stop 1
else if nj and con and len3 and hasv
then set word stem and set stop 1
else if j0 and vow and len2
then set word stem and set stop 1
else if j0 and con and len3 and hasv
then set word stem and set stop 1
END step j
#
# step l
#
BEGIN step l
if ifiabl and vow and len2
then set word stem and set stop 1
else if ifiabl and con and len3 and hasv
then set word stem and set stop 1
else if iabl and vow and len2
then set word stem and set stop 1
else if iabl and con and len3 and hasv
then set word stem and set stop 1
else if abl and vow and len2
then set word stem
else if abl and con and len3 and hasv
then set word stem
else if ibl and vow and len2
then set word stem and set stop 1
else if ibl and con and len3 and hasv
then set word stem and set stop 1
else if bil and vow and len2
then set word stem
else if bil and con and len3 and hasv
then set word stem
else if cl and vow and len2
then set word stem and set stop 1
else if cl and con and len3 and hasv
then set word stem and set stop 1
else if iful and vow and len2
then set word stem and set stop 1
else if iful and con and len3 and hasv
then set word stem and set stop 1
else if ful and vow and len2
then set word stem
else if ful and con and len3 and hasv
then set word stem
else if ul and vow and len2
then set word stem and set stop 1
else if ul and con and len3 and hasv
then set word stem and set stop 1
else if ial and vow and len2
then set word stem
else if ial and con and len3 and hasv
then set word stem
else if ual and vow and len2
then set word stem
else if ual and con and len3 and hasv
then set word stem
else if al and vow and len2
then set word stem
else if al and con and len3 and hasv
then set word stem
else if ll and vow and len2
then set word stem and set stop 1
else if ll and con and len3 and hasv
then set word stem and set stop 1
END step l
#
# step m
#
BEGIN step m
if ium and vow and len2
then set word stem and set stop 1
else if ium and con and len3 and hasv
then set word stem and set stop 1
else if intact and um and vow and len2
then set word stem and set stop 1
else if intact and um and con and len3 and hasv
then set word stem and set stop 1
else if ism and vow and len2
then set word stem 
else if ism and con and len3 and hasv
then set word stem 
else if mm and vow and len2
then set word stem and set stop 1
else if mm and con and len3 and hasv
then set word stem and set stop 1
END step m
#
# step n
#
BEGIN step n
if sion and vow and len2
then set word stem 
else if sion and con and len3 and hasv
then set word stem 
else if xion and vow and len2
then set word stem 
else if xion and con and len3 and hasv
then set word stem 
else if ion and vow and len2
then set word stem 
else if ion and con and len3 and hasv
then set word stem 
else if ian and vow and len2
then set word stem 
else if ian and con and len3 and hasv
then set word stem 
else if an and vow and len2
then set word stem 
else if an and con and len3 and hasv
then set word stem 
else if een
then set word stem and set stop 1 
else if en and vow and len2
then set word stem 
else if en and con and len3 and hasv
then set word stem 
else if nn and vow and len2
then set word stem and set stop 1
else if nn and con and len3 and hasv
then set word stem and set stop 1
END step n
#
# step r
#
BEGIN step r
if er and vow and len2
then set word stem
else if er and con and len3 and hasv
then set word stem
else if ear
then set word stem and set stop 1
else if ar and vow and len2
then set word stem and set stop 1
else if ar and con and len3 and hasv
then set word stem and set stop 1
else if or0 and vow and len2
then set word stem 
else if or0 and con and len3 and hasv
then set word stem 
else if ur and vow and len2
then set word stem 
else if ur and con and len3 and hasv
then set word stem 
else if rr and vow and len2
then set word stem and set stop 1
else if rr and con and len3 and hasv
then set word stem and set stop 1
else if tr and vow and len2
then set word stem 
else if tr and con and len3 and hasv
then set word stem 
else if ier and vow and len2
then set word stem 
else if ier and con and len3 and hasv
then set word stem 
END step r
#
# step s
#
BEGIN step s
if ies and vow and len2
then set word stem
else if ies and con and len3 and hasv
then set word stem
else if sis and vow and len2
then set word stem and set stop 1
else if sis and con and len3 and hasv
then set word stem and set stop 1
else if is and vow and len2
then set word stem 
else if is and con and len3 and hasv
then set word stem 
else if ness and vow and len2
then set word stem 
else if ness and con and len3 and hasv
then set word stem 
else if ss
then set word stem 
else if ous and vow and len2
then set word stem 
else if ous and con and len3 and hasv
then set word stem 
else if intact and us and vow and len2
then set word stem and set stop 1
else if intact and us and con and len3 and hasv
then set word stem and set stop 1
else if intact and s0 and vow and len2
then set word stem
else if intact and s0 and con and len3 and hasv
then set word stem
else if s1
then set word stem and set stop 1
END step s
#
# step t
#
BEGIN step t
if plicat and vow and len2
then set word stem and set stop 1
else if plicat and con and len3 and hasv
then set word stem and set stop 1
else if at and vow and len2
then set word stem 
else if at and con and len3 and hasv
then set word stem 
else if ment and vow and len2
then set word stem 
else if ment and con and len3 and hasv
then set word stem 
else if ent and vow and len2
then set word stem 
else if ent and con and len3 and hasv
then set word stem 
else if ant and vow and len2
then set word stem 
else if ant and con and len3 and hasv
then set word stem 
else if ript and vow and len2
then set word stem and set stop 1
else if ript and con and len3 and hasv
then set word stem and set stop 1
else if orpt and vow and len2
then set word stem and set stop 1
else if orpt and con and len3 and hasv
then set word stem and set stop 1
else if duct and vow and len2
then set word stem 
else if duct and con and len3 and hasv
then set word stem 
else if sumpt and vow and len2
then set word stem 
else if sumpt and con and len3 and hasv
then set word stem 
else if cept and vow and len2
then set word stem 
else if cept and con and len3 and hasv
then set word stem 
else if olut and vow and len2
then set word stem 
else if olut and con and len3 and hasv
then set word stem 
else if sist
then set word stem and set stop 1 
else if ist and vow and len2
then set word stem 
else if ist and con and len3 and hasv
then set word stem 
else if tt and vow and len2
then set word stem and set stop 1
else if tt and con and len3 and hasv
then set word stem and set stop 1
END step t
#
# step v
#
BEGIN step v
if siv and vow and len2
then set word stem 
else if siv and con and len3 and hasv
then set word stem 
else if not eiv and iv and vow and len2
then set word stem 
else if not eiv and iv and con and len3 and hasv
then set word stem 
END step v
#
# step y
#
BEGIN step y
if bly and vow and len2
then set word stem 
else if bly and con and len3 and hasv
then set word stem 
else if ily and vow and len2
then set word stem 
else if ily and con and len3 and hasv
then set word stem 
else if ply
then set word stem and set stop 1  
else if ly and vow and len2
then set word stem 
else if ly and con and len3 and hasv
then set word stem 
else if ogy and vow and len2
then set word stem and set stop 1
else if ogy and con and len3 and hasv
then set word stem and set stop 1
else if phy and vow and len2
then set word stem and set stop 1
else if phy and con and len3 and hasv
then set word stem and set stop 1
else if omy and vow and len2
then set word stem and set stop 1
else if omy and con and len3 and hasv
then set word stem and set stop 1
else if opy and vow and len2
then set word stem and set stop 1
else if opy and con and len3 and hasv
then set word stem and set stop 1
else if ity and vow and len2
then set word stem 
else if ity and con and len3 and hasv
then set word stem 
else if ety and vow and len2
then set word stem 
else if ety and con and len3 and hasv
then set word stem 
else if lty and vow and len2
then set word stem and set stop 1
else if lty and con and len3 and hasv
then set word stem and set stop 1
else if istry and vow and len2
then set word stem and set stop 1
else if istry and con and len3 and hasv
then set word stem and set stop 1
else if ary and vow and len2
then set word stem 
else if ary and con and len3 and hasv
then set word stem 
else if ory and vow and len2
then set word stem 
else if ory and con and len3 and hasv
then set word stem 
else if ify and vow and len2
then set word stem and set stop 1
else if ify and con and len3 and hasv
then set word stem and set stop 1
else if ncy and vow and len2
then set word stem 
else if ncy and con and len3 and hasv
then set word stem 
else if acy and vow and len2
then set word stem 
else if acy and con and len3 and hasv
then set word stem 
END step y
#
# stem
#
BEGIN stem
BEGIN iterate
# a
if intact and ia and vow and len2
then set word stem and set stop 1
else if intact and ia and con and len3 and hasv
then set word stem and set stop 1
else if intact and a and vow and len2
then set word stem and set stop 1 
else if intact and a and con and len3 and hasv
then set word stem and set stop 1 
# b
else if bb and vow and len2
then set word stem and set stop 1
else if bb and con and len3 and hasv
then set word stem and set stop 1
# c
else if c
then call step c
# d
else if d
then call step d
# e
else if e and vow and len2
then set word stem
else if e and con and len3 and hasv
then set word stem
# f
else if lief and vow and len2
then set word stem and set stop 1
else if lief and con and len3 and hasv
then set word stem and set stop 1
else if if and vow and len2
then set word stem
else if if and con and len3 and hasv
then set word stem
# g
else if g
then call step g
# h
else if h
then call step h
# i
else if i
then call step i
# j
else if j
then call step j
# l
else if l
then call step l
# m
else if m
then call step m
# n
else if n
then call step n
# p
else if ship and vow and len2
then set word stem
else if ship and con and len3 and hasv
then set word stem
else if pp and vow and len2
then set word stem and set stop 1
else if pp and con and len3 and hasv
then set word stem and set stop 1
# r
else if r
then call step r
# s
else if s
then call step s
# t
else if t
then call step t
# u
else if iqu and vow and len2
then set word stem and set stop 1
else if iqu and con and len3 and hasv
then set word stem and set stop 1
else if ogu and vow and len2
then set word stem and set stop 1
else if ogu and con and len3 and hasv
then set word stem and set stop 1
# v
else if v
then call step v
# y
else if y
then call step y
# z
else if iz and vow and len2
then set word stem
else if iz and con and len3 and hasv
then set word stem
else if yz and vow and len2
then set word stem and set stop 1
else if yz and con and len3 and hasv
then set word stem and set stop 1
END iterate
END stem