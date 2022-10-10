use "C:\Users\USER\Downloads\wage_old.dta", clear
**** mo ta thong ke cac bien****
su wage age educ exper
**** mo ta tuong quan bien***
corr wage age educ exper 
**** tao cac bien log***
gen lnwage = ln(wage)
gen lnage = ln(age)
gen lneduc = ln(educ)
gen lnexper = ln(exper)

**** uoc luong mo hinh****
reg wage age educ exper
est store mh1
**** kiem dinh bo sot bien****
estat ovtest
**** kiem dinh pssstd****
imtest, white
**** kiem dinh phan phoi chuan cua nhieu****
predict e, res
sktest e

**** kd da cong tuyen****
vif 

**** mo hinh bị phuong sai sai so thay doi va chua bang robust****
reg wage age educ exper, robust
est store mh2
**** tao table cho mo hinh****
est table mh1 mh2, se stat(N r2)
**** cai lenh outreg2****
ssc install outreg2
findit outreg2
outreg2 [mh1 mh2]using KTE318.3.xls, bdec(3) append


****probit logit*****
use "C:\Users\USER\Downloads\wage_old.dta", clear
su wage
gen wage_h = .
replace wage_h = 1 if wage > 3457.945
replace wage_h = 0 if wage < 3457.945
tab wage_h
reg wage_h age educ exper
logit wage_h age educ exper
linktest
quiet logit wage_h age educ exper
margins, at (age=32 educ=10 exper=5)
margins, at (age=32 educ=10 exper=10)

probit wage_h age educ exper
linktest
quiet logit wage_h age educ exper
margins, at (age=32 educ=10 exper=5)
margins, at (age=32 educ=10 exper=10)

****panel****
use
rename tstd L_daunam
rename ld11 L_cuoinam
rename ts11 K_daunam
rename ts12 K_cuoinam
rename ts192 tongvon
rename kqkd1 sales 
rename kqkd22 loinhuan_truocthue
rename kqkd25 loinhuan_sauthue
gen year = 2012
keep ma_thue tinh year namsxkd tennganh nganh_kd lhdn co_xk L_daunam L_cuoinam 
K_daunam K_cuoinam tongvon sales loinhuan_truocthue loinhuan_sauthue
save ".....", replace

*** copy lam tuong tu cho cac bo con lai
 
 
 append using "...." 
 ***khi save xong thi dang o bo du lieu 13, dung lenh append de ket noi voi bo 12
 
 duplicates report ma_thue year
 duplicates drop ma_thue year, force
 xtset ma_thue year
 histogram sales
 graph box
 ssc instal winsor2
 winsor2 sales, replace cuts(1 85)
 gen age = year - namsxkd
 gen loaihinhdoanhnghiep = .
 replace loaihinhdn = 1 if lhdn <6
 replace loaihinhdn = 2 if lhdn > 5 & lhdn < 12
 replace loaihinhdn = 3 if lhdn > 11 & lhdn <15
 tab loaihinhdn
 gen quymodn = .
 replace quymodn = 1 if L_cuoinam >10 & L_cuoinam <201
 replace quymodn = 2 if L_cuoinam >200 & L_cuoinam <301
 replace quymodn = 3 if L_cuoinam > 300
 tab quymodn
 gen L = (L_daunam + L_cuoinam)/2
 gen K = (K_daunam + K_cuoinam)/2
 
 append using "C:\Users\USER\Downloads\2012_1A_reduced.dta"
