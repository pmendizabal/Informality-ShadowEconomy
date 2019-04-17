**TESIS: INFORMALIDAD Y DESIGUALDAD, 2018, AUTOR: PORFIRIO MENDIZÁBAL

/*El objetivo es clasificar los ingresos de los hogares en dos: formales e informales,
para esto se debe buscar primero a los negocios e integrantes del hogar y clasificarlos, con esto
se puede afirmar si dichos ingresos provienen de la informalidad o no.

El concepto de informalidad es: el individuo labora en un lugar de hasta 10 trabajadores
y no cuenta con prestaciones, el negocio solo tiene hasta 10 trabajadores y no está registrado
ante notario.


*/

**2008**

*Personas

/*Las variables necesarias son prestaciones y tamaño de la empresa. La primera se debe 
construir con ayuda sobre si la persona cuenta con alguna institución médica, esta se encuentra
en la base de Poblacion. Para la segunda, se encuentra en la base concentrado de trabajos.
Para esto hay que generar una variable llave para poder hacer la fusion
*/

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base pobla\Pobla_08.dta", clear
gen folio2= folioviv+ foliohog+ numren
gen prestacion=1 
/*En esta edición solo se genera una variable que toma en cuenta la información de las instituciones
médicas proporcionadas por el Estado*/
replace prestacion=0 if inst_1==1 | inst_2==2 | inst_3==3 | inst_4==4 
keep folio2 folioviv foliohog numren prestacion
order folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_08.dta", replace
*Ahora utilizamos la base de trabajos para extraer la info sobre tamaño de la empresa
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base trabajos\Trab_08.dta", clear
gen folio2= folioviv+ foliohog+ numren
gen tam_empr=1
**Condición donde el lugar donde labora la persona cuenta con 6 o más trabajadores
replace tam_empr=0 if tam_emp>=03 
keep folio2 folioviv foliohog numren tam_empr
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_08.dta", replace
merge m:1 folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_08.dta", update
drop _merge
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base ingresos\ingresos_08.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
*Seleccionamos los ingresos provenientes del trabajo 
gen ing_trab= ing_tri if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P005"  ///
|clave=="P006" | clave=="P007" | clave=="P008" | clave=="P009" | clave=="P010" | clave=="P011" | clave=="P012" /// 
| clave=="P013" | clave=="P014" | clave=="P015" | clave=="P016" | clave=="P017" | clave=="P018" | clave=="P019"   
keep folio2 folioviv foliohog numren ing_trab
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base ingresos\ing_08.dta", replace
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", update
drop _merge
duplicates drop folio2, force
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace


*Negocios

/*Las variables necesarias son registro ante notario y tamaño de la empresa. La primera se debe 
construir con ayuda sobre si el negocio cuenta con algun registro ante notario, esta se encuentra
en la base de Negocios. Para la segunda, se encuentra en la misma base.
Para esto hay que generar una variable llave para poder hacer la fusion.
*/
 
*Primero para negocios no agro
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_noagro08.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Generamos los ingresos provenientes de negocios informales
gen ing_inf_neg_na= ing_tri if t_emp<=10 & reg_not==2
*Ahora para los formales
gen ing_for_neg_na= ing_tri if t_emp>10 & reg_not==1
keep folioviv foliohog numren folio2 ing_for_neg_na ing_inf_neg_na
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro08.dta", replace
*Ahora para negocios agropecuarios
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_agro08.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
gen ing_inf_neg_a= ing_tri if t_emp<=10 & reg_not==2
*Pero para negocios formales no existen obervaciones
gen ing_for_neg_a= ing_tri if t_emp>10 & reg_not==1
keep folioviv foliohog numren folio2 ing_for_neg_a ing_inf_neg_a
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_agro08.dta", replace
*Fusionamos con negocios agro
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", update
drop _merge
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace
*Fusionamos con negocios no agro
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro08.dta", update
drop _merge
duplicates drop folio2, force
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace

*Generamos la variabel de ingreso informal para trabajo
gen ing_inf_trab= ing_trab if tam_empr==1 & prestacion==1
gen ing_for_trab= ing_trab if tam_empr==0 & prestacion==0
gen folio3=folioviv+foliohog
sort folio3
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace


