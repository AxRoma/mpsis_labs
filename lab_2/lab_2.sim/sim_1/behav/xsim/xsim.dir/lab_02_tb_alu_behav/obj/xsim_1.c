/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2020 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
 #define IKI_DLLESPEC __declspec(dllimport)
#else
 #define IKI_DLLESPEC
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2020 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
 #define IKI_DLLESPEC __declspec(dllimport)
#else
 #define IKI_DLLESPEC
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
IKI_DLLESPEC extern void execute_21(char*, char *);
IKI_DLLESPEC extern void execute_23(char*, char *);
IKI_DLLESPEC extern void execute_101(char*, char *);
IKI_DLLESPEC extern void execute_122(char*, char *);
IKI_DLLESPEC extern void svlog_sampling_process_execute(char*, char*, char*);
IKI_DLLESPEC extern void sequence_expr_m_2b54eda7_5c6ca80d_1(char*, char *);
IKI_DLLESPEC extern void sequence_expr_m_2b54eda7_5c6ca80d_2(char*, char *);
IKI_DLLESPEC extern void vlog_sv_sequence_execute_0 (char*, char*, char*);
IKI_DLLESPEC extern void assertion_action_m_2b54eda7_5c6ca80d_1(char*, char *);
IKI_DLLESPEC extern void execute_362(char*, char *);
IKI_DLLESPEC extern void execute_363(char*, char *);
IKI_DLLESPEC extern void execute_364(char*, char *);
IKI_DLLESPEC extern void execute_365(char*, char *);
IKI_DLLESPEC extern void execute_366(char*, char *);
IKI_DLLESPEC extern void execute_367(char*, char *);
IKI_DLLESPEC extern void execute_368(char*, char *);
IKI_DLLESPEC extern void execute_369(char*, char *);
IKI_DLLESPEC extern void execute_370(char*, char *);
IKI_DLLESPEC extern void execute_371(char*, char *);
IKI_DLLESPEC extern void execute_98(char*, char *);
IKI_DLLESPEC extern void execute_99(char*, char *);
IKI_DLLESPEC extern void vlog_const_rhs_process_execute_0_fast_for_reg(char*, char*, char*);
IKI_DLLESPEC extern void execute_296(char*, char *);
IKI_DLLESPEC extern void execute_288(char*, char *);
IKI_DLLESPEC extern void execute_289(char*, char *);
IKI_DLLESPEC extern void execute_290(char*, char *);
IKI_DLLESPEC extern void execute_291(char*, char *);
IKI_DLLESPEC extern void execute_292(char*, char *);
IKI_DLLESPEC extern void execute_293(char*, char *);
IKI_DLLESPEC extern void execute_294(char*, char *);
IKI_DLLESPEC extern void execute_180(char*, char *);
IKI_DLLESPEC extern void execute_181(char*, char *);
IKI_DLLESPEC extern void execute_182(char*, char *);
IKI_DLLESPEC extern void execute_28(char*, char *);
IKI_DLLESPEC extern void execute_168(char*, char *);
IKI_DLLESPEC extern void vlog_simple_process_execute_0_fast_for_reg(char*, char*, char*);
IKI_DLLESPEC extern void execute_297(char*, char *);
IKI_DLLESPEC extern void execute_298(char*, char *);
IKI_DLLESPEC extern void execute_299(char*, char *);
IKI_DLLESPEC extern void execute_300(char*, char *);
IKI_DLLESPEC extern void execute_301(char*, char *);
IKI_DLLESPEC extern void execute_302(char*, char *);
IKI_DLLESPEC extern void execute_303(char*, char *);
IKI_DLLESPEC extern void execute_304(char*, char *);
IKI_DLLESPEC extern void execute_305(char*, char *);
IKI_DLLESPEC extern void execute_306(char*, char *);
IKI_DLLESPEC extern void execute_307(char*, char *);
IKI_DLLESPEC extern void execute_308(char*, char *);
IKI_DLLESPEC extern void execute_309(char*, char *);
IKI_DLLESPEC extern void execute_310(char*, char *);
IKI_DLLESPEC extern void execute_311(char*, char *);
IKI_DLLESPEC extern void execute_312(char*, char *);
IKI_DLLESPEC extern void execute_313(char*, char *);
IKI_DLLESPEC extern void execute_314(char*, char *);
IKI_DLLESPEC extern void execute_315(char*, char *);
IKI_DLLESPEC extern void execute_318(char*, char *);
IKI_DLLESPEC extern void execute_319(char*, char *);
IKI_DLLESPEC extern void execute_320(char*, char *);
IKI_DLLESPEC extern void execute_321(char*, char *);
IKI_DLLESPEC extern void execute_322(char*, char *);
IKI_DLLESPEC extern void execute_323(char*, char *);
IKI_DLLESPEC extern void execute_324(char*, char *);
IKI_DLLESPEC extern void execute_325(char*, char *);
IKI_DLLESPEC extern void execute_326(char*, char *);
IKI_DLLESPEC extern void execute_327(char*, char *);
IKI_DLLESPEC extern void execute_328(char*, char *);
IKI_DLLESPEC extern void execute_329(char*, char *);
IKI_DLLESPEC extern void execute_330(char*, char *);
IKI_DLLESPEC extern void execute_331(char*, char *);
IKI_DLLESPEC extern void execute_332(char*, char *);
IKI_DLLESPEC extern void execute_333(char*, char *);
IKI_DLLESPEC extern void execute_334(char*, char *);
IKI_DLLESPEC extern void execute_335(char*, char *);
IKI_DLLESPEC extern void execute_336(char*, char *);
IKI_DLLESPEC extern void execute_337(char*, char *);
IKI_DLLESPEC extern void execute_338(char*, char *);
IKI_DLLESPEC extern void execute_339(char*, char *);
IKI_DLLESPEC extern void execute_340(char*, char *);
IKI_DLLESPEC extern void execute_341(char*, char *);
IKI_DLLESPEC extern void execute_342(char*, char *);
IKI_DLLESPEC extern void execute_343(char*, char *);
IKI_DLLESPEC extern void execute_344(char*, char *);
IKI_DLLESPEC extern void execute_345(char*, char *);
IKI_DLLESPEC extern void execute_346(char*, char *);
IKI_DLLESPEC extern void execute_347(char*, char *);
IKI_DLLESPEC extern void execute_348(char*, char *);
IKI_DLLESPEC extern void execute_349(char*, char *);
IKI_DLLESPEC extern void execute_350(char*, char *);
IKI_DLLESPEC extern void execute_351(char*, char *);
IKI_DLLESPEC extern void execute_352(char*, char *);
IKI_DLLESPEC extern void execute_353(char*, char *);
IKI_DLLESPEC extern void execute_354(char*, char *);
IKI_DLLESPEC extern void execute_355(char*, char *);
IKI_DLLESPEC extern void execute_356(char*, char *);
IKI_DLLESPEC extern void execute_164(char*, char *);
IKI_DLLESPEC extern void execute_165(char*, char *);
IKI_DLLESPEC extern void execute_166(char*, char *);
IKI_DLLESPEC extern void execute_167(char*, char *);
IKI_DLLESPEC extern void execute_372(char*, char *);
IKI_DLLESPEC extern void execute_373(char*, char *);
IKI_DLLESPEC extern void execute_374(char*, char *);
IKI_DLLESPEC extern void execute_375(char*, char *);
IKI_DLLESPEC extern void execute_376(char*, char *);
IKI_DLLESPEC extern void execute_377(char*, char *);
IKI_DLLESPEC extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
IKI_DLLESPEC extern void transaction_47(char*, char*, unsigned, unsigned, unsigned);
IKI_DLLESPEC extern void vlog_transfunc_eventcallback_2state(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[107] = {(funcp)execute_21, (funcp)execute_23, (funcp)execute_101, (funcp)execute_122, (funcp)svlog_sampling_process_execute, (funcp)sequence_expr_m_2b54eda7_5c6ca80d_1, (funcp)sequence_expr_m_2b54eda7_5c6ca80d_2, (funcp)vlog_sv_sequence_execute_0 , (funcp)assertion_action_m_2b54eda7_5c6ca80d_1, (funcp)execute_362, (funcp)execute_363, (funcp)execute_364, (funcp)execute_365, (funcp)execute_366, (funcp)execute_367, (funcp)execute_368, (funcp)execute_369, (funcp)execute_370, (funcp)execute_371, (funcp)execute_98, (funcp)execute_99, (funcp)vlog_const_rhs_process_execute_0_fast_for_reg, (funcp)execute_296, (funcp)execute_288, (funcp)execute_289, (funcp)execute_290, (funcp)execute_291, (funcp)execute_292, (funcp)execute_293, (funcp)execute_294, (funcp)execute_180, (funcp)execute_181, (funcp)execute_182, (funcp)execute_28, (funcp)execute_168, (funcp)vlog_simple_process_execute_0_fast_for_reg, (funcp)execute_297, (funcp)execute_298, (funcp)execute_299, (funcp)execute_300, (funcp)execute_301, (funcp)execute_302, (funcp)execute_303, (funcp)execute_304, (funcp)execute_305, (funcp)execute_306, (funcp)execute_307, (funcp)execute_308, (funcp)execute_309, (funcp)execute_310, (funcp)execute_311, (funcp)execute_312, (funcp)execute_313, (funcp)execute_314, (funcp)execute_315, (funcp)execute_318, (funcp)execute_319, (funcp)execute_320, (funcp)execute_321, (funcp)execute_322, (funcp)execute_323, (funcp)execute_324, (funcp)execute_325, (funcp)execute_326, (funcp)execute_327, (funcp)execute_328, (funcp)execute_329, (funcp)execute_330, (funcp)execute_331, (funcp)execute_332, (funcp)execute_333, (funcp)execute_334, (funcp)execute_335, (funcp)execute_336, (funcp)execute_337, (funcp)execute_338, (funcp)execute_339, (funcp)execute_340, (funcp)execute_341, (funcp)execute_342, (funcp)execute_343, (funcp)execute_344, (funcp)execute_345, (funcp)execute_346, (funcp)execute_347, (funcp)execute_348, (funcp)execute_349, (funcp)execute_350, (funcp)execute_351, (funcp)execute_352, (funcp)execute_353, (funcp)execute_354, (funcp)execute_355, (funcp)execute_356, (funcp)execute_164, (funcp)execute_165, (funcp)execute_166, (funcp)execute_167, (funcp)execute_372, (funcp)execute_373, (funcp)execute_374, (funcp)execute_375, (funcp)execute_376, (funcp)execute_377, (funcp)vlog_transfunc_eventcallback, (funcp)transaction_47, (funcp)vlog_transfunc_eventcallback_2state};
const int NumRelocateId= 107;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/lab_02_tb_alu_behav/xsim.reloc",  (void **)funcTab, 107);

	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/lab_02_tb_alu_behav/xsim.reloc");
}

