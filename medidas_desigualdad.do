clear 
set more off
log c _all

***************************************************************
**CARPETA DE TRABAJO
cd "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva"
***************************************************************




* Crea macro con los años para correr rutina por bases


 local base " 08 10 12 14 16"  

	foreach x of local base {

			use Base_ing_infoydesi_de`x'.dta, clear

				dis "------------------------------"
				dis as text "ENIGH a�o" "`x'"
				dis "-------------------------------"
				
			
					
				* Ingreso corriente per capita deflactado
                    gen ictpc_de= ing_tot_mes_de/tam_hog
               
				* Deciles de ingreso monetario per cápita

					xtile decil_ing_mes=ing_tot_mes_de [fw=factor], nq(10) 
					xtile decil_ictpc_de=ictpc_de [fw=factor], nq(10) 

					
				* Medidas de desigualdad
				
                    ineqerr ing_tot_mes_de [w=factor], reps(50)
					ineqerr ictpc_de [w=factor], reps(50)


                    summ ing_tot_mes_de [w=factor],d

					
                 * Cociente de percentiles 90-10
                     di r(p90)/r(p10) 
                     sca total_ing=r(sum)
					 
					 
				 *Descomposicion de gini
				 descogini ing_tot_mes_de ing_inf_de ing_for_de otros_ing_mes_de
					 

				

				/* Crear los ingresos por perceptor 
				
					*gen ing_mes_percp= ing_mes/percep
					*gen laboral_percp=ing_lab/perlab
					*gen nolaboral_percp=ing_nolab/pernolab
	
	        foreach xt of numlist 1(1)10 {

            di as text "Ingreso en el decil `xt' de ingreso"
            tabstat ing_tot_mes_de if decil_ing_mes==`xt' [w=factor] , stats(mean sum) format(%20.0g) c(s)

            qui summ ing_tot_mes_de if decil_ing_mes==`xt' [w=factor] 
            di as text "Proporción del ingreso en manos del decil `xt'"
            di r(sum)/total_ing
}
			
					 foreach xt of numlist 1(1)10 {

            di as text "Ingreso en el decil `xt' de ingreso"
            tabstat ictpc_de if decil_ictpc_de==`xt' [w=factor*tam_hog] , stats(mean sum) format(%20.0g) c(s)

            qui summ ictpc_de if decil_ictpc_de==`xt' [w=factor*tam_hog] 
            di as text "Proporción del ingreso en manos del decil `xt'"
            di r(sum)/total_ing
					
			}		
		
		*/
			
	}

	
