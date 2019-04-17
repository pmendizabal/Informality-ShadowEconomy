**ArtÌculo: INFORMALIDAD, 2018, AUTOR: PORFIRIO MENDIZ¡ÅBAL

/*El objetivo es clasificar los ingresos de los hogares en dos fuentes: formales e informales,
para esto se debe buscar primero a los negocios e integrantes del hogar y clasificarlos, con esto
se puede afirmar si dichos ingresos provienen de la informalidad o no.

El concepto de informalidad es: el individuo labora en un lugar de hasta 5 trabajadores
y no cuenta con prestaciones, el negocio solo tiene hasta 5 trabajadores y no est· registrado
ante notario.

*/

**2008**

***************************
*                         * 
*   INDIVIDUOS            *
*                         *
***************************

/*Las variables necesarias son prestaciones y tamaÒo de la empresa. La primera 
se debe construir con ayuda sobre si la persona cuenta con alguna instituciÛn 
mÈdica, esta se encuentra en la base de Poblacion. Para la segunda, se encuentra 
en la base concentrado de trabajos.
Para esto hay que generar una variable llave para poder hacer la fusion.
*/

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base pobla\Pobla_08.dta", clear
gen folio2= folioviv+ foliohog+ numren
*Solo nos quedamos con la PEA*
drop if trabajo==2 | trabajo==.
*Ahora generamos la variable sobre prestaciones*
gen prestacion=1 
*En esta ediciÛn solo se genera una variable que toma en cuenta la informaciÛn de las instituciones
*mÈdicas proporcionadas por el Estado*
replace prestacion=0 if inst_1==1 | inst_2==2 | inst_3==3 | inst_4==4 //
keep folio2 folioviv foliohog numren prestacion
order folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_08.dta", replace
*Ahora utilizamos la base de trabajos para extraer la info sobre tamaÒo de la empresa*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base trabajos\Trab_08.dta", clear
gen folio2= folioviv+ foliohog+ numren
*Generamos la variable dicotomico sobre el tamaÒo de la empresa*
gen tam_empr=1 if tam_emp==01 | tam_emp==02 
**CondiciÛn donde el lugar donde labora la persona cuenta con 6 o m·s trabajadores*
replace tam_empr=0 if tam_emp==03 | tam_emp==04 | tam_emp==05 | tam_emp==06 ///
| tam_emp==07 | tam_emp==08 ///
| tam_emp==09 | tam_emp==10 | tam_emp==11 
*CondiciÛn donde la persona no sabe el numero de trabajadores*
replace tam_empr=2 if tam_emp==12
keep folio2 folioviv foliohog numren tam_empr
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_08.dta", clear
merge 1:m folioviv foliohog numren using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_08.dta", update
drop _merge
duplicates drop folio2, force

*Se utiliza para asegurar que no existan duplicados*
egen ind_id=group(folioviv foliohog numren)
duplicates report ind_id

save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace


use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base ingresos\ingresos_08.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
*Seleccionamos los ingresos provenientes del trabajo* 
gen ing_trab= ing_tri if clave=="P001" | clave=="P002" | clave=="P003" ///
| clave=="P004" | clave=="P005"  ///
| clave=="P006" | clave=="P007" | clave=="P008" | clave=="P009"  | clave=="P011"  /// 
| clave=="P013" | clave=="P015" | clave=="P017" | clave=="P018" | clave=="P019" ///
| clave=="P063"   
keep folio2 folioviv foliohog numren ing_trab
collapse (sum) ing_trab, by(folioviv foliohog numren)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base ingresos\ing_08.dta", replace
merge m:1 folioviv foliohog numren using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", update
drop _merge
duplicates drop folio2, force
drop ind_id
egen ind_id=group(folioviv foliohog numren)
duplicates report ind_id
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace

*Generamos la variabel de ingreso informal para trabajo*
gen ing_inf_trab= ing_trab if tam_empr==1 & prestacion==1
*Hibrido de tamaÒo pequeÒo y con prestacion*
gen ing_h_trab1= ing_trab if tam_empr==1 & prestacion==0
*Ingreso formal*
gen ing_for_trab= ing_trab if tam_empr==0 & prestacion==0
*Hibrido de tamaÒo grande y sin prestacion*
gen ing_h_trab2= ing_trab if tam_empr==0 & prestacion==1
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace


***************************
*                         * 
*   NEGOCIOS              *
*                         *
***************************

/*Las variables necesarias son registro ante notario y tamaÒo de la empresa. La primera se debe 
construir con ayuda sobre si el negocio cuenta con algun registro ante notario, esta se encuentra
en la base de Negocios. Para la segunda, se encuentra en la misma base.
Para esto hay que generar una variable llave para poder hacer la fusion.
*/
 
*Primero para negocios no agro*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_noagro08.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Generamos los ingresos provenientes de negocios informales*
gen ing_inf_neg_na= ing_tri if t_emp<=5 & reg_not==2
*Hibrido de tamaÒo menor y si tiene registro contable*
gen ing_h_neg_na1= ing_tri if t_emp<=5 & reg_not==1

*Ahora para los formales*
gen ing_for_neg_na= ing_tri if t_emp>5 & reg_not==1
*Hibrido de tamaÒo mayor y no tiene registro contable*
gen ing_h_neg_na2= ing_tri if t_emp>5 & reg_not==2