void simulate(char *dp)
{
iki_register_root_pointers(11, 84568, 18,0,0,82640, 14,0,0,83800, 16,0,0,82832, 15,0,0,84952, 19,0,0,84184, 17,0,0,85720, 21,0,0,85528, 20,0,0,13368, 1,2, 0, 32,13752, 2,0,0,13560, 1,2, 0, 32) ; 
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/lab_02_tb_alu_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void subprog_m_2b54eda7_5c6ca80d_29() ;
void subprog_m_2b54eda7_5c6ca80d_28() ;
void subprog_m_2b54eda7_5c6ca80d_27() ;
void subprog_m_2b54eda7_5c6ca80d_34() ;
void subprog_m_2b54eda7_5c6ca80d_33() ;
void subprog_m_2b54eda7_5c6ca80d_32() ;
void subprog_m_2b54eda7_5c6ca80d_39() ;
void subprog_m_2b54eda7_5c6ca80d_38() ;
void subprog_m_2b54eda7_5c6ca80d_37() ;
void subprog_m_2b54eda7_5c6ca80d_44() ;
void subprog_m_2b54eda7_5c6ca80d_43() ;
void subprog_m_2b54eda7_5c6ca80d_42() ;
void subprog_m_2b54eda7_5c6ca80d_49() ;
void subprog_m_2b54eda7_5c6ca80d_48() ;
void subprog_m_2b54eda7_5c6ca80d_47() ;
void subprog_m_2b54eda7_5c6ca80d_54() ;
void subprog_m_2b54eda7_5c6ca80d_53() ;
void subprog_m_2b54eda7_5c6ca80d_52() ;
void subprog_m_2b54eda7_5c6ca80d_59() ;
void subprog_m_2b54eda7_5c6ca80d_58() ;
void subprog_m_2b54eda7_5c6ca80d_57() ;
void subprog_m_2b54eda7_5c6ca80d_64() ;
void subprog_m_2b54eda7_5c6ca80d_63() ;
void subprog_m_2b54eda7_5c6ca80d_62() ;
static char* ng140[] = {(void *)subprog_m_2b54eda7_5c6ca80d_29, (void *)subprog_m_2b54eda7_5c6ca80d_28, (void *)subprog_m_2b54eda7_5c6ca80d_27};
static char* ng150[] = {(void *)subprog_m_2b54eda7_5c6ca80d_34, (void *)subprog_m_2b54eda7_5c6ca80d_33, (void *)subprog_m_2b54eda7_5c6ca80d_32};
static char* ng160[] = {(void *)subprog_m_2b54eda7_5c6ca80d_39, (void *)subprog_m_2b54eda7_5c6ca80d_38, (void *)subprog_m_2b54eda7_5c6ca80d_37};
static char* ng170[] = {(void *)subprog_m_2b54eda7_5c6ca80d_44, (void *)subprog_m_2b54eda7_5c6ca80d_43, (void *)subprog_m_2b54eda7_5c6ca80d_42};
static char* ng180[] = {(void *)subprog_m_2b54eda7_5c6ca80d_49, (void *)subprog_m_2b54eda7_5c6ca80d_48, (void *)subprog_m_2b54eda7_5c6ca80d_47};
static char* ng190[] = {(void *)subprog_m_2b54eda7_5c6ca80d_54, (void *)subprog_m_2b54eda7_5c6ca80d_53, (void *)subprog_m_2b54eda7_5c6ca80d_52};
static char* ng200[] = {(void *)subprog_m_2b54eda7_5c6ca80d_59, (void *)subprog_m_2b54eda7_5c6ca80d_58, (void *)subprog_m_2b54eda7_5c6ca80d_57};
static char* ng210[] = {(void *)subprog_m_2b54eda7_5c6ca80d_64, (void *)subprog_m_2b54eda7_5c6ca80d_63, (void *)subprog_m_2b54eda7_5c6ca80d_62};
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_xsimdir_location_if_remapped(argc, argv)  ;
    iki_set_sv_type_file_path_name("xsim.dir/lab_02_tb_alu_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/lab_02_tb_alu_behav/xsim.crvsdump");
    iki_svlog_initialize_virtual_tables(8, 14, ng140, 15, ng150, 16, ng160, 17, ng170, 18, ng180, 19, ng190, 20, ng200, 21, ng210);
    void* design_handle = iki_create_design("xsim.dir/lab_02_tb_alu_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, (void*)0, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
