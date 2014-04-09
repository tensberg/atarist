/* das Hauptmodul des Programms WOERTER.ACC */

#include <stdio.h>
#include <malloc.h>
#include <gemfast.h>
#include <window.h>
#include <w_header.h>

/* externe Funktionen */
  extern void do_message();
  extern void do_keybd();

/* globale Variablen */
  OBJECT *m_menue;
  OBJECT *w_info;
  OBJECT *w_woerterbuch;
  OBJECT *w_neues_wort;
  OBJECT *w_trainer;
  char  **s_info;
  char  **s_woerterbuch;
  char  **s_neues_wort;
  char  **s_trainer;
  char  **s_nicht_gefunden;

  E_MULTI e_multi;
  WORD wk_handle;

  WORD anz_entries = 0;
  WORD max_entries = 0;
  ENTRY *entry = NULL;
  WORD anz_d_e = 0;
  WORD max_d_e = 0;
  WORD *liste_d_e = NULL;
  WORD anz_e_d = 0;
  WORD max_e_d = 0;
  WORD *liste_e_d = NULL;
  WORD durchschnitt = 0;
  WORD geaendert = FALSE;
  WORD phchar;

WORD main()
{
   WORD ap_id; /* Prozesshandle */
   WORD mbuf[8], pmx, pmy, pmb, pks, pkr, pbr;
   register WORD i;
   WORD dummy;
   register WORD vwk_in[11], vwk_out[57];

   _BLKSIZ = 2000L;

   ap_id = appl_init();

   /* virtuelle Workstation ”ffnen */
   wk_handle = graf_handle( &dummy, &phchar, &dummy, &dummy);
   for ( i=0; i<10; i++)
     vwk_in[i] = 1;
   vwk_in[10] = 2; /* RC-Koordinatensystem */
   v_opnvwk( vwk_in, &wk_handle, vwk_out);

   rsrc_load( "WOERTER.RSC");

   /* Initialisierung der Objektmodule */
   userdef( 5);
   in_rsrcaddr();
   in_woerterbuch();
   in_neues_wort();
   ld_woerter(); /* W”rterbuch laden */
   in_trainer();

   /* E_MULTI-Struktur initialisieren */
   e_multi.flags = MU_MESAG|MU_KEYBD;
   e_multi.mepbuff = mbuf;
   e_multi.pmx = &pmx;
   e_multi.pmy = &pmy;
   e_multi.pmb = &pmb;
   e_multi.pks = &pks;
   e_multi.pkr = &pkr;
   e_multi.pbr = &pbr;
   ne_newfunc( do_message, MU_MESAG, 0);
   ne_newfunc( do_keybd, MU_KEYBD, 0);

   graf_mouse( ARROW);
   menu_bar( m_menue, TRUE); /* Menuezeile darstellen */

   /* der Hauptteil */
   ne_multi( &e_multi);

   /* Programmende */
   if (geaendert) sp_woerter(); /* W”rterbuch speichern */
   menu_bar( m_menue, FALSE);
   cl_dialog();
   v_clsvwk( wk_handle);
   end_userdef();
   appl_exit();

   return 0;
}