keep folioviv foliohog numren folio2 ing_for_neg_na ing_inf_neg_na ing_h_neg_na1 ing_h_neg_na2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro08.dta", replace
*Ahora para negocios agropecuarios*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_agro08.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Ingreso informal*
gen ing_inf_neg_a= ing_tri if t_emp<=5 & reg_not==2
*Hibrido de tamaÒo pequeÒo y si tiene registro*
gen ing_h_neg_a1= ing_tri if t_emp<=5 & reg_not==1

*Ingreso formal*
gen ing_for_neg_a= ing_tri if t_emp>5 & reg_not==1
*Hibrido de tamaÒo grande y no tiene registro*
gen ing_h_neg_a2= ing_tri if t_emp>5 & reg_not==2

keep folioviv foliohog numren folio2 ing_for_neg_a ing_inf_neg_a ing_h_neg_a1 ing_h_neg_a2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_agro08.dta", replace
*Fusionamos con negocios agro*
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", update
drop _merge
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace
*Fusionamos con negocios no agro*
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro08.dta", update
drop _merge
duplicates drop folio2, force
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace



*Ahora sumamos los ingresos generados por hogar*
*Suma de los negocios*
collapse (sum) ing_inf_neg_a, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_for_neg_a, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_inf_neg_na, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_for_neg_na, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna08.dta", replace
*Suma de ingresos por trabajo*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_inf_trab, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_for_trab, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab08.dta", replace
*Suma de los hibridos*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_h_neg_a1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega1_08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_h_neg_a2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega2_08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_h_neg_na1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna1_08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_h_neg_na2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna2_08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_h_trab1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab1_08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_h_trab2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab2_08.dta", replace


*Abrimos la base del concentrado para generar la llave* 
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base concen\concen_08.dta", clear
gen folio3=folioviv+foliohog
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base concen\concen_08", replace

*Fusionamos con la base de concentrado que contiene la info sobre hogares, 
*las bases sumadas por hogares previamente*
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega08.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega08.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna08.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna08.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab08.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab08.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab1_08.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab2_08.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega1_08.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega2_08.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna1_08.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna2_08.dta", update
drop _merge


*Generamos una variable que sea el total de todos los ingresos formales e informales*

gen ing_inf_neg= ing_inf_neg_a+ ing_inf_neg_na
gen ing_for_neg= ing_for_neg_a+ ing_for_neg_na
gen ing_hibrido_neg1= ing_h_neg_a1+ing_h_neg_na1
gen ing_hibrido_neg2= ing_h_neg_a2+ing_h_neg_na2
gen ing_hibrido_trab= ing_h_trab1+ing_h_trab2


*Generamos los ingresos totales para formal e informal*
gen ing_inf= ing_inf_neg+ ing_inf_trab
gen ing_for= ing_for_neg+ ing_for_trab
gen ing_hibridos= ing_hibrido_neg1+ing_hibrido_neg2+ing_hibrido_trab
gen clas_hog= 1 if (ing_for & ing_inf) & (ing_for!=. & ing_inf!=.) //Ingreso formal e informal
replace clas_hog= 2 if (ing_for & ing_hibridos) & (ing_for!=. & ing_hibridos!=.) //Ingresos formal e hibrido
replace clas_hog= 3 if (ing_inf & ing_hibridos) & (ing_inf!=. & ing_hibridos!=.) //Ingresos informal e hibrido
replace clas_hog= 4 if (ing_inf & ing_for & ing_hibridos) & (ing_inf!=. & ing_for!=. & ing_hibridos!=.) //Tres ingresos  
replace clas_hog= 5 if (ing_for & ing_for!=.) & (ing_inf==0 & ing_hibridos==0) //formal
replace clas_hog= 6 if (ing_inf & ing_inf!=.) & (ing_for==0 & ing_hibridos==0) //informal
replace clas_hog= 7 if (ing_hibridos & ing_hibridos!=.) & (ing_for==0 & ing_inf==0) //hibridos
replace clas_hog= 8 if (ingtrab==0 & negocio==0) //Ingreso de transferencia, renta y otros
gen folio2=folioviv+foliohog
order folio2
sort folio2

*Tabulacion de hogares*
tab clas_hog [fw=factor]

save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_08.dta", replace



**2010**

***************************
*                         * 
*   INDIVIDUOS            *
*                         *
***************************

/*Las variables necesarias son prestaciones y tamaÒo de la empresa. La primera se debe 
construir con ayuda sobre si la persona cuenta con alguna instituciÛn mÈdica, esta se encuentra
en la base de Poblacion. Para la segunda, se encuentra en la base concentrado de trabajos.
Para esto hay que generar una variable llave para poder hacer la fusion
*/

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base pobla\Pobla_10.dta", clear
gen folio2= folioviv+ foliohog+ numren
*Solo nos quedamos con la PEA*
drop if trabajo=="2" | trabajo=="."
*Ahora generamos la variable sobre prestaciones*
 gen prestacion=1 
/*En esta ediciÛn solo se genera una variable que toma en cuenta la informaciÛn 
de las instituciones mÈdicas proporcionadas por el Estado*/
replace prestacion=0 if inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4" 
keep folio2 folioviv foliohog numren prestacion
order folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_10.dta", replace
*Ahora utilizamos la base de trabajos para extraer la info sobre tamaÒo de la empresa*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base trabajos\Trab_10.dta", clear
gen folio2= folioviv+ foliohog+ numren
*Generamos la variable dicotomico sobre el tamaÒo de la empresa*
gen tam_empr=1 if tam_emp=="01" | tam_emp=="02" 
**CondiciÛn donde el lugar donde labora la persona cuenta con 6 o m·s trabajadores*
replace tam_empr=0 if tam_emp=="03" | tam_emp=="04" | tam_emp=="05" ///
| tam_emp=="06" | tam_emp=="07" | tam_emp=="08" ///
| tam_emp=="09" | tam_emp=="10" | tam_emp=="11" 
*Condicion donde la persona no sabe el numero de trabajadores*
replace tam_empr=2 if tam_emp=="12"
keep folio2 folioviv foliohog numren tam_empr
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_10.dta", clear
merge 1:m folioviv foliohog numren using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_10.dta", update
drop _merge
duplicates drop folio2, force

