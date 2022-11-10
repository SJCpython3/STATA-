cd "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021"
use "Aug11_CITY21_Completes_MC (Combined Draft 02) 210811.dta", clear
save "CityStatsWorking.dta", replace
use "CityStatsWorking.dta", clear

tab yob
replace yob = 999 if yob == .
replace yob = 999 if yob < 1900
gen agey=2021-yob if yob > 999
tab agey
gen age_wt=1 if agey>17 & agey <25
replace age_wt=2 if agey>24 & agey <35
replace age_wt=3 if agey>34 & agey <45
replace age_wt=4 if agey>44 & agey <55
replace age_wt=5 if agey>54 & agey <65
replace age_wt=6 if agey>64 & agey <888
replace age_wt=. if agey==.
tab age_wt

tab educat
replace educat = 999 if educat == .
gen educ_wt = 1 if educat <= 3
replace educ_wt = 2 if educat >= 4 & educat <= 5
replace educ_wt = 3 if educat >= 6 & educat <= 7
replace educ_wt = . if educat >= 888
tab educ_wt

tab1 hisp
replace hisp = 999 if hisp == .
tab1 RACE_*
gen race = 3
replace RACE_1 = 0 if RACE_1 == .
replace RACE_2 = 0 if RACE_2 == .
replace RACE_3 = 0 if RACE_3 == .
replace RACE_4 = 0 if RACE_4 == .
replace RACE_5 = 0 if RACE_5 == .
tab1 RACE_*
replace race = 1 if hisp != 1 & (RACE_1 == 0 | RACE_1 == 1 | RACE_1 == 999) & (RACE_2 == 0 | RACE_2 == 1 | RACE_2 == 999) & ///
	(RACE_3 == 0 | RACE_3 == 1 | RACE_3 == 999) & (RACE_4 == 0 | RACE_4 == 1 | RACE_4 == 999) & ///
	(RACE_5 == 0 | RACE_5 == 1 | RACE_5 == 999)
replace race = 2 if hisp != 1 & (RACE_1 == 0 | RACE_1 == 2 | RACE_1 == 999) & (RACE_2 == 0 | RACE_2 == 2 | RACE_2 == 999) & ///
	(RACE_3 == 0 | RACE_3 == 2 | RACE_3 == 999) & (RACE_4 == 0 | RACE_4 == 2 | RACE_4 == 999) & ///
	(RACE_5 == 0 | RACE_5 == 2 | RACE_5 == 999)
replace race = 999 if hisp != 1 & (RACE_1 == 999 | RACE_1 == 0) & (RACE_2 == 999 | RACE_2 == 0) ///
	& (RACE_3 == 999 | RACE_3 == 0) & (RACE_4 == 999 | RACE_4 == 0) & (RACE_5 == 999 | RACE_5 == 0)
tab race
gen race_wt = race if race < 888
replace race_wt = . if race >= 888
tab race_wt

tab income
replace income = 999 if income == .
gen inc_wt = 1 if income <= 2
replace inc_wt = 2 if income == 3
replace inc_wt = 3 if income == 4
replace inc_wt = 4 if income == 5
replace inc_wt = 5 if income == 6
replace inc_wt = 6 if income == 7
replace inc_wt = 7 if income == 8
replace inc_wt = 8 if income >= 9 & income <= 10
replace inc_wt = . if income >= 888
tab inc_wt

tab gender
replace gender = 999 if gender == .
gen gend_wt = gender
replace gend_wt = . if gender >= 3
tab gend_wt

tab PARISH
gen parish_wt = PARISH
replace parish_wt = . if PARISH >= 777

*tab1 landorc landc2 landc3
*gen landc2_wt = landc2 if landc2 < 888
*tab landc2_wt
	*1 missing
	
*gen landc3_wt = landc3 if landc3 < 888
*tab landc3_wt
	*0 missing

**IMPUTE MISSING VALUES FOR WEIGHTING** 
hotdeck age_wt using imp1, keep(respnum_ age_wt) seed(4321) store
preserve
use imp11, clear
keep respnum_ age_wt
rename age_wt age_wt1
save, replace
restore
merge 1:1 respnum_ using imp11, nogen
tab age_wt
tab age_wt1

hotdeck gend_wt using imp1, keep(respnum_ gend_wt) seed(4321) store
preserve
use imp11, clear
keep respnum_ gend_wt
rename gend_wt gend_wt1
save, replace
restore
merge 1:1 respnum_ using imp11, nogen
tab gend_wt
tab gend_wt1

hotdeck race_wt using imp1, keep(respnum_ race_wt) seed(4321) store
preserve
use imp11, clear
keep respnum_ race_wt
rename race_wt race_wt1
save, replace
restore
merge 1:1 respnum_ using imp11, nogen
tab race_wt
tab race_wt1