**Ahora sumamos los ingresos generados por hogar
*Suma de los negocios
collapse (sum) ing_inf_neg_a, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_for_neg_a, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_inf_neg_na, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_for_neg_na, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna08.dta", replace
*Suma de ingresos por trabajo
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_inf_trab, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab08.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", clear
collapse (sum) ing_for_trab, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab08.dta", replace


*Abrimos la base del concentrado para generar la llave 
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base concen\concen_08.dta", clear
gen folio3=folioviv+foliohog
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base concen\concen_08", replace

*Fusionamos con la base de concentrado que contiene la info sobre hogares, las bases sumadas por hogares previamente
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega08.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega08.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna08.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna08.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab08.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab08.dta", update
drop _merge

*Generamos una variable que sea el total de todos los ingresos formales e informales
gen ing_inf_neg= ing_inf_neg_a+ ing_inf_neg_na
gen ing_for_neg= ing_for_neg_a+ ing_for_neg_na
gen ing_tot= ing_inf_neg+ ing_for_neg+ ing_inf_trab+ ing_for_trab
*Generamos otros ingresos
gen otros_ing= ingcor- ing_tot
*Generamos los ingresos totales para formal e informal
gen ing_inf= ing_inf_neg+ ing_inf_trab
gen ing_for= ing_for_neg+ ing_for_trab
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_08.dta", replace



**2010**

*Personas

/*Las variables necesarias son prestaciones y tamaño de la empresa. La primera se debe 
construir con ayuda sobre si la persona cuenta con alguna institución médica, esta se encuentra
en la base de Poblacion. Para la segunda, se encuentra en la base concentrado de trabajos.
Para esto hay que generar una variable llave para poder hacer la fusion
*/

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base pobla\Pobla_10.dta", clear
gen folio2= folioviv+ foliohog+ numren
gen prestacion=1 
/*En esta edición solo se genera una variable que toma en cuenta la información de las instituciones
médicas proporcionadas por el Estado*/
replace prestacion=0 if inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4" 
keep folio2 folioviv foliohog numren prestacion
order folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_10.dta", replace
*Ahora utilizamos la base de trabajos para extraer la info sobre tamaño de la empresa
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base trabajos\Trab_10.dta", clear
gen folio2= folioviv+ foliohog+ numren
gen tam_empr=1
**Condición donde el lugar donde labora la persona cuenta con 6 o más trabajadores
replace tam_empr=0 if tam_emp>="03" 
keep folio2 folioviv foliohog numren tam_empr
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_10.dta", replace
merge m:1 folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_10.dta", update
drop _merge
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", replace

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base ingresos\ingresos_10.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
*Seleccionamos los ingresos provenientes del trabajo 
gen ing_trab= ing_tri if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P005"  ///
|clave=="P006" | clave=="P007" | clave=="P008" | clave=="P009" | clave=="P010" | clave=="P011" | clave=="P012" /// 
| clave=="P013" | clave=="P014" | clave=="P015" | clave=="P016" | clave=="P017" | clave=="P018" | clave=="P019"   
keep folio2 folioviv foliohog numren ing_trab
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base ingresos\ing_10.dta", replace
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", update
drop _merge
duplicates drop folio2, force
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", replace


*Negocios

/*Las variables necesarias son registro ante notario y tamaño de la empresa. La primera se debe 
construir con ayuda sobre si el negocio cuenta con algun registro ante notario, esta se encuentra
en la base de Negocios. Para la segunda, se encuentra en la misma base.
Para esto hay que generar una variable llave para poder hacer la fusion.
*/
 
*Primero para negocios no agro
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_noagro10.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Generamos los ingresos provenientes de negocios informales
gen ing_inf_neg_na= ing_tri if t_emp<=10 & reg_not=="2"
*Ahora para los formales
gen ing_for_neg_na= ing_tri if t_emp>10 & reg_not=="1"
keep folioviv foliohog numren folio2 ing_for_neg_na ing_inf_neg_na
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro10.dta", replace
*Ahora para negocios agropecuarios
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_agro10.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
gen ing_inf_neg_a= ing_tri if t_emp<=10 & reg_not==2
*Pero para negocios formales no existen obervaciones
gen ing_for_neg_a= ing_tri if t_emp>10 & reg_not==1
keep folioviv foliohog numren folio2 ing_for_neg_a ing_inf_neg_a
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_agro10.dta", replace
*Fusionamos con negocios agro
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", update
drop _merge
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", replace
*Fusionamos con negocios no agro
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro10.dta", update
drop _merge
duplicates drop folio2, force
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", replace