*Verificar duplicados*
egen ind_id=group(folioviv foliohog numren)
duplicates report ind_id

save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", replace


use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base ingresos\ingresos_10.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
*Seleccionamos los ingresos provenientes del trabajo*
gen ing_trab= ing_tri if clave=="P001" | clave=="P002" | clave=="P003" ///
| clave=="P004" | clave=="P005" | clave=="P006" | clave=="P007" | clave=="P008" ///
| clave=="P009" | clave=="P011" | clave=="P013" | clave=="P015" | clave=="P017" ///
| clave=="P018" | clave=="P019" | clave=="P063"   
keep folio2 folioviv foliohog numren ing_trab
collapse (sum) ing_trab, by(folioviv foliohog numren)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base ingresos\ing_10.dta", replace
merge m:1 folioviv foliohog numren using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", update
drop _merge
duplicates drop folio2, force
drop ind_id
egen ind_id=group(folioviv foliohog numren)
duplicates report ind_id
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", replace

*Generamos la variabel de ingreso informal para trabajo*
gen ing_inf_trab= ing_trab if tam_empr==1 & prestacion==1
*Hibrido de tamaÒo pequeÒo y con prestacion*
gen ing_h_trab1= ing_trab if tam_empr==1 & prestacion==0
*Ingreso formal*
gen ing_for_trab= ing_trab if tam_empr==0 & prestacion==0
*Hibrido de tamaÒo grande y sin prestacion*
gen ing_h_trab2= ing_trab if tam_empr==0 & prestacion==1
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", replace


***************************
*                         * 
*   NEGOCIOS              *
*                         *
***************************

/*Las variables necesarias son registro ante notario y tamaÒo de la empresa. La primera se debe 
construir con ayuda sobre si el negocio cuenta con algun registro ante notario, esta se encuentra
en la base de Negocios. Para la segunda, se encuentra en la misma base.
Para esto hay que generar una variable llave para poder hacer la fusion.
*/
 
*Primero para negocios no agro*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_noagro10.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Generamos los ingresos provenientes de negocios informales*
gen ing_inf_neg_na= ing_tri if t_emp<=5 & reg_not=="2"
*Hibrido de tamaÒo menor y si tiene registro contable*
gen ing_h_neg_na1= ing_tri if t_emp<=5 & reg_not=="1"

*Ahora para los formales*
gen ing_for_neg_na= ing_tri if t_emp>5 & reg_not=="1"
*Hibrido de tamaÒo mayor y no tiene registro contable*
gen ing_h_neg_na2= ing_tri if t_emp>5 & reg_not=="2"

keep folioviv foliohog numren folio2 ing_for_neg_na ing_inf_neg_na ing_h_neg_na1 ing_h_neg_na2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro10.dta", replace
*Ahora para negocios agropecuarios*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_agro10.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Ingreso informal*
gen ing_inf_neg_a= ing_tri if t_emp<=5 & reg_not==2
*Hibrido de tamaÒo pequeÒo y si tiene registro*
gen ing_h_neg_a1= ing_tri if t_emp<=5 & reg_not==1
*Ingreso formal*
gen ing_for_neg_a= ing_tri if t_emp>5 & reg_not==1
*Hibrido de tamaÒo grande y no tiene registro*
gen ing_h_neg_a2= ing_tri if t_emp>5 & reg_not==2

keep folioviv foliohog numren folio2 ing_for_neg_a ing_inf_neg_a ing_h_neg_a1 ing_h_neg_a2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_agro10.dta", replace
*Fusionamos con negocios agro*
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", update
drop _merge
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", replace
*Fusionamos con negocios no agro*
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro10.dta", update
drop _merge
duplicates drop folio2, force
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", replace


**Ahora sumamos los ingresos generados por hogar*
*Suma de los negocios*
collapse (sum) ing_inf_neg_a, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_for_neg_a, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_inf_neg_na, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_for_neg_na, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna10.dta", replace
*Suma de ingresos por trabajo*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_inf_trab, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_for_trab, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab10.dta", replace
*Suma de los hibridos*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_h_neg_a1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega1_10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_h_neg_a2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega2_10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_h_neg_na1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna1_10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_h_neg_na2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna2_10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_h_trab1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab1_10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_h_trab2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab2_10.dta", replace


*Abrimos la base del concentrado para generar la llave* 
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base concen\concen_10.dta", clear
gen folio3=folioviv+foliohog
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base concen\concen_10", replace

*Fusionamos con la base de concentrado que contiene la info sobre hogares, las bases sumadas por hogares previamente*
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega10.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega10.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna10.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna10.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab10.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab10.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab1_10.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab2_10.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega1_10.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega2_10.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna1_10.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna2_10.dta", update
drop _merge


*Generamos una variable que sea el total de todos los ingresos formales e informales*

gen ing_inf_neg= ing_inf_neg_a+ ing_inf_neg_na
gen ing_for_neg= ing_for_neg_a+ ing_for_neg_na
gen ing_hibrido_neg1= ing_h_neg_a1+ing_h_neg_na1
gen ing_hibrido_neg2= ing_h_neg_a2+ing_h_neg_na2
gen ing_hibrido_trab= ing_h_trab1+ing_h_trab2