hotdeck educ_wt using imp1, by(age_wt1 gend_wt race_wt1) keep(respnum_ educ_wt) seed(4321) store
preserve
use imp11, clear
keep respnum_ educ_wt
rename educ_wt educ_wt1
save, replace
restore
merge 1:1 respnum_ using imp11, nogen
tab educ_wt
tab educ_wt1
replace educ_wt1 = 3 if educ_wt1 == .

tab inc_wt
*hotdeck inc_wt using imp1, by(age_wt1 educ_wt1 gend_wt race_wt1) keep(respnum_ inc_wt) seed(4321) store
hotdeck inc_wt using imp1, by(age_wt1) keep(respnum_ inc_wt) seed(4321) store
preserve
use imp11, clear
keep respnum_ inc_wt
rename inc_wt inc_wt1
save, replace
restore
*preserve
*use imp21, clear
*keep respnum_ inc_wt
*rename inc_wt inc_wt2
*save, replace
*restore
*preserve
*use imp31, clear
*keep respnum_ inc_wt
*rename inc_wt inc_wt3
*save, replace
*restore
merge 1:1 respnum_ using imp11, nogen
*merge 1:1 respnum_ using imp21, nogen
*merge 1:1 respnum_ using imp31, nogen
tab inc_wt
tab inc_wt1
*tab inc_wt2
*tab inc_wt3
*replace inc_wt1 = inc_wt2 if inc_wt1 == .

*gen landc2_wt1 = landc2_wt
*replace landc2_wt1=1 if landorc == 1 & landc2_wt==.
*tab landc2_wt
*tab landc2_wt1

*gen landc3_wt1 = landc3_wt
*tab landc3_wt
*tab landc3_wt1

*gen phone_wt1 = 1 if landc2_wt1 == 2 
*replace phone_wt1 = 2 if landc3_wt1 == 2  
*replace phone_wt1 = 3 if landc2_wt1 == 1 | landc3_wt1 == 1  
*tab phone_wt1

gen parish_wt1 = parish_wt

tab1 age_wt1 race_wt1 educ_wt1 inc_wt1 gend_wt1

**BASEWEIGHT**
gen parpop=	328863	 

gen parcount =549

gen baseweight = parpop/parcount 

egen basewttot = total(baseweight)
sum baseweight
mean baseweight, over(parish_wt1)

gen gendpop=153250 if gend_wt1==1 
replace gendpop=175613 if gend_wt1==2

gen racepop=159499 if race_wt1==1
replace racepop=154894 if race_wt1==2
replace racepop=14470 if race_wt1==3

gen agepop=48282 if age_wt1==1
replace agepop=64989 if age_wt1==2
replace agepop=52534 if age_wt1==3
replace agepop=49335 if age_wt1==4
replace agepop=52821 if age_wt1==5
replace agepop=60902 if age_wt1==6

gen incpop=44068 if inc_wt1==1
replace incpop=33544 if inc_wt1==2
replace incpop=32557 if inc_wt1==3
replace incpop=40121 if inc_wt1==4
replace incpop=53934 if inc_wt1==5
replace incpop=38148 if inc_wt1==6
replace incpop=45712 if inc_wt1==7
replace incpop=40779 if inc_wt1==8

gen edpop= 121022 if educ_wt1==1
replace edpop= 93068 if educ_wt1==2
replace edpop= 114773 if educ_wt1==3

set seed 4321	

survwgt rake baseweight, by(gend_wt1 race_wt1 age_wt1 inc_wt1 educ_wt1) totvar(gendpop racepop agepop incpop edpop) gen(weight_post)

save "CityStatsWorking.dta", replace
use "CityStatsWorking.dta", clear

sum weight_post, detail

display r(sum)
	*328863
display 599.0219*3.5
	*2151.4402
gen trim1 = 0 if weight_post <= 2096.5766
replace trim1 = 1 if weight_post > 2096.5766
gen weight_post1 = weight_post
replace weight_post1 = 2096.5766 if trim1==1
sum weight_post1
display r(sum)
	*310112.43
display 328863 - 310112.43
tab trim1
	*531
replace weight_post1 = weight_post1 + ((328863 - 310112.43)/531) if trim1 == 0 
sum weight_post1, detail
display r(sum)
	*328863

gen weight_final = weight_post1