*Generamos la variabel de ingreso informal para trabajo
gen ing_inf_trab= ing_trab if tam_empr==1 & prestacion==1
gen ing_for_trab= ing_trab if tam_empr==0 & prestacion==0
gen folio3=folioviv+foliohog
sort folio3
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", replace


**Ahora sumamos los ingresos generados por hogar
*Suma de los negocios
collapse (sum) ing_inf_neg_a, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_for_neg_a, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_inf_neg_na, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_for_neg_na, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna10.dta", replace
*Suma de ingresos por trabajo
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_inf_trab, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab10.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_10.dta", clear
collapse (sum) ing_for_trab, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab10.dta", replace


*Abrimos la base del concentrado para generar la llave 
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base concen\concen_10.dta", clear
gen folio3=folioviv+foliohog
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base concen\concen_10", replace

*Fusionamos con la base de concentrado que contiene la info sobre hogares, las bases sumadas por hogares previamente
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega10.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega10.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna10.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna10.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab10.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab10.dta", update
drop _merge

*Generamos una variable que sea el total de todos los ingresos formales e informales
gen ing_inf_neg= ing_inf_neg_a+ ing_inf_neg_na
gen ing_for_neg= ing_for_neg_a+ ing_for_neg_na
gen ing_tot= ing_inf_neg+ ing_for_neg+ ing_inf_trab+ ing_for_trab
*Generamos otros ingresos
gen otros_ing= ingcor- ing_tot
*Generamos los ingresos totales para formal e informal
gen ing_inf= ing_inf_neg+ ing_inf_trab
gen ing_for= ing_for_neg+ ing_for_trab
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_10.dta", replace



**2012**

*Personas

/*Las variables necesarias son prestaciones y tamaño de la empresa. La primera se debe 
construir con ayuda sobre si la persona cuenta con alguna institución médica, esta se encuentra
en la base de Poblacion. Para la segunda, se encuentra en la base concentrado de trabajos.
Para esto hay que generar una variable llave para poder hacer la fusion
*/

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base pobla\Pobla_12.dta", clear
gen folio2= folioviv+ foliohog+ numren
gen prestacion=1 
/*En esta edición solo se genera una variable que toma en cuenta la información de las instituciones
médicas proporcionadas por el Estado*/
replace prestacion=0 if inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4" 
keep folio2 folioviv foliohog numren prestacion
order folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_12.dta", replace
*Ahora utilizamos la base de trabajos para extraer la info sobre tamaño de la empresa
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base trabajos\Trab_12.dta", clear
gen folio2= folioviv+ foliohog+ numren
gen tam_empr=1
**Condición donde el lugar donde labora la persona cuenta con 6 o más trabajadores
replace tam_empr=0 if tam_emp>="03" 
keep folio2 folioviv foliohog numren tam_empr
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_12.dta", replace
merge m:1 folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_12.dta", update
drop _merge
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", replace

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base ingresos\ingresos_12.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
*Seleccionamos los ingresos provenientes del trabajo 
gen ing_trab= ing_tri if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P005"  ///
|clave=="P006" | clave=="P007" | clave=="P008" | clave=="P009" | clave=="P010" | clave=="P011" | clave=="P012" /// 
| clave=="P013" | clave=="P014" | clave=="P015" | clave=="P016" | clave=="P017" | clave=="P018" | clave=="P019"   
keep folio2 folioviv foliohog numren ing_trab
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base ingresos\ing_12.dta", replace
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", update
drop _merge
duplicates drop folio2, force
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", replace


*Negocios

/*Las variables necesarias son registro ante notario y tamaño de la empresa. La primera se debe 
construir con ayuda sobre si el negocio cuenta con algun registro ante notario, esta se encuentra
en la base de Negocios. Para la segunda, se encuentra en la misma base.
Para esto hay que generar una variable llave para poder hacer la fusion.
*/
 