*Generamos los ingresos totales para formal e informal*
gen ing_inf= ing_inf_neg+ ing_inf_trab
gen ing_for= ing_for_neg+ ing_for_trab
gen ing_hibridos= ing_hibrido_neg1+ing_hibrido_neg2+ing_hibrido_trab
gen clas_hog= 1 if (ing_for & ing_inf) & (ing_for!=. & ing_inf!=.)
replace clas_hog= 2 if (ing_for & ing_hibridos) & (ing_for!=. & ing_hibridos!=.)
replace clas_hog= 3 if (ing_inf & ing_hibridos) & (ing_inf!=. & ing_hibridos!=.)
replace clas_hog= 4 if (ing_inf & ing_for & ing_hibridos) & (ing_inf!=. & ing_for!=. & ing_hibridos!=.)  
replace clas_hog= 5 if (ing_for & ing_for!=.) & (ing_inf==0 & ing_hibridos==0) //formal
replace clas_hog= 6 if (ing_inf & ing_inf!=.) & (ing_for==0 & ing_hibridos==0) //informal
replace clas_hog= 7 if (ing_hibridos & ing_hibridos!=.) & (ing_for==0 & ing_inf==0) //hibridos
replace clas_hog= 8 if (ingtrab==0 & negocio==0)
gen folio2=folioviv+foliohog
order folio2
sort folio2

*Tabulacion de hogares*
tab clas_hog [fw=factor]

save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_10.dta", replace




**2012**

***************************
*                         * 
*   INDIVIDUOS            *
*                         *
***************************

/*Las variables necesarias son prestaciones y tamaÒo de la empresa. La primera se debe 
construir con ayuda sobre si la persona cuenta con alguna instituciÛn mÈdica, esta se encuentra
en la base de Poblacion. Para la segunda, se encuentra en la base concentrado de trabajos.
Para esto hay que generar una variable llave para poder hacer la fusion
*/

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base pobla\Pobla_12.dta", clear
gen folio2= folioviv+ foliohog+ numren
*Solo nos quedamos con la PEA*
drop if trabajo=="2" | trabajo=="."
*Ahora generamos la variable sobre prestaciones
 gen prestacion=1 
/*En esta ediciÛn solo se genera una variable que toma en cuenta la informaciÛn de las instituciones
mÈdicas proporcionadas por el Estado*/
replace prestacion=0 if inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4" 
keep folio2 folioviv foliohog numren prestacion
order folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_12.dta", replace
*Ahora utilizamos la base de trabajos para extraer la info sobre tamaÒo de la empresa*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base trabajos\Trab_12.dta", clear
gen folio2= folioviv+ foliohog+ numren
*Generamos la variable dicotomico sobre el tamaÒo de la empresa*
gen tam_empr=1 if tam_emp=="01" | tam_emp=="02" 
**CondiciÛn donde el lugar donde labora la persona cuenta con 6 o m·s trabajadores*
replace tam_empr=0 if tam_emp=="03" | tam_emp=="04" | tam_emp=="05" | tam_emp=="06" ///
| tam_emp=="07" | tam_emp=="08" ///
| tam_emp=="09" | tam_emp=="10" | tam_emp=="11" 
*Condicion donde la persona no sabe el numero de trabajadores*
replace tam_empr=2 if tam_emp=="12"
keep folio2 folioviv foliohog numren tam_empr
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_12.dta", clear
merge 1:m folioviv foliohog numren using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_12.dta", update
drop _merge
duplicates drop folio2, force

egen ind_id=group(folioviv foliohog numren)
duplicates report ind_id

save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", replace


use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base ingresos\ingresos_12.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
*Seleccionamos los ingresos provenientes del trabajo*
gen ing_trab= ing_tri if clave=="P001" | clave=="P002" | clave=="P003" ///
| clave=="P004" | clave=="P005" | clave=="P006" | clave=="P007" | clave=="P008" ///
| clave=="P009" | clave=="P011" | clave=="P013" | clave=="P015" | clave=="P017" ///
| clave=="P018" | clave=="P019" | clave=="P063"   
keep folio2 folioviv foliohog numren ing_trab
collapse (sum) ing_trab, by(folioviv foliohog numren)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base ingresos\ing_12.dta", replace
merge m:1 folioviv foliohog numren using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", update
drop _merge
duplicates drop folio2, force
drop ind_id
egen ind_id=group(folioviv foliohog numren)
duplicates report ind_id
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", replace

*Generamos la variabel de ingreso informal para trabajo*
gen ing_inf_trab= ing_trab if tam_empr==1 & prestacion==1
*Hibrido de tamaÒo pequeÒo y con prestacion*
gen ing_h_trab1= ing_trab if tam_empr==1 & prestacion==0
*Ingreso formal*
gen ing_for_trab= ing_trab if tam_empr==0 & prestacion==0
*Hibrido de tamaÒo grande y sin prestacion*
gen ing_h_trab2= ing_trab if tam_empr==0 & prestacion==1
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", replace


***************************
*                         * 
*   NEGOCIOS              *
*                         *
***************************

/*Las variables necesarias son registro ante notario y tamaÒo de la empresa. La primera se debe 
construir con ayuda sobre si el negocio cuenta con algun registro ante notario, esta se encuentra
en la base de Negocios. Para la segunda, se encuentra en la misma base.
Para esto hay que generar una variable llave para poder hacer la fusion.
*/
 