drop __RESPNUM __DISPOSITION prehello INTRO1 INTRO2 SCRN1AA safe thankcel AGE18 SCRN3 SCRN4 SCRN4A QSCRN3BB AGE18B lares PARISH_2 RACE_1 RACE_2 RACE_3 RACE_4 RACE_5 version date age_wt educ_wt race_wt inc_wt gend_wt parish_wt age_wt1 gend_wt1 race_wt1 educ_wt1 inc_wt1 parish_wt1 parpop parcount baseweight basewttot gendpop racepop agepop incpop edpop weight_post trim1 weight_post1
save "tempfile.dta", replace
***************************************************************
use "tempfile.dta", clear
svyset [pweight=weight_final]

tab1 Q1
gen Q1r = Q1
replace Q1r = 999 if Q1 == 888 | Q1 == 999 | Q1 == .
la var Q1r "Direction of EBR?"
la de Q1lab 1 "Right direction" 2 "Wrong direction" 999 "DK/Ref (Vol.)"
la val Q1r Q1lab
tab Q1r
svy: tab Q1r

tab Q2
gen Q2r = Q2 if Q2 < 888
replace Q2r = 999 if Q2 >= 888 | Q2 == .
la var Q2r "Do you feel that the pace of progress and change in BR is..."
la de Q2rlab 1 "Too slow" 2 "About the right pace" 3 "Too fast" 999 "DK/Ref (Vol)" 
la val Q2r Q2rlab
tab Q2r
svy: tab Q2r

tab Q3 
replace Q3 = 2 if Q3 == 4 & Mode == "Online"
replace Q3 = 3 if Q3 == 5 & Mode == "Online"
replace Q3 = 4 if Q3 == 6 & Mode == "Online"
gen Q3r = Q3 if Q3 < 888
replace Q3r = 999 if Q3 >= 888 | Q3 == .
la var Q3r "What level of influence do you feel ordinary citizens have?"
la de highnolab 1 "High influence" 2 "Moderate influence" 3 "Little influence" 4 "No influence" 999 "DK/Ref (Vol)" 
la val Q3r highnolab
tab Q3r
svy: tab Q3r

tab Q4
gen Q4r = Q4 if Q4 < 888
replace Q4r = 999 if Q4 == 888 | Q4 == 999 | Q4 == .
la var Q4r "Do any children under the age of 18 currently reside in your household?"
la de yesnolab 1 "Yes" 2 "No" 999 "DK/Ref (Vol)"
la val Q4r yesnolab
tab Q4r
svy: tab Q4r

tab Q5 
replace Q5 = 2 if Q5 == 4 & Mode == "Online"
gen Q5r = Q5 if Q5 < 888
replace Q5r = 999 if Q4r == 1 & (Q5 == 888 | Q5 == 999 | Q5 == .)
la var Q5r "Thinking about when the children in your household grow into adults, do you prefer that they continue to live in East Baton Rouge Parish when they are adults, that they move somewhere else to live as adults, or does it not matter much to you either way?"
la de Q5lab 1 "Live in East Baton Rouge Parish when they are adults" 2 "Move somewhere else to live as adults" 3 "Doesn't matter much either way" 999 "DK/Ref (Vol)"
la val Q5r Q5lab
tab Q5r
svy: tab Q5r

tab1 Q7
gen Q7r = Q7 if Q7 <= 2
replace Q7r = 999 if Q7 == 888 | Q7 == 999 | Q7 == .
la var Q7r "Which of these two statements comes closer to your own views?"
la de Q7rlab 1 "The economic system in this country unfairly favors the wealthy" 2 "The economic system in this country is generally fair to most Americans" 999 "DK/Ref (Vol.)" 
la val Q7r Q7rlab
tab Q7r
svy: tab Q7r

tab1 Q8
gen Q8r = Q8 if Q8 <= 5
replace Q8r = 999 if Q8 == 888 | Q8 == 999 | Q8 == .
la var Q8r "Overall how does being poor affect people’s ability to get ahead in our country these days?"
la de Q8lab 1 "Helps a lot" 2 "Helps a little" 3 "Hurts a little" 4 "Hurts a lot" 5 "Neither helps nor hurts" 999 "DK/Ref (Vol.)" 
la val Q8r Q8lab
tab Q8r
svy: tab Q8r

tab Q9
gen Q9r = Q9 if Q9 < 888
replace Q9r = 999 if Q9 >= 888
la var Q9r "Should the government do more or less to regulate emissions that some people believe are responsible for global warming?"
la de moreless 1 "Do more" 2 "Do less" 3 "About the same" 999 "DK/Ref (Vol)"
la val Q9r moreless 
tab Q9r
svy: tab Q9r

tab Q10
gen Q10r = Q10 if Q10 < 888
replace Q10r = 999 if Q10 >= 888
la var Q10r "How important is global warming as an issue to you? "
la de implab 1 "Extremely important" 2 "Very important" 3 "Somewhat important" 4 "Not too important" 5 "Not at all important" 999 "DK/Ref (Vol)"
la val Q10r implab 
tab Q10r
svy: tab Q10r