*Primero para negocios no agro
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_noagro12.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Generamos los ingresos provenientes de negocios informales
gen ing_inf_neg_na= ing_tri if t_emp<=10 & reg_not=="2"
*Ahora para los formales
gen ing_for_neg_na= ing_tri if t_emp>10 & reg_not=="1"
keep folioviv foliohog numren folio2 ing_for_neg_na ing_inf_neg_na
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro12.dta", replace
*Ahora para negocios agropecuarios
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_agro12.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
gen ing_inf_neg_a= ing_tri if t_emp<=10 & reg_not=="2"
*Pero para negocios formales no existen obervaciones
gen ing_for_neg_a= ing_tri if t_emp>10 & reg_not=="1"
keep folioviv foliohog numren folio2 ing_for_neg_a ing_inf_neg_a
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_agro12.dta", replace
*Fusionamos con negocios agro
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", update
drop _merge
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", replace
*Fusionamos con negocios no agro
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro12.dta", update
drop _merge
duplicates drop folio2, force
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", replace

*Generamos la variabel de ingreso informal para trabajo
gen ing_inf_trab= ing_trab if tam_empr==1 & prestacion==1
gen ing_for_trab= ing_trab if tam_empr==0 & prestacion==0
gen folio3=folioviv+foliohog
sort folio3
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", replace


**Ahora sumamos los ingresos generados por hogar
*Suma de los negocios
collapse (sum) ing_inf_neg_a, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_for_neg_a, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_inf_neg_na, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_for_neg_na, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna12.dta", replace
*Suma de ingresos por trabajo
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_inf_trab, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab12.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_12.dta", clear
collapse (sum) ing_for_trab, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab12.dta", replace


*Abrimos la base del concentrado para generar la llave 
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base concen\concen_12.dta", clear
gen folio3=folioviv+foliohog
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base concen\concen_12", replace

*Fusionamos con la base de concentrado que contiene la info sobre hogares, las bases sumadas por hogares previamente
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega12.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega12.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna12.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna12.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab12.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab12.dta", update
drop _merge

*Generamos una variable que sea el total de todos los ingresos formales e informales
gen ing_inf_neg= ing_inf_neg_a+ ing_inf_neg_na
gen ing_for_neg= ing_for_neg_a+ ing_for_neg_na
gen ing_tot= ing_inf_neg+ ing_for_neg+ ing_inf_trab+ ing_for_trab
*Generamos otros ingresos
gen otros_ing= ing_cor- ing_tot
*Generamos los ingresos totales para formal e informal
gen ing_inf= ing_inf_neg+ ing_inf_trab
gen ing_for= ing_for_neg+ ing_for_trab
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_12.dta", replace



**2014**

*Personas

/*Las variables necesarias son prestaciones y tamaño de la empresa. La primera se debe 
construir con ayuda sobre si la persona cuenta con alguna institución médica, esta se encuentra
en la base de Poblacion. Para la segunda, se encuentra en la base concentrado de trabajos.
Para esto hay que generar una variable llave para poder hacer la fusion
*/

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base pobla\Pobla_14.dta", clear
gen folio2= folioviv+ foliohog+ numren
gen prestacion=1 
/*En esta edición solo se genera una variable que toma en cuenta la información de las instituciones
médicas proporcionadas por el Estado*/
replace prestacion=0 if inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4" 
keep folio2 folioviv foliohog numren prestacion
order folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_14.dta", replace
*Ahora utilizamos la base de trabajos para extraer la info sobre tamaño de la empresa
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base trabajos\Trab_14.dta", clear
gen folio2= folioviv+ foliohog+ numren
gen tam_empr=1
**Condición donde el lugar donde labora la persona cuenta con 6 o más trabajadores
replace tam_empr=0 if tam_emp>="03" 
keep folio2 folioviv foliohog numren tam_empr
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_14.dta", replace
merge m:1 folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_14.dta", update
drop _merge
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", replace

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base ingresos\ingresos_14.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
*Seleccionamos los ingresos provenientes del trabajo 
gen ing_trab= ing_tri if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P005"  ///
|clave=="P006" | clave=="P007" | clave=="P008" | clave=="P009" | clave=="P010" | clave=="P011" | clave=="P012" /// 
| clave=="P013" | clave=="P014" | clave=="P015" | clave=="P016" | clave=="P017" | clave=="P018" | clave=="P019"   
keep folio2 folioviv foliohog numren ing_trab
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base ingresos\ing_14.dta", replace
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", update
drop _merge
duplicates drop folio2, force
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", replace