*Primero para negocios no agro*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_noagro12.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Generamos los ingresos provenientes de negocios informales*
gen ing_inf_neg_na= ing_tri if t_emp<=5 & reg_not=="2"
*Hibrido de tamaÒo menor y si tiene registro contable*
gen ing_h_neg_na1= ing_tri if t_emp<=5 & reg_not=="1"

*Ahora para los formales*
gen ing_for_neg_na= ing_tri if t_emp>5 & reg_not=="1"
*Hibrido de tamaÒo mayor y no tiene registro contable*
gen ing_h_neg_na2= ing_tri if t_emp>5 & reg_not=="2"

keep folioviv foliohog numren folio2 ing_for_neg_na ing_inf_neg_na ///
ing_h_neg_na1 ing_h_neg_na2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro12.dta", replace
*Ahora para negocios agropecuarios*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_agro12.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Ingreso informal*
gen ing_inf_neg_a= ing_tri if t_emp<=5 & reg_not=="2"
*Hibrido de tamaÒo pequeÒo y si tiene registro*
gen ing_h_neg_a1= ing_tri if t_emp<=5 & reg_not=="1"

*Ingreso formal*
gen ing_for_neg_a= ing_tri if t_emp>5 & reg_not=="1"
*Hibrido de tamaÒo grande y no tiene registro*
gen ing_h_neg_a2= ing_tri if t_emp>5 & reg_not=="2"

keep folioviv foliohog numren folio2 ing_for_neg_a ing_inf_neg_a ing_h_neg_a1 ///
ing_h_neg_a2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_agro12.dta", replace
*Fusionamos con negocios agro*
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", update
drop _merge
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", replace
*Fusionamos con negocios no agro*
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro12.dta", update
drop _merge
duplicates drop folio2, force
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", replace



**Ahora sumamos los ingresos generados por hogar*
*Suma de los negocios*
collapse (sum) ing_inf_neg_a, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_for_neg_a, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_inf_neg_na, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_for_neg_na, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna12.dta", replace
*Suma de ingresos por trabajo*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_inf_trab, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_for_trab, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab12.dta", replace
*Suma de los hibridos*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_h_neg_a1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega1_12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_h_neg_a2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega2_12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_h_neg_na1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna1_12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_h_neg_na2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna2_12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_h_trab1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab1_12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_h_trab2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab2_12.dta", replace


*Abrimos la base del concentrado para generar la llave* 
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base concen\concen_12.dta", clear
gen folio3=folioviv+foliohog
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base concen\concen_12", replace

*Fusionamos con la base de concentrado que contiene la info sobre hogares, las bases sumadas por hogares previamente*
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega12.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega12.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna12.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna12.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab12.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab12.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab1_12.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab2_12.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega1_12.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega2_12.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna1_12.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna2_12.dta", update
drop _merge


*Generamos una variable que sea el total de todos los ingresos formales e informales*

gen ing_inf_neg= ing_inf_neg_a+ ing_inf_neg_na
gen ing_for_neg= ing_for_neg_a+ ing_for_neg_na
gen ing_hibrido_neg1= ing_h_neg_a1+ing_h_neg_na1
gen ing_hibrido_neg2= ing_h_neg_a2+ing_h_neg_na2
gen ing_hibrido_trab= ing_h_trab1+ing_h_trab2


*Generamos los ingresos totales para formal e informal*
gen ing_inf= ing_inf_neg+ ing_inf_trab
gen ing_for= ing_for_neg+ ing_for_trab
gen ing_hibridos= ing_hibrido_neg1+ing_hibrido_neg2+ing_hibrido_trab
gen clas_hog= 1 if (ing_for & ing_inf) & (ing_for!=. & ing_inf!=.)
replace clas_hog= 2 if (ing_for & ing_hibridos) & (ing_for!=. & ing_hibridos!=.)
replace clas_hog= 3 if (ing_inf & ing_hibridos) & (ing_inf!=. & ing_hibridos!=.)
replace clas_hog= 4 if (ing_inf & ing_for & ing_hibridos) & (ing_inf!=. & ing_for!=. & ing_hibridos!=.)  
replace clas_hog= 5 if (ing_for & ing_for!=.) & (ing_inf==0 & ing_hibridos==0) //formal
replace clas_hog= 6 if (ing_inf & ing_inf!=.) & (ing_for==0 & ing_hibridos==0) //informal
replace clas_hog= 7 if (ing_hibridos & ing_hibridos!=.) & (ing_for==0 & ing_inf==0) //hibridos
replace clas_hog= 8 if (ingtrab==0 & negocio==0)
gen folio2=folioviv+foliohog
order folio2
sort folio2

*Tabulacion de hogares*
tab clas_hog [fw=factor]

save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_12.dta", replace



**2014**

***************************
*                         * 
*   INDIVIDUOS            *
*                         *
***************************

/*Las variables necesarias son prestaciones y tamaÒo de la empresa. La primera se debe 
construir con ayuda sobre si la persona cuenta con alguna instituciÛn mÈdica, esta se encuentra
en la base de Poblacion. Para la segunda, se encuentra en la base concentrado de trabajos.
Para esto hay que generar una variable llave para poder hacer la fusion
*/

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base pobla\Pobla_14.dta", clear
gen folio2= folioviv+ foliohog+ numren
*Solo nos quedamos con la PEA*
drop if trabajo=="2" | trabajo=="."
*Ahora generamos la variable sobre prestaciones*
 gen prestacion=1 