tab Q11
gen Q11r = Q11 if Q11 < 888
replace Q11r = 999 if Q11 >= 888 | Q11 == .
la var Q11r "In your opinion, would you say weather is becoming more extreme, less extreme, or is it staying about the same?"
la de moreless2 1 "More extreme" 2 "Less extreme" 3 "Staying about the same" 999 "DK/Ref (Vol)"
la val Q11r moreless2 
tab Q11r
svy: tab Q11r

tab Q12
gen Q12r = Q12 if Q12 < 888
replace Q12r = 999 if Q12 >= 888 | Q12 == .
la var Q12r "And would you say the weather is becoming more extreme mainly because of global warming or mainly because of natural variations in the weather, or is it both equally?"
la de gw2 1 "Mainly because of global warming" 2 "Mainly because of natural variations" 3 "Both equally " 999 "DK/Ref (Vol)"
la val Q12r gw2 
tab Q12r
svy: tab Q12r

tab1 Q13
gen Q13r = Q13 if Q13 < 888
replace Q13r = 999 if Q13 >= 888 | Q13 == .
la var Q13r "Do you support or oppose building a network of fast-charging stations for electric vehicles?"
la de suppop 1 "Support" 2 "Oppose" 999 "DK/Ref (Vol)"
la val Q13r suppop 
tab Q13r
svy: tab Q13r

tab1 Q14
gen Q14r = Q14 if Q14 < 888
replace Q14r = 999 if Q14 >= 888 | Q14 == .
la var Q14r "Do you support or oppose reducing greenhouse gases by improving options to bike, walk and take mass transit?"
la val Q14r suppop 
tab Q14r
svy: tab Q14r

tab1 Q15
gen Q15r = Q15 if Q15 < 888
replace Q15r = 999 if Q15 >= 888 | Q15 == .
la var Q15r "Do you support or oppose shifting tax incentives over time to encourage jobs in renewable energy industries?"
la val Q15r suppop 
tab Q15r
svy: tab Q15r

tab1 Q16
gen Q16r = Q16 if Q16 < 888
replace Q16r = 999 if Q16 >= 888 | Q16 == .
la var Q16r "Do you support or oppose changing zoning to encourage building more dense communities to reduce vehicle trips?"
la val Q16r suppop 
tab Q16r
svy: tab Q16r

tab1 Q17
gen Q17r = Q17 if Q17 < 888
replace Q17r = 999 if Q17 >= 888 | Q17 == .
la var Q17r "Do you support or oppose ending subsidized rates for flood insurance?"
la val Q17r suppop 
tab Q17r
svy: tab Q17r

tab Q18
gen Q18r = Q18 if Q18 < 888
replace Q18r = 999 if Q18 >= 888 | Q18 == .
la var Q18r "Do you own a car?"
la val Q18r yesnolab
tab Q18r
svy: tab Q18r

tab Q19
gen Q19r = Q19 if Q19 < 888
replace Q19r = 999 if (Q19 >= 888 | Q19 == .) & Q18==1
la var Q19r "Do you own an electric car?"
la val Q19r yesnolab
tab Q19r
svy: tab Q19r

tab Q20
gen Q20r = Q20 if Q20 < 888
replace Q20r = 999 if Q20 == 888 | Q20 == 999 | Q20 == .
la var Q20r "How likely are you to buy or lease an electric vehicle in the next ten years?"
la de Q20lab 1 "Very likely" 2 "Somewhat likely" 3 "Not very likely" 4 "Not at all likely" 999 "DK/Ref (Vol)"
la val Q20r Q20lab
tab Q20r
svy: tab Q20r

tab Q21
gen Q21r = Q21 if Q21 < 888
replace Q21r = 999 if (Q20 == 1 | Q20 == 2) & (Q21 == 888 | Q21 == 999 | Q21 == .)
la var Q21r "Effect on environment?"
la val Q21r implab
tab Q21r
svy: tab Q21r

tab Q22
gen Q22r = Q22 if Q22 < 888
replace Q22r = 999 if (Q20 == 1 | Q20 == 2) & (Q22 == 888 | Q22 == 999 | Q22 == .)
la var Q22r "Savings on gas and maintenance?"
la val Q22r implab
tab Q22r
svy: tab Q22r

tab Q23
gen Q23r = Q23 if Q23 < 888
replace Q23r = 999 if (Q20 == 1 | Q20 == 2) & (Q23 == 888 | Q23 == 999 | Q23 == .)
la var Q23r "Like the look of the car?"
la val Q23r implab
tab Q23r
svy: tab Q23r