*Negocios

/*Las variables necesarias son registro ante notario y tamaño de la empresa. La primera se debe 
construir con ayuda sobre si el negocio cuenta con algun registro ante notario, esta se encuentra
en la base de Negocios. Para la segunda, se encuentra en la misma base.
Para esto hay que generar una variable llave para poder hacer la fusion.
*/
 
*Primero para negocios no agro
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_noagro14.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Generamos los ingresos provenientes de negocios informales
gen ing_inf_neg_na= ing_tri if t_emp<=10 & reg_not=="2"
*Ahora para los formales
gen ing_for_neg_na= ing_tri if t_emp>10 & reg_not=="1"
keep folioviv foliohog numren folio2 ing_for_neg_na ing_inf_neg_na
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro14.dta", replace
*Ahora para negocios agropecuarios
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_agro14.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
gen ing_inf_neg_a= ing_tri if t_emp<=10 & reg_not=="2"
*Pero para negocios formales no existen obervaciones
gen ing_for_neg_a= ing_tri if t_emp>10 & reg_not=="1"
keep folioviv foliohog numren folio2 ing_for_neg_a ing_inf_neg_a
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_agro14.dta", replace
*Fusionamos con negocios agro
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", update
drop _merge
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", replace
*Fusionamos con negocios no agro
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro14.dta", update
drop _merge
duplicates drop folio2, force
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", replace

*Generamos la variabel de ingreso informal para trabajo
gen ing_inf_trab= ing_trab if tam_empr==1 & prestacion==1
gen ing_for_trab= ing_trab if tam_empr==0 & prestacion==0
gen folio3=folioviv+foliohog
sort folio3
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", replace


**Ahora sumamos los ingresos generados por hogar
*Suma de los negocios
collapse (sum) ing_inf_neg_a, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_for_neg_a, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_inf_neg_na, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_for_neg_na, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna14.dta", replace
*Suma de ingresos por trabajo
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_inf_trab, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab14.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_14.dta", clear
collapse (sum) ing_for_trab, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab14.dta", replace


*Abrimos la base del concentrado para generar la llave 
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base concen\concen_14.dta", clear
gen folio3=folioviv+foliohog
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base concen\concen_14", replace

*Fusionamos con la base de concentrado que contiene la info sobre hogares, las bases sumadas por hogares previamente
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega14.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega14.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna14.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna14.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab14.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab14.dta", update
drop _merge

*Generamos una variable que sea el total de todos los ingresos formales e informales
gen ing_inf_neg= ing_inf_neg_a+ ing_inf_neg_na
gen ing_for_neg= ing_for_neg_a+ ing_for_neg_na
gen ing_tot= ing_inf_neg+ ing_for_neg+ ing_inf_trab+ ing_for_trab
*Generamos otros ingresos
gen otros_ing= ing_cor- ing_tot
*Generamos los ingresos totales para formal e informal
gen ing_inf= ing_inf_neg+ ing_inf_trab
gen ing_for= ing_for_neg+ ing_for_trab
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_14.dta", replace




**2016**

*Personas