/*En esta ediciÛn solo se genera una variable que toma en cuenta la informaciÛn de las instituciones
mÈdicas proporcionadas por el Estado*/
replace prestacion=0 if inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4" 
keep folio2 folioviv foliohog numren prestacion
order folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_14.dta", replace
*Ahora utilizamos la base de trabajos para extraer la info sobre tama√±o de la empresa*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base trabajos\Trab_14.dta", clear
gen folio2= folioviv+ foliohog+ numren
*Generamos la variable dicotomico sobre el tamaÒo de la empresa*
gen tam_empr=1 if tam_emp=="01" | tam_emp=="02" 
**Condici√≥n donde el lugar donde labora la persona cuenta con 6 o m·s trabajadores*
replace tam_empr=0 if tam_emp=="03" | tam_emp=="04" | tam_emp=="05" ///
| tam_emp=="06" | tam_emp=="07" | tam_emp=="08" ///
| tam_emp=="09" | tam_emp=="10" | tam_emp=="11" 
*Condicion donde la persona no sabe el numero de trabajadores*
replace tam_empr=2 if tam_emp=="12"
keep folio2 folioviv foliohog numren tam_empr
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_14.dta", clear
merge 1:m folioviv foliohog numren using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_14.dta", update
drop _merge
duplicates drop folio2, force

egen ind_id=group(folioviv foliohog numren)
duplicates report ind_id

save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", replace


use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base ingresos\ingresos_14.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
*Seleccionamos los ingresos provenientes del trabajo*
gen ing_trab= ing_tri if clave=="P001" | clave=="P002" | clave=="P003" ///
| clave=="P004" | clave=="P005" | clave=="P006" | clave=="P007" | clave=="P008" /// 
| clave=="P009" | clave=="P011" | clave=="P013" | clave=="P015" | clave=="P017" ///
| clave=="P018" | clave=="P019" | clave=="P063"   
keep folio2 folioviv foliohog numren ing_trab
collapse (sum) ing_trab, by(folioviv foliohog numren)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base ingresos\ing_14.dta", replace
merge m:1 folioviv foliohog numren using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", update
drop _merge
duplicates drop folio2, force
drop ind_id
egen ind_id=group(folioviv foliohog numren)
duplicates report ind_id
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", replace

*Generamos la variabel de ingreso informal para trabajo*
gen ing_inf_trab= ing_trab if tam_empr==1 & prestacion==1
*Hibrido de tamaÒo pequeÒo y con prestacion*
gen ing_h_trab1= ing_trab if tam_empr==1 & prestacion==0
*Ingreso formal*
gen ing_for_trab= ing_trab if tam_empr==0 & prestacion==0
*Hibrido de tamaÒo grande y sin prestacion*
gen ing_h_trab2= ing_trab if tam_empr==0 & prestacion==1
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", replace


***************************
*                         * 
*   NEGOCIOS              *
*                         *
***************************

/*Las variables necesarias son registro ante notario y tamaÒo de la empresa. La primera se debe 
construir con ayuda sobre si el negocio cuenta con algun registro ante notario, esta se encuentra
en la base de Negocios. Para la segunda, se encuentra en la misma base.
Para esto hay que generar una variable llave para poder hacer la fusion.
*/
 
*Primero para negocios no agro*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_noagro14.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Generamos los ingresos provenientes de negocios informales*
gen ing_inf_neg_na= ing_tri if t_emp<=5 & reg_not=="2"
*Hibrido de tamaÒo menor y si tiene registro contable*
gen ing_h_neg_na1= ing_tri if t_emp<=5 & reg_not=="1"

*Ahora para los formales*
gen ing_for_neg_na= ing_tri if t_emp>5 & reg_not=="1"
*Hibrido de tamaÒo mayor y no tiene registro contable*
gen ing_h_neg_na2= ing_tri if t_emp>5 & reg_not=="2"

keep folioviv foliohog numren folio2 ing_for_neg_na ing_inf_neg_na ing_h_neg_na1 ing_h_neg_na2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro14.dta", replace
*Ahora para negocios agropecuarios*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_agro14.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Ingreso informal*
gen ing_inf_neg_a= ing_tri if t_emp<=5 & reg_not=="2"
*Hibrido de tamaÒo pequeÒo y si tiene registro*
gen ing_h_neg_a1= ing_tri if t_emp<=5 & reg_not=="1"

*Ingreso formal*
gen ing_for_neg_a= ing_tri if t_emp>5 & reg_not=="1"
*Hibrido de tamaÒo grande y no tiene registro*
gen ing_h_neg_a2= ing_tri if t_emp>5 & reg_not=="2"

keep folioviv foliohog numren folio2 ing_for_neg_a ing_inf_neg_a ing_h_neg_a1 ing_h_neg_a2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_agro14.dta", replace
*Fusionamos con negocios agro*
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", update
drop _merge
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", replace
*Fusionamos con negocios no agro*
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro14.dta", update
drop _merge
duplicates drop folio2, force
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", replace



**Ahora sumamos los ingresos generados por hogar*
*Suma de los negocios*
collapse (sum) ing_inf_neg_a, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_for_neg_a, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_inf_neg_na, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_for_neg_na, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna14.dta", replace
*Suma de ingresos por trabajo*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_inf_trab, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_for_trab, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab14.dta", replace
*Suma de los hibridos*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_h_neg_a1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega1_14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_h_neg_a2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega2_14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_h_neg_na1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna1_14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_h_neg_na2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna2_14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_h_trab1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab1_14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_h_trab2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab2_14.dta", replace


*Abrimos la base del concentrado para generar la llave* 
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base concen\concen_14.dta", clear
gen folio3=folioviv+foliohog
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base concen\concen_14", replace