tab Q24
gen Q24r = Q24 if Q24 < 888
replace Q24r = 999 if (Q20 == 1 | Q20 == 2) & (Q24 == 888 | Q24 == 999 | Q24 == .)
la var Q24r "Convenience of charging at home?"
la val Q24r implab
tab Q24r
svy: tab Q24r

tab Q25
gen Q25r = Q25 if Q25 < 888
replace Q25r = 999 if (Q20 == 3 | Q20 == 4) & (Q25 == 888 | Q25 == 999 | Q25 == .)
la var Q25r "Not enough fast-charging stations?"
la val Q25r implab
tab Q25r
svy: tab Q25r

tab Q26
gen Q26r = Q26 if Q26 < 888
replace Q26r = 999 if (Q20 == 3 | Q20 == 4) & (Q26 == 888 | Q26 == 999 | Q26 == .)
la var Q26r "Too expensive?"
la val Q26r implab
tab Q26r
svy: tab Q26r

tab Q27
gen Q27r = Q27 if Q27 < 888
replace Q27r = 999 if (Q20 == 3 | Q20 == 4) & (Q27 == 888 | Q27 == 999 | Q27 == .)
la var Q27r "Prefer gas-powered cars?"
la val Q27r implab
tab Q27r
svy: tab Q27r

tab Q28
gen Q28r = Q28 if Q28 < 888
replace Q28r = 999 if (Q20 == 3 | Q20 == 4) & (Q28 == 888 | Q28 == 999 | Q28 == .)
la var Q28r "Lack of service centers?"
la val Q28r implab
tab Q28r
svy: tab Q28r

tab Q29
gen Q29r = Q29 if Q29 < 888
replace Q29r = 999 if Q29 >= 888 | Q29 == .
la var Q29r "Please rate the level of litter in BR over past year?"
la de lowhighlab 1 "1 (Not at all a problem)" 2 "2" 3 "3" 4 "4" 5 "5 (Serious problem)" 999 "DK/Ref (Vol)" 
la val Q29r lowhighlab 
tab Q29r
svy: tab Q29r

tab1 Q30
gen Q30r = Q30 if Q30 < 888
replace Q30r = 999 if Q30 >= 888 | Q30 == .
la var Q30r "Would you support or oppose a $10 per month fee to keep trash out of bayous, lakes and streams in East Baton Rouge Parish?"
la val Q30r suppop 
tab Q30r
svy: tab Q30r

tab Q31
gen Q31r = Q31 if Q31 < 888
replace Q31r = 999 if Q31 >= 888
la var Q31r "Would you say that the immediate area where you live is getting better or getting worse as a place to live?"
la de betterworselab 1 "Better" 2 "Worse" 3 "Neither" 999 "DK/Ref (Vol)" 
la val Q31r betterworselab
tab Q31r
svy: tab Q31r

tab Q32
gen Q32r = Q32 if Q32 < 888
replace Q32r = 999 if Q32 == 888 | Q32 == 999 | Q32 == .
la var Q32r "Ideology?"
la de Q32lab 1 "Very conservative" 2 "Conservative" 3 "Moderate" 4 "Liberal" 5 "Very liberal" 999 "DK/Ref (Vol)"
la val Q32r Q32lab
tab Q32r
svy: tab Q32r

tab Q33
gen Q33r = Q33 if Q33 < 888
replace Q33r = 999 if Q33 == 888 | Q33 == 999 | Q33 == .
la var Q33r "Which comes closer to your view about the use of marijuana by adults?"
la de Q33lab 1 "Should be legal for medical and recreational use" 2 "Should be legal for medical use only" 3 "Should not be legal" 999 "DK/Ref (Vol)"
la val Q33r Q33lab
tab Q33r
svy: tab Q33r

tab1 Q34
gen Q34r = Q34 if Q34 < 888
replace Q34r = 999 if Q34 >= 888 | Q34 == .
la var Q34r "If the federal government provides major funding for passenger rail service between Baton Rouge and New Orleans, do you support or oppose the state government providing matching dollars?"
la val Q34r suppop 
tab Q34r
svy: tab Q34r

tab1 Q35
gen Q35r = Q35 if Q35 < 888
replace Q35r = 999 if Q35 >= 888 | Q35 == .
la var Q35r "Do you support or oppose an additional fee on your electric bill if the money is used to reduce power outages?"
la val Q35r suppop 
tab Q35r
svy: tab Q35r

tab1 Q36
gen Q36r = Q36 if Q36 < 888
replace Q36r = 999 if Q36 >= 888 | Q36 == .
la var Q36r "Do you support or oppose the creation of an independent commission in Louisiana to draw the lines of legislative and congressional districts?"
la val Q36r suppop 
tab Q36r
svy: tab Q36r

