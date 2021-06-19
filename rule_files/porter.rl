#
# replace <prefix|sufix|any|all> <morpheme1> <morpheme2>
# remove <prefix|sufix|any|all> <morpheme> - remove <morpheme> from prefix/suffix/anywhere/all
# remove <first|last> - remove first/last char
# isVowel <first|last|any> - first/last/any character is a vowel
# isConsonant <first|last|any> - first/last/any character is a consonant
# isMeasure <'='|'>'|'>='> <n> - measure equals-to/greater-than/greater-or-equal-to n
# match|isa <prefix|suffix|any> [double] <consonant|vowel|a-z> [or] ...
#
# rules for step 1a
#
BEGIN rules
0a length stem < 3
1a-r1 replace suffix sses ss
1a-r2 replace suffix ies i
1a-r3 replace suffix ss ss
1a-r4 remove suffix s
#
# rules for step 1b
#
1b-c1 isMeasure stem > 0
1b-s1 remove suffix eed
1b-r1 append suffix ee
1b-c2 isVowel stem any
1b-s2 remove suffix ed
1b-c3 isVowel stem any
1b-s3 remove suffix ing
#
# rules for step 1b1
#
1b1-r1 replace suffix at ate 
1b1-r2 replace suffix bl ble 
1b1-r3 replace suffix iz ize
1b1-c4-1 match suffix double consonant
1b1-c4-2 match suffix l or s or z
1b1-r4 remove last
1b1-c5-1 isMeasure stem = 1
1b1-c5-2 match suffix consonant vowely consonant
1b1-c5-3 match suffix w or x or y
1b1-r5 append suffix e
#
# rules for step 1c
#
1c-c1 isVowel stem any
1c-s1 remove suffix y
1c-r1 append suffix i
#
# rules for step 2
#
2-c isMeasure stem > 0
2-s1 remove suffix ational
2-r1 append suffix ate
2-s2 remove suffix tional
2-r2 append suffix tion
2-s3 remove suffix enci
2-r3 append suffix ence
2-s4 remove suffix anci
2-r4 append suffix ance
2-s5 remove suffix izer
2-r5 append suffix ize
2-s6 remove suffix abli
2-r6 append suffix able
2-s7 remove suffix alli
2-r7 append suffix al
2-s8 remove suffix entli
2-r8 append suffix ent
2-s9 remove suffix eli
2-r9 append suffix e
2-s10 remove suffix ousli
2-r10 append suffix ous
2-s11 remove suffix ization
2-r11 append suffix ize
2-s12 remove suffix ation
2-r12 append suffix ate
2-s13 remove suffix ator
2-r13 append suffix ate
2-s14 remove suffix alism
2-r14 append suffix al
2-s15 remove suffix iveness
2-r15 append suffix ive
2-s16 remove suffix fulness
2-r16 append suffix ful
2-s17 remove suffix ousness
2-r17 append suffix ous
2-s18 remove suffix aliti
2-r18 append suffix al
2-s19 remove suffix iviti
2-r19 append suffix ive
2-s20 remove suffix biliti
2-r20 append suffix ble
#
# rules for step 3
#
3-c isMeasure stem > 0
3-s1 remove suffix icate
3-r1 append suffix ic
3-s2 remove suffix ative
3-s3 remove suffix alize
3-r3 append suffix al
3-s4 remove suffix iciti
3-r4 append suffix ic
3-s5 remove suffix ical
3-r5 append suffix ic
3-s6 remove suffix ful
3-s7 remove suffix ness
#
# rules for step 4
#
4-c isMeasure stem > 1
4-s1 remove suffix al
4-s2 remove suffix ance
4-s3 remove suffix ence
4-s4 remove suffix er
4-s5 remove suffix ic
4-s6 remove suffix able
4-s7 remove suffix ible ee
4-s8 remove suffix ant
4-s9 remove suffix ement
4-s10 remove suffix ment
4-s11 remove suffix ent
4-c12 match suffix s or t
4-s12 remove suffix ion
4-s13 remove suffix ou
4-s14 remove suffix ism
4-s15 remove suffix ate
4-s16 remove suffix iti
4-s17 remove suffix ous
4-s18 remove suffix ive
4-s19 remove suffix ize
#
# rules for 5a
#
5a-c1 isMeasure stem > 1
5a-c2-1 isMeasure stem = 1
5a-c2-2 match suffix consonant vowely consonant
5a-c2-3 match suffix w or x or y
5a-s remove suffix e
#
# rules for 5b
#
5b-c1-1 isMeasure stem > 1
5b-c1-2 match suffix double l
5b-s1 remove last
END rules
#
# STEPS
#
#
# step 1a
#
BEGIN step 1a
if 0a
then set word stem set stop 1
else if 1a-r1
then set word stem
else if 1a-r2
then set word stem
else if 1a-r3
then set word stem
else if 1a-r4
then set word stem
END step 1a
#
# step 1b
#
BEGIN step 1b
if 1b-s1
then if 1b-c1
     then 1b-r1 and set word stem
