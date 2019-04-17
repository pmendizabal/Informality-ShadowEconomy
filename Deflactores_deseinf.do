
**TESIS: INFORMALIDAD Y DESIGUALDAD, 2018, AUTOR: PORFIRIO MENDIZÁBAL

***El objetivo es delflactar todos los ingresos para agosto de 2014
**FALTA AJUSTAR TODOS LOS INGRESOS QUE SE HAN SACADO

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_08", clear

				scalar ago08= 0.78769678 
                
				gen ing_inf_mes= ing_inf/3
				gen ing_for_mes= ing_for/3
                gen otros_ing_mes= otros_ing/3
				gen ing_tot_mes= ing_tot/3
				gen ingcor_mes= ingcor/3
				
				gen ing_inf_de= ing_inf_mes/ago08
				gen ing_for_de= ing_for_mes/ago08
				gen otros_ing_mes_de= otros_ing_mes/ago08
                gen ing_tot_mes_de= ing_tot_mes/ago08
				gen ing_cor_mes_de= ingcor_mes/ago08


				
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi__de08", replace
				
use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_10", clear
			
				
                 scalar ago10= 0.85815277
				gen ing_inf_mes= ing_inf/3
				gen ing_for_mes= ing_for/3
                gen otros_ing_mes= otros_ing/3
				gen ing_tot_mes= ing_tot/3
				gen ingcor_mes= ingcor/3

				
				gen ing_inf_de= ing_inf_mes/ago10
				gen ing_for_de= ing_for_mes/ago10
				gen otros_ing_mes_de= otros_ing_mes/ago10
                gen ing_tot_mes_de= ing_tot_mes/ago10
				gen ing_cor_mes_de= ingcor_mes/ago10


save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi__de10", replace

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_12", clear

				scalar ago12= 0.92807525 
				gen ing_inf_mes= ing_inf/3
				gen ing_for_mes= ing_for/3
                gen otros_ing_mes= otros_ing/3
				gen ing_tot_mes= ing_tot/3
				gen ingcor_mes= ing_cor/3
								
				
				gen ing_inf_de= ing_inf_mes/ago12
				gen ing_for_de= ing_for_mes/ago12
				gen otros_ing_mes_de= otros_ing_mes/ago12
                gen ing_tot_mes_de= ing_tot_mes/ago12
				gen ing_cor_mes_de= ingcor_mes/ago12

				
		
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi__de12", replace

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_14", clear

                scalar ago14= 1
				gen ing_inf_mes= ing_inf/3
				gen ing_for_mes= ing_for/3
                gen otros_ing_mes= otros_ing/3
				gen ing_tot_mes= ing_tot/3
				gen ingcor_mes= ing_cor/3

				
				gen ing_inf_de= ing_inf_mes/ago14
				gen ing_for_de= ing_for_mes/ago14
				gen otros_ing_mes_de= otros_ing_mes/ago14
                gen ing_tot_mes_de= ing_tot_mes/ago14
				gen ing_cor_mes_de= ingcor_mes/ago14


save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi__de14", replace

use "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi_16", clear


				scalar ago16= 1.053853 
				gen ing_inf_mes= ing_inf/3
				gen ing_for_mes= ing_for/3
                gen otros_ing_mes= otros_ing/3
				gen ing_tot_mes= ing_tot/3
				gen ingcor_mes= ing_cor/3

				
				gen ing_inf_de= ing_inf_mes/ago16
				gen ing_for_de= ing_for_mes/ago16
				gen otros_ing_mes_de= otros_ing_mes/ago16
                gen ing_tot_mes_de= ing_tot_mes/ago16
				gen ing_cor_mes_de= ingcor_mes/ago16


				
save "C:\Users\Thosiba User\Documents\TESIS\Calculos\Bases generadas\Base definitiva\Base_ing_infoydesi__de16", replace
		