tab1 Q37
gen Q37r = Q37 if Q37 < 888
replace Q37r = 999 if Q37 >= 888 | Q37 == .
la var Q37r "How much do you think the community where they live affects the ability of a person who is poor to get ahead?"
la de howmuch 1 "A lot" 2 "Some" 3 "Not much" 4 "Not at all" 999 "DK/Ref (Vol)"
la val Q37r howmuch 
tab Q37r
svy: tab Q37r

tab1 Q38
gen Q38r = Q38 if Q38 < 888
replace Q38r = 999 if Q38 >= 888 | Q38 == .
la var Q38r "How much do you think the quality of their education affects the ability of a person who is poor to get ahead?"
la val Q38r howmuch 
tab Q38r
svy: tab Q38r

tab1 Q39
gen Q39r = Q39 if Q39 < 888
replace Q39r = 999 if Q39 >= 888 | Q39 == .
la var Q39r "Which comes closer to your view of the 2020 presidential election?"
la de Q39lab 1 "It was legitimate and accurate" 2 "It was the result of illegal voting or election rigging" 999 "DK/Ref (Vol)"
la val Q39r Q39lab 
tab Q39r
svy: tab Q39r

tab1 Q40
gen Q40r = Q40 if Q40 < 888
replace Q40r = 999 if Q40 >= 888 | Q40 == .
la var Q40r "Should the state of Louisiana allow any voter to vote by mail if they want to?"
la val Q40r yesnolab 
tab Q40r
svy: tab Q40r

tab1 Q41
gen Q41r = Q41 if Q41 < 888
replace Q41r = 999 if Q41 >= 888 | Q41 == .
la var Q41r "Do you support or oppose raising the property tax  to replace the East Baton Rouge Parish jail with a new prison that would hold fewer prisoners and provide more rehabilitative services for people convicted of crimes?"
la val Q41r suppop 
tab Q41r
svy: tab Q41r

tab1 Q42
gen Q42r = Q42 if Q42 < 888
replace Q42r = 999 if Q42 >= 888 | Q42 == .
la var Q42r "Do you support or oppose combining the Baton Rouge Police Department and the sheriff’s office into one organization that serves all parts of the parish?"
la val Q42r suppop 
tab Q42r
svy: tab Q42r

tab Q43
gen Q43r = Q43 if Q43 < 888
replace Q43r = 999 if Q43 >= 888 | Q43 == .
la var Q43r "Have you had money or property stolen, vandalized, or been victim of attack?"
la val Q43r yesnolab
tab Q43r
svy: tab Q43r

tab Q44
gen Q44r = Q44 if Q44 < 888
replace Q44r = 999 if Q44 >= 888 | Q44 == .
la var Q44r "Do you feel safe walking alone at night in your neighborhood?"
la val Q44r yesnolab
tab Q44r
svy: tab Q44r

tab Q45
gen Q45r = Q45 if Q45 < 888
replace Q45r = 999 if Q45 == 888 | Q45 == 999 | Q45 == .
la var Q45r "Which one of these phrases comes closest to describing your household's income these days?"
la de Q45lab 1 "I am living comfortably" 2 "I am getting by" 3 "I am finding it difficult to get by" 4 "I am having a very difficult time getting by" 999 "DK/Ref (Vol)"
la val Q45r Q45lab
tab Q45r
svy: tab Q45r

tab Q46
gen Q46r = Q46 if Q46 < 888
replace Q46r = 999 if Q46 >= 888 | Q46 == .
la var Q46r "Has there been a time in the last 12 months when you couldn’t afford to pay for food for yourself or your family?"
la val Q46r yesnolab
tab Q46r
svy: tab Q46r

tab Q47
gen Q47r = Q47 if Q47 < 888
replace Q47r = 999 if Q47 >= 888 | Q47 == .
la var Q47r "Has there been a time in the past 12 months when you couldn’t afford to pay for medicines or health care services for yourself or your family?"
la val Q47r yesnolab
tab Q47r
svy: tab Q47r

tab Q48
gen Q48r = Q48 if Q48 < 888
replace Q48r = 999 if Q48 >= 888 | Q48 == .
la var Q48r "How serious a problem, if at all, is finding quality, affordable childcare in your area?"
la de serlab 1 "Extremely serious" 2 "Very serious" 3 "Somewhat serious" 4 "Not too serious" 5 "Not at all serious" 999 "DK/Ref (Vol)"
la val Q48r serlab 
tab Q48r
svy: tab Q48r

tab1 Q49
gen Q49r = Q49 if Q49 < 888
replace Q49r = 999 if Q49 >= 888 | Q49 == .
la var Q49r "Do you support or oppose efforts in Congress to increase funding for child care assistance and to expand access to early childhood education?"
la val Q49r suppop 
tab Q49r
svy: tab Q49r