else if 1b-s2 and 1b-c2
then set word stem and call step 1b1
else if 1b-s3 and 1b-c3
then set word stem and call step 1b1
END step 1b
#
# step 1b1
#
BEGIN step 1b1
if 1b1-r1
then set word stem
else if 1b1-r2
then set word stem
else if 1b1-r3
then set word stem
else if 1b1-c4-1 and not 1b1-c4-2 
then 1b1-r4 and set word stem
else if 1b1-c5-1 and 1b1-c5-2 and not 1b1-c5-3
then 1b1-r5 and set word stem
END step 1b1
#
# step 1c
#
BEGIN step 1c
if 1c-s1 and 1c-c1
then 1c-r1 and set word stem
END step 1c
#
# step 2
#
BEGIN step 2
if 2-s1
then if 2-c
     then 2-r1 and set word stem
else if 2-s2 and 2-c
then 2-r2 and set word stem
else if 2-s3 and 2-c
then 2-r3 and set word stem
else if 2-s4 and 2-c
then 2-r4 and set word stem
else if 2-s5 and 2-c
then 2-r5 and set word stem
else if 2-s6 and 2-c
then 2-r6 and set word stem
else if 2-s7 and 2-c
then 2-r7 and set word stem
else if 2-s8 and 2-c
then 2-r8 and set word stem
else if 2-s9 and 2-c
then 2-r9 and set word stem
else if 2-s10 and 2-c
then 2-r10 and set word stem
else if 2-s11
then if 2-c
     then 2-r11 and set word stem
else if 2-s12 and 2-c
then 2-r12 and set word stem
else if 2-s13 and 2-c
then 2-r13 and set word stem
else if 2-s14 and 2-c
then 2-r14 and set word stem
else if 2-s15 and 2-c
then 2-r15 and set word stem
else if 2-s16 and 2-c
then 2-r16 and set word stem
else if 2-s17 and 2-c
then 2-r17 and set word stem
else if 2-s18 and 2-c
then 2-r18 and set word stem
else if 2-s19 and 2-c
then 2-r19 and set word stem
else if 2-s20 and 2-c
then 2-r20 and set word stem
END step 2
#
# step 3
#
BEGIN step 3
if 3-s1 and 3-c
then 3-r1 and set word stem
else if 3-s2 and 3-c
then set word stem
else if 3-s3 and 3-c
then 3-r3 and set word stem
else if 3-s4 and 3-c
then 3-r4 and set word stem
else if 3-s5 and 3-c
then 3-r5 and set word stem
else if 3-s6 and 3-c
then set word stem
else if 3-s7 and 3-c
then set word stem
END step 3
#
# step 4
#
BEGIN step 4
if 4-s1 and 4-c
then set word stem
else if 4-s2 and 4-c
then set word stem
else if 4-s3 and 4-c
then set word stem
else if 4-s4 and 4-c
then set word stem
else if 4-s5 and 4-c
then set word stem
else if 4-s6 and 4-c
then set word stem
else if 4-s7 and 4-c
then set word stem
else if 4-s8 and 4-c
then set word stem
else if 4-s9
then if 4-c
     then set word stem
else if 4-s10
then if 4-c
     then set word stem
else if 4-s11 and 4-c
then set word stem
else if 4-s12 and 4-c and 4-c12
then set word stem
else if 4-s13 and 4-c
then set word stem
else if 4-s14 and 4-c
then set word stem
else if 4-s15 and 4-c
then set word stem
else if 4-s16 and 4-c
then set word stem
else if 4-s17 and 4-c
then set word stem
else if 4-s18 and 4-c
then set word stem
else if 4-s19 and 4-c
then set word stem
END step 4
#
# step 5a
#
BEGIN step 5a
if 5a-s and 5a-c1
then set word stem
else if 5a-s and 5a-c2-1 and 5a-c2-2 and not 5a-c2-3
then set word stem
END step 5a
#
# step 5b
#
BEGIN step 5b
if 5b-c1-1 and 5b-c1-2
then 5b-s1 and set word stem
END step 5b
#
# stem 
#
BEGIN stem
call step 1a
call step 1b
call step 1c
call step 2
call step 3
call step 4
call step 5a
call step 5b
END stem