clear 
set more off
log c _all

***************************************************************
**CARPETA DE TRABAJO
cd "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva"
***************************************************************




* Crea macro con los aÃ±os para correr rutina por bases


 local base " 08 10 12 14 16"  

	foreach x of local base {

			use Base_ing_infoydesi__de`x'.dta, clear

				dis "------------------------------"
				dis as text "ENIGH año" "`x'"
				dis "-------------------------------"
				
			
			 *Proporción de hogares segun tipo de ingreso
			 gen eco_informal= 1 if ing_inf_de
			 replace eco_informal= 0 if ing_for_de
			 tab eco_informal [fw=factor], miss
			 
			 save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi__`x'.dta", replace
			
			 *Cruce entre ingresos formales e informales
			 gen econo_informal= 1 if ing_inf_de
			 gen econo_formal= 1 if ing_for_de
			 gen econo_otros= 1 if otros_ing_mes_de
			 tab econo_informal [fw=factor], miss
			 tab econo_formal [fw=factor], miss
			 tab econo_otros [fw=factor], miss
			 
			 save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi__`x'.dta", replace

			 *Medidas de desigualdad
			 fastgini ing_inf_de [fw=factor] 
			 fastgini ing_for_de [fw=factor]
			 fastgini otros_ing_mes_de [fw=factor]
			 
			 *Deciles
			 xtile decil_ing_mes=ing_cor_mes_de [fw=factor], nq(10)
			 

	
			
	}

	