*Fusionamos con la base de concentrado que contiene la info sobre hogares, las bases sumadas por hogares previamente*
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega14.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega14.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna14.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna14.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab14.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab14.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab1_14.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab2_14.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega1_14.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega2_14.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna1_14.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna2_14.dta", update
drop _merge


*Generamos una variable que sea el total de todos los ingresos formales e informales*

gen ing_inf_neg= ing_inf_neg_a+ ing_inf_neg_na
gen ing_for_neg= ing_for_neg_a+ ing_for_neg_na
gen ing_hibrido_neg1= ing_h_neg_a1+ing_h_neg_na1
gen ing_hibrido_neg2= ing_h_neg_a2+ing_h_neg_na2
gen ing_hibrido_trab= ing_h_trab1+ing_h_trab2


*Generamos los ingresos totales para formal e informal*
gen ing_inf= ing_inf_neg+ ing_inf_trab
gen ing_for= ing_for_neg+ ing_for_trab
gen ing_hibridos= ing_hibrido_neg1+ing_hibrido_neg2+ing_hibrido_trab
gen clas_hog= 1 if (ing_for & ing_inf) & (ing_for!=. & ing_inf!=.)
replace clas_hog= 2 if (ing_for & ing_hibridos) & (ing_for!=. & ing_hibridos!=.)
replace clas_hog= 3 if (ing_inf & ing_hibridos) & (ing_inf!=. & ing_hibridos!=.)
replace clas_hog= 4 if (ing_inf & ing_for & ing_hibridos) & (ing_inf!=. & ing_for!=. & ing_hibridos!=.)  
replace clas_hog= 5 if (ing_for & ing_for!=.) & (ing_inf==0 & ing_hibridos==0) //formal
replace clas_hog= 6 if (ing_inf & ing_inf!=.) & (ing_for==0 & ing_hibridos==0) //informal
replace clas_hog= 7 if (ing_hibridos & ing_hibridos!=.) & (ing_for==0 & ing_inf==0) //hibridos
replace clas_hog= 8 if (ingtrab==0 & negocio==0)
gen folio2=folioviv+foliohog
order folio2
sort folio2

*Tabulacion de hogares*
tab clas_hog [fw=factor]

save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_14.dta", replace



**2016**


***************************
*                         * 
*   INDIVIDUOS            *
*                         *
***************************

/*Las variables necesarias son prestaciones y tamaÒo de la empresa. La primera se debe 
construir con ayuda sobre si la persona cuenta con alguna instituciÛn mÈdica, esta se encuentra
en la base de Poblacion. Para la segunda, se encuentra en la base concentrado de trabajos.
Para esto hay que generar una variable llave para poder hacer la fusion
*/

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base pobla\Pobla_16.dta", clear
gen folio2= folioviv+ foliohog+ numren
*Solo nos quedamos con la PEA*
drop if trabajo=="2" | trabajo=="."
*Ahora generamos la variable sobre prestaciones*
 gen prestacion=1 
/*En esta ediciÛn solo se genera una variable que toma en cuenta la informaciÛn de las instituciones
mÈdicas proporcionadas por el Estado*/
replace prestacion=0 if inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4" 
keep folio2 folioviv foliohog numren prestacion
order folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_16.dta", replace
*Ahora utilizamos la base de trabajos para extraer la info sobre tamaÒo de la empresa*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base trabajos\Trab_16.dta", clear
gen folio2= folioviv+ foliohog+ numren
*Generamos la variable dicotomico sobre el tamaÒo de la empresa*
gen tam_empr=1 if tam_emp=="01" | tam_emp=="02" 
**Condici√≥n donde el lugar donde labora la persona cuenta con 6 o m·s trabajadores*
replace tam_empr=0 if tam_emp=="03" | tam_emp=="04" | tam_emp=="05" ///
| tam_emp=="06" | tam_emp=="07" | tam_emp=="08" ///
| tam_emp=="09" | tam_emp=="10" | tam_emp=="11" 
*Condicion donde la persona no sabe el numero de trabajadores*
replace tam_empr=2 if tam_emp=="12"
keep folio2 folioviv foliohog numren tam_empr
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_16.dta", clear
merge 1:m folioviv foliohog numren using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_16.dta", update
drop _merge
duplicates drop folio2, force

egen ind_id=group(folioviv foliohog numren)
duplicates report ind_id

save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", replace


use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base ingresos\ingresos_16.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
*Seleccionamos los ingresos provenientes del trabajo principal y secundario*
gen ing_trab= ing_tri if clave=="P001" | clave=="P002" | clave=="P003" ///
| clave=="P004" | clave=="P005" | clave=="P006" | clave=="P007" | clave=="P008" ///
| clave=="P009" | clave=="P011"| clave=="P013" | clave=="P015" | clave=="P017" ///
| clave=="P018" | clave=="P019" | clave=="P063"   
keep folio2 folioviv foliohog numren ing_trab
collapse (sum) ing_trab, by(folioviv foliohog numren)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base ingresos\ing_16.dta", replace
merge m:1 folioviv foliohog numren using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", update
drop _merge
duplicates drop folio2, force
drop ind_id
egen ind_id=group(folioviv foliohog numren)
duplicates report ind_id
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", replace

*Generamos la variabel de ingreso informal para trabajo*
gen ing_inf_trab= ing_trab if tam_empr==1 & prestacion==1
*Hibrido de tamaÒo pequeÒo y con prestacion*
gen ing_h_trab1= ing_trab if tam_empr==1 & prestacion==0
*Ingreso formal*
gen ing_for_trab= ing_trab if tam_empr==0 & prestacion==0
*Hibrido de tamaÒo grande y sin prestacion*
gen ing_h_trab2= ing_trab if tam_empr==0 & prestacion==1
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", replace


