**TESIS: INFORMALIDAD Y DESIGUALDAD, 2018, AUTOR: PORFIRIO MENDIZÁBAL

/*El objetivo es clasificar los ingresos de los hogares en dos: formales e informales,
para esto se debe buscar primero a los negocios e integrantes del hogar y clasificarlos, con esto
se puede afirmar si dichos ingresos provienen de la informalidad o no.

El concepto de informalidad es: el individuo labora en un lugar de hasta 5 trabajadores
y no cuenta con prestaciones, el negocio solo tiene hasta 5 trabajadores y no está registrado
ante notario.

*/

**2008**

*Personas

/*Las variables necesarias son prestaciones y tamaño de la empresa. La primera se debe 
construir con ayuda sobre si la persona cuenta con alguna institución médica, esta se encuentra
en la base de Poblacion. Para la segunda, se encuentra en la base concentrado de trabajos.
Para esto hay que generar una variable llave para poder hacer la fusion
*/

use "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases originales\Base poblacion\Pobla_08.dta", clear
gen folio2= folioviv+ foliohog+ numren
gen prestacion=1 
/*En esta edición solo se genera una variable que toma en cuenta la información de las instituciones
médicas proporcionadas por el Estado*/
replace prestacion=0 if inst_1==1 | inst_2==2 | inst_3==3 | inst_4==4 
keep folio2 folioviv foliohog numren prestacion
order folio2
save "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases generadas\Base poblacion\pob_08.dta", replace
*Ahora utilizamos la base de trabajos para extraer la info sobre tamaño de la empresa
use "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases originales\Base trabajos\Trab_08.dta", clear
gen folio2= folioviv+ foliohog+ numren
gen tam_empr=1
**Condición donde el lugar donde labora la persona cuenta con 6 o más trabajadores
replace tam_empr=0 if tam_emp>=03 
keep folio2 folioviv foliohog numren tam_empr
save "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases generadas\Base trabajos\trab_08.dta", replace
merge m:1 folio2 using "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases generadas\Base poblacion\pob_08.dta", update
drop _merge
save "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace

use "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases originales\Base ingresos\ingresos_08.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
*Seleccionamos los ingresos provenientes del trabajo principal
gen ing_trab= ing_tri if clave=="P001" | clave=="P002" | clave=="P003" | clave=="P004" | clave=="P005"  ///
|clave=="P006" | clave=="P007" | clave=="P008" | clave=="P009" | clave=="P010" | clave=="P011" | clave=="P012" /// 
| clave=="P013"  
keep folio2 folioviv foliohog numren ing_trab
save "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases generadas\Base ingresos\ing_08.dta", replace
merge m:m folio2 using "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", update
drop _merge
duplicates drop folio2, force
save "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace


*Negocios

/*Las variables necesarias son registro ante notario y tamaño de la empresa. La primera se debe 
construir con ayuda sobre si el negocio cuenta con algun registro ante notario, esta se encuentra
en la base de Negocios. Para la segunda, se encuentra en la misma base.
Para esto hay que generar una variable llave para poder hacer la fusion.
*/
 
use "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases originales\Base negocios\neg_noagro08.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
gen ing_inf_neg= ing_tri if t_emp<=5 & reg_not==2
*Pero para negocios formales no existen obervaciones
gen ing_for_neg= ing_tri if t_emp>5 & reg_not==1
keep folioviv foliohog numren folio2 ing_for_neg ing_inf_neg
save "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases generadas\Base negocios\neg_noagro08.dta", replace
use "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases originales\Base negocios\neg_agro08.dta", clear
gen folio2= folioviv+ foliohog+ numren
order folio2
keep folioviv foliohog numren folio2 t_emp reg_not ing_tri
gen ing_inf_neg= ing_tri if t_emp<=5 & reg_not==2
*Pero para negocios formales no existen obervaciones
gen ing_for_neg= ing_tri if t_emp>5 & reg_not==1
keep folioviv foliohog numren folio2 ing_for_neg ing_inf_neg
save "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases generadas\Base negocios\neg_agro08.dta", replace
*Fusionamos con negocios agro
merge m:m folio2 using "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", update
drop _merge
sort folio2
save "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace
*Fusionamos con negocios no agro
merge m:m folio2 using "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases generadas\Base negocios\neg_noagro08.dta", update
drop _merge
sort folio2
save "C:\Users\Terminal 6\Documents\INFORMALIDAD TESIS\Calculos\Bases generadas\Base definitiva\infor_desig_08.dta", replace






 