/*Las variables necesarias son prestaciones y tamaño de la empresa. La primera se debe 
construir con ayuda sobre si la persona cuenta con alguna institución médica, esta se encuentra
en la base de Poblacion. Para la segunda, se encuentra en la base concentrado de trabajos.
Para esto hay que generar una variable llave para poder hacer la fusion
*/

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base pobla\Pobla_16.dta", clear
gen folio2= folioviv+ foliohog+ numren
gen prestacion=1 
/*En esta edición solo se genera una variable que toma en cuenta la información de las instituciones
médicas proporcionadas por el Estado*/
replace prestacion=0 if inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4" 
keep folio2 folioviv foliohog numren prestacion
order folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_16.dta", replace
*Ahora utilizamos la base de trabajos para extraer la info sobre tamaño de la empresa
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base trabajos\Trab_16.dta", clear
gen folio2= folioviv+ foliohog+ numren
gen tam_empr=1
**Condición donde el lugar donde labora la persona cuenta con 6 o más trabajadores
replace tam_empr=0 if tam_emp>="03" 
keep folio2 folioviv foliohog numren tam_empr
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base trabajos\trab_16.dta", replace
merge m:1 folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base poblacion\pob_16.dta", update
drop _merge
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", replace

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base ingresos\ingresos_16.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
*Seleccionamos los ingresos provenientes del trabajo 
gen ing_trab= ing_tri if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P005"  ///
|clave=="P006" | clave=="P007" | clave=="P008" | clave=="P009" | clave=="P010" | clave=="P011" | clave=="P012" /// 
| clave=="P013" | clave=="P014" | clave=="P015" | clave=="P016" | clave=="P017" | clave=="P018" | clave=="P019"   
keep folio2 folioviv foliohog numren ing_trab
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base ingresos\ing_16.dta", replace
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", update
drop _merge
duplicates drop folio2, force
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", replace


*Negocios

/*Las variables necesarias son registro ante notario y tamaño de la empresa. La primera se debe 
construir con ayuda sobre si el negocio cuenta con algun registro ante notario, esta se encuentra
en la base de Negocios. Para la segunda, se encuentra en la misma base.
Para esto hay que generar una variable llave para poder hacer la fusion.
*/
 
*Primero para negocios no agro
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_noagro16.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
*Generamos los ingresos provenientes de negocios informales
gen ing_inf_neg_na= ing_tri if t_emp<=10 & reg_not=="2"
*Ahora para los formales
gen ing_for_neg_na= ing_tri if t_emp>10 & reg_not=="1"
keep folioviv foliohog numren folio2 ing_for_neg_na ing_inf_neg_na
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro16.dta", replace
*Ahora para negocios agropecuarios
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base negocios\neg_agro16.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
gen ing_inf_neg_a= ing_tri if t_emp<=10 & reg_not=="2"
*Pero para negocios formales no existen obervaciones
gen ing_for_neg_a= ing_tri if t_emp>10 & reg_not=="1"
keep folioviv foliohog numren folio2 ing_for_neg_a ing_inf_neg_a
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_agro16.dta", replace
*Fusionamos con negocios agro
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", update
drop _merge
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", replace
*Fusionamos con negocios no agro
merge m:m folio2 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base negocios\neg_noagro16.dta", update
drop _merge
duplicates drop folio2, force
sort folio2
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", replace

*Generamos la variabel de ingreso informal para trabajo
gen ing_inf_trab= ing_trab if tam_empr==1 & prestacion==1
gen ing_for_trab= ing_trab if tam_empr==0 & prestacion==0
gen folio3=folioviv+foliohog
sort folio3
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", replace


**Ahora sumamos los ingresos generados por hogar
*Suma de los negocios
collapse (sum) ing_inf_neg_a, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_for_neg_a, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_inf_neg_na, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_for_neg_na, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna16.dta", replace
*Suma de ingresos por trabajo
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_inf_trab, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab16.dta", replace
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_16.dta", clear
collapse (sum) ing_for_trab, by(folio3)
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab16.dta", replace


*Abrimos la base del concentrado para generar la llave 
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases originales\Base concen\concen_16.dta", clear
gen folio3=folioviv+foliohog
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base concen\concen_16", replace

*Fusionamos con la base de concentrado que contiene la info sobre hogares, las bases sumadas por hogares previamente
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnega16.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornega16.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fornegna16.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_infnegna16.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_inftrab16.dta", update
drop _merge
merge 1:1 folio3 using "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base sumadas\sum_fortrab16.dta", update
drop _merge

*Generamos una variable que sea el total de todos los ingresos formales e informales
gen ing_inf_neg= ing_inf_neg_a+ ing_inf_neg_na
gen ing_for_neg= ing_for_neg_a+ ing_for_neg_na
gen ing_tot= ing_inf_neg+ ing_for_neg+ ing_inf_trab+ ing_for_trab
*Generamos otros ingresos
gen otros_ing= ing_cor- ing_tot
*Generamos los ingresos totales para formal e informal
gen ing_inf= ing_inf_neg+ ing_inf_trab
gen ing_for= ing_for_neg+ ing_for_trab
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_16.dta", replace