tab1 Q50
gen Q50r = Q50 if Q50 < 888
replace Q50r = 999 if Q50 >= 888 | Q50 == .
la var Q50r "Do do you support or oppose guaranteeing childcare assistance to low-income and middle-class families based on household income?"
la val Q50r suppop 
tab Q50r
svy: tab Q50r

tab1 Q51
gen Q51r = Q51 if Q51 < 888
replace Q51r = 999 if Q51 >= 888 | Q51 == .
la var Q51r "Do you support or oppose ensuring people who work in childcare earn a living wage?"
la val Q51r suppop 
tab Q51r
svy: tab Q51r

tab1 Q52
gen Q52r = Q52 if Q52 < 888
replace Q52r = 999 if Q52 >= 888 | Q52 == .
la var Q52r "Do you support or oppose starting public education in East Baton Rouge with optional pre-kindergarten that is offered to all three-and four-year-olds?"
la val Q52r suppop 
tab Q52r
svy: tab Q52r

tab1 Q53
gen Q53r = Q53 if Q53 < 888
replace Q53r = 999 if Q53 >= 888 | Q53 == .
la var Q53r "Do you support or oppose making universal, free childcare available from birth to age five? "
la val Q53r suppop 
tab Q53r
svy: tab Q53r

tab1 Q54
gen Q54r = Q54 if Q54 < 888
replace Q54r = 999 if Q54 >= 888 | Q54 == .
la var Q54r "Do you support or oppose raising the property tax to pay for childcare for children from birth to age five?"
la val Q54r suppop 
tab Q54r
svy: tab Q54r

tab Q55
gen Q55r = Q55 if Q55 < 888
replace Q55r = 999 if Q55 == 888 | Q55 == 999 | Q55 == .
la var Q55r "Would you vote for or against this ballot initiative?"
la de Q55lab 1 "For" 2 "Against" 999 "DK/Ref (Vol)"
la val Q55r Q55lab
tab Q55r
svy: tab Q55r

tab PID1
gen party1 = PID1
replace party1 = PID1 if PID1 <=3
replace party1 = 3 if PID1 == 4
replace party1 = 999 if PID1 == 888 | PID1 == 999 | PID1 == . 
la var party1 "Political Party"
la de pidlab 1 "Democrat" 2 "Republican" 3 "Neither" 999 "DK/Ref (Vol.)"
la val party1 pidlab
tab party1

gen party2 = party1 
replace party2 = 1 if PID2B == 1
replace party2 = 2 if PID2B == 2 
la var party2 "Political Party (with leaners)"
la val party2 pidlab
tab party2

gen agegroup=1 if agey> 17 & agey < 30
replace agegroup=2 if agey>29 & agey <50
replace agegroup=3 if agey>49 & agey <65
replace agegroup=4 if agey>64 & agey < 888
replace agegroup = 999 if agey == 999 | agey == .
la de agelab3 1 "18-29" 2 "30-49" 3 "50-64" 4 "65+" 999 "DK/Ref (Vol)"
la val agegroup agelab3
la var agegroup "Age"
tab agegroup
svy: tab agegroup

gen educr = 1 if educat >= 1 & educat <= 2
replace educr = 2 if educat == 3
replace educr = 3 if educat >= 4 & educat <= 5
replace educr = 4 if educat >= 6 & educat <= 7
replace educr = 999 if educat >= 8 | educat == .
la var educr "Education"
la de educrlab 1 "Less than high school" 2 "High school only" 3 "Some College or two year degree" 4 "Four year degree or more" 999 "DK/Ref (Vol)"
la val educr educrlab
tab educr 

tab race
gen racer = 1 if race == 1 
replace racer = 2 if race == 2 
replace racer = 3 if race == 3 
replace racer = 999 if race >= 888 | race == .
la var racer "Racial / ethnic identity"
la de racerlab 1 "White non-Hispanic" 2 "Black non-Hispanic" 3 "Something else" 999 "DK/Ref (Vol)"
la val racer racerlab
tab racer 

tab income
gen incomer = 1 if income >= 1 & income <= 3
replace incomer = 2 if income >=4 & income <= 5
replace incomer = 3 if income >=6 & income <= 7
replace incomer = 4 if income >=8 & income <= 10
replace incomer = 999 if income >= 11 | income == .
la var incomer "Household income"
la de incomerlab 1 "Under $25,000" 2 "$25,000-$49,999" 3 "$50,000-$99,999" 4 "$100,000 or more" 999 "DK/Ref (Vol)"
la val incomer incomerlab
tab incomer 

