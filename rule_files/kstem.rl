BEGIN rules
dash match any -
# plural
ies replace suffix ies ie
ies0 replace suffix ies y
es replace suffix es e
sse match suffix sse
es0 remove suffix es  
s remove suffix s
lgt3 length stem > 3
ous-ss match suffix ous or ss 
# past tense
le4 length stem <= 4
ied replace suffix ied ie
ied0 replace suffix ied y
vow isVowel stem any
ed remove suffix ed
ed0 append suffix e
ed1 append suffix ed
dc match suffix double consonant
rl remove last
un match prefix un
# aspect
le5 length stem <= 5
ing remove suffix ing
ing0 append suffix e
cc match suffix consonant consonant
# ion_endings
ization replace suffix ization ize
ition replace suffix ition it
ation replace suffix ation ate
ation0 replace suffix ation e
ation1 remove suffix ation
ication replace suffix ication y
ion replace suffix ion e
ion0 remove suffix ion
# er_and_or_endings
izer replace suffix izer ize
er remove suffix er
or0 remove suffix or
ier replace suffix ier y
eer remove suffix eer
er0 replace suffix er e
or1 replace suffix or o
or2 replace suffix or e
# ly_endings
ly replace suffix ly le
ly0 remove suffix ly
ally replace suffix ally al
ably replace suffix ably able
ily replace suffix ily y
# al_endings
al remove suffix al
al0 replace suffix al e
al1 replace suffix al um
ical remove suffix ical
ical0 replace suffix ical y
ical1 replace suffix ical ic
ial remove suffix ial
# ive_endings
ive remove suffix ive
ive0 replace suffix ive e
ative replace suffix ative e
ative0 remove suffix ative
ive1 replace suffix ive ion
# ize_endings
ize remove suffix ize
ize0 replace suffix ize e
# ment_endings
ment remove suffix ment
# ity_endings
ity remove suffix ity
ity0 replace suffix ity e
ility replace suffix ility le
ivity replace suffix ivity ive
ality replace suffix ality al
# ble_endings
able remove suffix able
ible remove suffix ible
able0 replace suffix able e
ible0 replace suffix ible e
able1 replace suffix able ate
ible1 replace suffix ible ate
# ness_endings
iness replace suffix iness y
ness remove suffix ness
# ism_endings
ism remove suffix ism
# ic_endings
ic replace suffix ic ical
ic0 replace suffix ic y
ic1 replace suffix ic e
ic2 remove suffix ic
# ncy_endings
ency replace suffix ency ent
ancy replace suffix ancy ant
ency0 replace suffix ency ence
ancy0 replace suffix ancy ance
# nce_endings
ence replace suffix ence e
ance replace suffix ance e
ence0 remove suffix ence
ance0 remove suffix ance
END rules
#
# step plural
#
BEGIN step plural
if ies and lookup stem
then set word stem and set stop 1
else if ies0
then set word stem
else if es and lookup stem and not sse
then set word stem
else if es0 and lookup stem
then set word stem and set stop 1
else if es 
then set word stem
else if lgt3 and not ous-ss and s
then set word stem
END step plural
#
# step past_tense
#
BEGIN step past_tense
if le4
then set word stem
else if ied and lookup stem 
then set word stem and set stop 1
else if ied0
then set word stem
else if ed and vow and ed0 and lookup stem
then set word stem and set stop 1
else if ed and vow and lookup stem
then set word stem and set stop 1
else if ed and vow and dc and rl and lookup stem
then set word stem and set stop 1
else if ed and vow and dc
then set word stem and set stop 1
else if ed and vow and un and ed1
then set word stem
else if ed and vow and ed0
then set word stem
END step past_tense
#
# step aspect
#
BEGIN step aspect
if le5
then set word stem
else if ing and vow and ing0 and lookup stem
then set word stem and set stop 1
else if ing and vow and lookup stem
then set word stem and set stop 1
else if ing and vow and dc and rl and lookup stem 
then set word stem and set stop 1
else if ing and vow and dc
then set word stem
else if ing and vow and cc
then set word stem 
else if ing and vow and ing0
then set word stem 
END step aspect
#
# step ion_endings
#
BEGIN step ion_endings
if ization
then set word stem 
else if ition and lookup stem
then set word stem and set stop 1
else if ation and lookup stem
then set word stem and set stop 1
else if ation0 and lookup stem
then set word stem and set stop 1
else if ation1 and lookup stem
then set word stem and set stop 1
else if ication and lookup stem
then set word stem and set stop 1
else if ion and lookup stem
then set word stem and set stop 1
else if ion0 and lookup stem
then set word stem and set stop 1
END step ion_endings
#
# step er_and_or_endings
#
BEGIN step er_and_or_endings
if izer
then set word stem 
else if er and dc and rl and lookup stem
then set word stem and set stop 1
else if or0 and dc and rl and lookup stem
then set word stem and set stop 1
else if ier and lookup stem
then set word stem and set stop 1
else if eer and lookup stem
then set word stem and set stop 1
else if er0 and lookup stem
then set word stem and set stop 1
else if or1 and lookup stem
then set word stem and set stop 1
else if er and lookup stem
then set word stem and set stop 1
else if or0 and lookup stem
then set word stem and set stop 1
else if or2 and lookup stem
then set word stem and set stop 1
END step er_and_or_endings
#
# step ly_endings
#
BEGIN step ly_endings
if ly and lookup stem
then set word stem and set stop 1
else if ly0 and lookup stem
then set word stem and set stop 1
else if ally
then set word stem
else if ably
then set word stem
else if ily and lookup stem
then set word stem and set stop 1
else if ly0
then set word stem
END step ly_endings
#
# step al_endings
#
BEGIN step al_endings
if al and lookup stem
then set word stem and set stop 1
else if al and dc and rl and lookup stem
then set word stem and set stop 1
else if al0 and lookup stem
then set word stem and set stop 1
else if al1 and lookup stem
then set word stem and set stop 1
else if ical and lookup stem
then set word stem and set stop 1
else if ical0 and lookup stem
then set word stem and set stop 1
else if ical1
then set word stem
else if ial and lookup stem
then set word stem and set stop 1
END step al_endings
#
# step ive_endings
#
BEGIN step ive_endings
if ive and lookup stem
then set word stem and set stop 1
else if ive0 and lookup stem
then set word stem and set stop 1
else if ative and lookup stem
then set word stem and set stop 1
else if ative0 and lookup stem
then set word stem and set stop 1
else if ive1 and lookup stem
then set word stem and set stop 1
END step ive_endings
#
# step ize_endings
#
BEGIN step ize_endings
if ize and lookup stem
then set word stem and set stop 1
else if ize and dc and rl and lookup stem
then set word stem and set stop 1
else if ize0 and lookup stem
then set word stem and set stop 1
END step ize_endings
#
# step ment_endings
#
BEGIN step ment_endings
if ment and lookup stem
then set word stem and set stop 1
END step ment_endings
#
# step ity_endings
#
BEGIN step ity_endings
if ity and lookup stem
then set word stem and set stop 1
else if ity0 and lookup stem
then set word stem and set stop 1
else if ility
then set word stem
else if ivity
then set word stem
else if ality
then set word stem
else if not lookup stem and ity 
then set word stem
END step ity_endings
#
# step ble_endings
#
BEGIN step ble_endings
if able and lookup stem
then set word stem and set stop 1
else if ible and lookup stem
then set word stem and set stop 1
else if able and dc and rl and lookup stem
then set word stem and set stop 1
else if ible and dc and rl and lookup stem
then set word stem and set stop 1
else if able0 and lookup stem
then set word stem and set stop 1
else if ible0 and lookup stem
then set word stem and set stop 1
else if able1 and lookup stem
then set word stem and set stop 1
else if ible1 and lookup stem
then set word stem and set stop 1
END step ble_endings
#
# step ness_endings
#
BEGIN step ness_endings
if iness
then set word stem
else if ness
then set word stem
END step ness_endings
#
# step ism_endings
#
BEGIN step ism_endings
if ism
then set word stem
END step ism_endings
#
# step ic_endings
#
BEGIN step ic_endings
if ic and lookup stem
then set word stem and set stop 1
else if ic0 and lookup stem
then set word stem and set stop 1
else if ic1 and lookup stem
then set word stem and set stop 1
else if ic2 and lookup stem
then set word stem and set stop 1
END step ic_endings
#
# step ncy_endings
#
BEGIN step ncy_endings
if ency and lookup stem
then set word stem and set stop 1
else if ancy and lookup stem
then set word stem and set stop 1
else if ency0
then set word stem
else if ancy0
then set word stem
END step ncy_endings
#
# step nce_endings
#
BEGIN step nce_endings
if ence and lookup stem
then set word stem and set stop 1
else if ance and lookup stem
then set word stem and set stop 1
else if ence0 and lookup stem
then set word stem and set stop 1
else if ance0 and lookup stem
then set word stem and set stop 1
END step nce_endings
#
# stem
#
BEGIN stem
BEGIN iterate
if dash
then break
# plural
if lookup word
then break
else call step plural 
if lookup word
then break
else call step past_tense
if lookup word
then break
else call step aspect
if lookup word
then break
else call step ity_endings
if lookup word
then break
else call step ness_endings
if lookup word
then break
else call step ion_endings
if lookup word
then break
else call step er_and_or_endings
if lookup word
then break
else call step ly_endings
if lookup word
then break
else call step al_endings
if lookup word
then break
else call step ive_endings
if lookup word
then break
else call step ize_endings
if lookup word
then break
else call step ment_endings
if lookup word
then break
else call step ble_endings
if lookup word
then break
else call step ism_endings
if lookup word
then break
else call step ic_endings
if lookup word
then break
else call step ncy_endings
if lookup word
then break
else call step nce_endings
break
END iterate
END stem