***************************
*                         * 
*   NEGOCIOS              *
*                         *
***************************

/*Las variables necesarias son registro ante notario y tamaÒo de la empresa. La primera se debe 
construir con ayuda sobre si el negocio cuenta con algun registro ante notario, esta se encuentra
en la base de Negocios. Para la segunda, se encuentra en la misma base.
Para esto hay que generar una variable llave para poder hacer la fusion.
*/
 
*Primero para negocios no agro*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_noagro16.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Generamos los ingresos provenientes de negocios informales*
gen ing_inf_neg_na= ing_tri if t_emp<=5 & reg_not=="2"
*Hibrido de tamaÒo menor y si tiene registro contable*
gen ing_h_neg_na1= ing_tri if t_emp<=5 & reg_not=="1"

*Ahora para los formales*
gen ing_for_neg_na= ing_tri if t_emp>5 & reg_not=="1"
*Hibrido de tamaÒo mayor y no tiene registro contable*
gen ing_h_neg_na2= ing_tri if t_emp>5 & reg_not=="2"

keep folioviv foliohog numren folio2 ing_for_neg_na ing_inf_neg_na ing_h_neg_na1 ing_h_neg_na2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro16.dta", replace
*Ahora para negocios agropecuarios*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_agro16.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Ingreso informal*
gen ing_inf_neg_a= ing_tri if t_emp<=5 & reg_not=="2"
*Hibrido de tamaÒo pequeÒo y si tiene registro*
gen ing_h_neg_a1= ing_tri if t_emp<=5 & reg_not=="1"

*Ingreso formal*
gen ing_for_neg_a= ing_tri if t_emp>5 & reg_not=="1"
*Hibrido de tamaÒo grande y no tiene registro*
gen ing_h_neg_a2= ing_tri if t_emp>5 & reg_not=="2"

keep folioviv foliohog numren folio2 ing_for_neg_a ing_inf_neg_a ing_h_neg_a1 ing_h_neg_a2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_agro16.dta", replace
*Fusionamos con negocios agro*
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", update
drop _merge
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", replace
*Fusionamos con negocios no agro*
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro16.dta", update
drop _merge
duplicates drop folio2, force
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", replace



**Ahora sumamos los ingresos generados por hogar*
*Suma de los negocios*
collapse (sum) ing_inf_neg_a, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_for_neg_a, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_inf_neg_na, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_for_neg_na, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna16.dta", replace
*Suma de ingresos por trabajo*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_inf_trab, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_for_trab, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab16.dta", replace
*Suma de los hibridos*
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_h_neg_a1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega1_16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_h_neg_a2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega2_16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_h_neg_na1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna1_16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_h_neg_na2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna2_16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_h_trab1, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab1_16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_h_trab2, by(folioviv foliohog)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab2_16.dta", replace


*Abrimos la base del concentrado para generar la llave* 
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base concen\concen_16.dta", clear
gen folio3=folioviv+foliohog
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base concen\concen_16", replace

*Fusionamos con la base de concentrado que contiene la info sobre hogares, las bases sumadas por hogares previamente*
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega16.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega16.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna16.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna16.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab16.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab16.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab1_16.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_htrab2_16.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega1_16.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnega2_16.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna1_16.dta", update
drop _merge
merge 1:1 folioviv foliohog using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_hnegna2_16.dta", update
drop _merge


*Generamos una variable que sea el total de todos los ingresos formales e informales*

gen ing_inf_neg= ing_inf_neg_a+ ing_inf_neg_na
gen ing_for_neg= ing_for_neg_a+ ing_for_neg_na
gen ing_hibrido_neg1= ing_h_neg_a1+ing_h_neg_na1
gen ing_hibrido_neg2= ing_h_neg_a2+ing_h_neg_na2
gen ing_hibrido_trab= ing_h_trab1+ing_h_trab2


*Generamos los ingresos totales para formal e informal*
gen ing_inf= ing_inf_neg+ ing_inf_trab
gen ing_for= ing_for_neg+ ing_for_trab
gen ing_hibridos= ing_hibrido_neg1+ing_hibrido_neg2+ing_hibrido_trab
gen clas_hog= 1 if (ing_for & ing_inf) & (ing_for!=. & ing_inf!=.) 
replace clas_hog= 2 if (ing_for & ing_hibridos) & (ing_for!=. & ing_hibridos!=.)
replace clas_hog= 3 if (ing_inf & ing_hibridos) & (ing_inf!=. & ing_hibridos!=.)
replace clas_hog= 4 if (ing_inf & ing_for & ing_hibridos) & (ing_inf!=. & ing_for!=. & ing_hibridos!=.)  
replace clas_hog= 5 if (ing_for & ing_for!=.) & (ing_inf==0 & ing_hibridos==0) //formal
replace clas_hog= 6 if (ing_inf & ing_inf!=.) & (ing_for==0 & ing_hibridos==0) //informal
replace clas_hog= 7 if (ing_hibridos & ing_hibridos!=.) & (ing_for==0 & ing_inf==0) //hibridos
replace clas_hog= 8 if (ingtrab==0 & negocio==0)
gen folio2=folioviv+foliohog
order folio2
sort folio2

*Tabulacion de hogares*
tab clas_hog [fw=factor]

save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_16.dta", replace



****CONCLUSI”N*********