gen genderr = gender if gender <= 3
replace genderr = 999 if gender >= 4 | gender == .
la var genderr "Gender identity"
la de genderrlab 1 "Identifies as a man" 2 "Identifies as a woman" 3 "Identifies in some other way" 999 "DK/Ref (Vol)"
la val genderr genderrlab
tab genderr 

tab zipcode
gen region = 999
replace region = 1 if zipcode == 70801 | zipcode == 70802 | zipcode ==  70805 | zipcode ==  70806 | zipcode ==  70807 | zipcode ==  70808 | zipcode ==  70811 | zipcode == 70812 | zipcode == 70814 | zipcode == 70815 | zipcode == 70821 | zipcode == 70879 | zipcode == 70891 | zipcode == 70898
replace region = 2 if zipcode == 70776 | zipcode == 70809 | zipcode == 70810 | zipcode == 70816 | zipcode == 70817 | zipcode == 70820 | zipcode == 70826
replace region = 3 if zipcode == 70714 | zipcode == 70739 | zipcode == 70748 | zipcode == 70770 | zipcode == 70777 | zipcode == 70791 | zipcode == 70818 | zipcode ==  70819 | zipcode == 70722
tab region
la var region "Region"
la de regionlab 1 "City" 2 "South/Southeast of city" 3 "North/Northeast of city" 999 "DK/Ref/Invalid"
la val region regionlab 
svy: tab region 

tabout region using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\demos.csv", svy style(csv) cells(col) oneway per f(2) replace
tabout racer using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\demos.csv", svy style(csv) cells(col) oneway per f(2) append
tabout agegroup using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\demos.csv", svy style(csv) cells(col) oneway per f(2) append
tabout educr using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\demos.csv", svy style(csv) cells(col) oneway per f(2) append
tabout incomer using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\demos.csv", svy style(csv) cells(col) oneway per f(2) append
tabout genderr using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\demos.csv", svy style(csv) cells(col) oneway per f(2) append
tabout party1 using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\demos.csv", svy style(csv) cells(col) oneway per f(2) append
tabout party2 using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\demos.csv", svy style(csv) cells(col) oneway per f(2) append
tabout Q32r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\demos.csv", svy style(csv) cells(col) oneway per f(2) append

tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q1r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q1.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q2r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q2.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q3r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q3.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q4r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q4.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q5r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q5.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q7r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q7.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q8r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q8.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q9r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q9.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q10r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q10.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q11r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q11.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q12r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q12.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q13r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q13.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q14r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q14.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q15r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q15.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q16r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q16.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q17r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q17.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q18r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q18.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q19r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q19.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q20r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q20.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q21r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q21.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q22r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q22.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q23r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q23.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q24r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q24.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q25r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q25.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q26r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q26.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q27r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q27.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q28r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q28.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q29r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q29.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q30r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q30.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q31r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q31.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q32.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q33r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q33.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q34r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q34.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q35r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q35.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q36r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q36.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q37r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q37.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q38r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q38.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q39r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q39.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q40r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q40.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q41r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q41.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q42r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q42.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q43r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q43.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q44r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q44.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q45r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q45.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q46r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q46.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q47r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q47.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q48r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q48.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q49r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q49.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q50r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q50.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q51r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q51.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q52r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q52.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q53r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q53.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q54r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q54.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace
tabout region racer agegroup educr incomer genderr party1 party2 Q32r Q55r using "C:\Users\mbhende1\Dropbox\PPRL\BRAF\CS2021\xtabs\Q55.csv", svy style(csv) per c(row)  f(2 1) npos(col) replace

keep Mode respnum_ landorc Q6 Q1r Q2r Q3r Q4r Q5r Q7r Q8r Q9r Q10r Q11r Q12r Q13r ///
	Q14r Q15r Q16r Q17r Q18r Q19r Q20r Q21r Q22r Q23r Q24r Q25r Q26r ///
	Q27r Q28r Q29r Q30r Q31r Q32r Q33r Q34r Q35r Q36r Q37r Q38r Q39r ///
	Q40r Q41r Q42r Q43r Q44r Q45r Q46r Q47r Q48r Q49r Q50r Q51r Q52r ///
	Q53r Q54r Q55r party1 party2 agegroup educr racer incomer genderr region
	
order Q6, a(Q5r)

order respnum_ Mode landorc
la var respnum_ "Respondent number"
la var Mode "Online or phone"
la var landorc "Cell or landline"
la var Q6 "Why do you want your children to move away when they are adults?"

tab Q6
replace Q6 = "Don't know" if Q6 == "888"
replace Q6 = "[Refused to say]" if Q6 == "" & Q5r == 2
rename Q6 Q6r

save "City Stats 2021 Data File.dta", replace

use "City Stats 2021 Data File.dta", clear
