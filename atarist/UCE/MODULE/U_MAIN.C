/* UCE_MAIN ist das Hauptrogramm des UCE-Projekts */

#define UCE_MAIN  1

#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

/* globale Variablen */
  WORD ap_id;     /* ID des eigenen Programms */
  WORD wk_handle; /* Handle der virtuellen VDI-Workstation */
  WORD pwchar, phchar, pwbox, phbox;
  GRECT work;
  E_MULTI evnt;
  WORD vwk_out[57]; /* RÅckgabeparameter von v_opnvwk */
  WORD pmx, pmy, pmb; /* MauszustÑnde fÅr evnt_multi */
  WORD pks, pkr, pbr; /* Tastaturzustand */
  char *f_name = " UCE ";
  WORD cur_width = 2; /* Cursorbreite */
  LONG cur_freq = 500; /* Cursorblinkfrequenz in ms */
  char pfad[255]; /* Standartpfad */
  char *spfad;    /* Anfangspfad */
  char name[255]; /* Standartname */
  WORD gemklemmbrett;
  WORD info_changed; /* Flag, ob Infozeile geÑndert wurde */

  /* Variablen, die in w_einstell und w_editmodi verÑndert werden kînnen */
  WORD ed_einfuegen;
  WORD ed_z_einfuegen;
  WORD ed_zeilenrest;
  WORD ed_einruecken;
  WORD ed_zeilenumbruch;
  WORD ed_umbruchbreite;
  WORD ed_tabweite;
  WORD ei_bytegrenze;
  WORD ei_growshrink;
  WORD ei_mausposition;
  WORD ei_cursor_blinkt;
  WORD ei_warnton;
  WORD ei_inf;
  WORD ei_bak;

  /* Objektbaumadressen */
  OBJECT *hauptmenue;
  OBJECT *w_info;
  OBJECT *w_ftasten;
  OBJECT *w_editmodi;
  OBJECT *w_einstell;
  OBJECT *w_woerter;
  OBJECT *w_dateien;
  OBJECT *d_suchen;
  OBJECT *d_ersetzen;
  OBJECT *d_zu_zeile;
  OBJECT *d_b_schieb;
  OBJECT *d_drucken;
  OBJECT *d_tabweite;
  OBJECT *d_zeilenumbruch;
  OBJECT *d_da_vorhanden;
  OBJECT *p_fenster;
  OBJECT *p_msetzen;
  OBJECT *p_zumarke;
  OBJECT *i_dauer;
  char  **a_init;
  char  **a_no_memory;
  char  **a_no_window;
  char  **s_infozeile;
  char  **s_d_oeffnen;
  char  **s_d_si_unter;
  char  **s_t_laden;
  char  **s_t_sichern;
  char  **s_t_loeschen;
  char  **s_n_gefunden;
  char  **s_wo_laden;
  char  **s_erlaubt;

WORD main( argc, argv, envp)
int argc;
char *argv[];
char *envp;
{
   WORD dummy; /* Leervariable */
   WORD i; /* ZÑhlervariable */
   WORD vwk_in[11]; /* Eingabeparameter von v_opnvwk */
   static WORD mbuf[8]; /* Nachrichtenpuffer */

   _BLKSIZ = 32000L; /* Grîûe eines Speicherblocks, der von malloc() vom
                        Betriebssystem angefordert wird */

   ap_id = appl_init(); /* Applikation anmelden */

   /* virtuelle Workstation îffnen */
   wk_handle = graf_handle( &pwchar, &phchar, &pwbox, &phbox);
   for ( i=0; i<10; i++)
     vwk_in[i] = 1;
   vwk_in[10] = 2; /* RC-Koordinatensystem */
   v_opnvwk( vwk_in, &wk_handle, vwk_out);
   vst_alignment( wk_handle, TA_LEFT, TA_TOP, &dummy, &dummy);
   vst_color( wk_handle, 1);

   getcwd( pfad, 255); /* aktuelles Arbeitsverzeichnis */
   spfad = strdup( pfad); /* Ursprungspfad speichern */
   strcpy( name, ""); /* leerer Name */

   wind_get( 0, WF_WORKXYWH, &work.g_x, &work.g_y, &work.g_w, &work.g_h);
   rsrc_load( "UCE.RSC");
   userdef( 19);
   in_objc_addr(); /* Objektbaumadressen */

   /* Objektmodule initialisieren */
   in_dial(); /* Dialogmodul initialisieren */
   in_dateifenster(); /* Dateifenster-Modul initialisieren */
   in_dauer();
   in_woerter();

   ld_einstell(); /* Standarteinstellungen laden */

   graf_mouse( ARROW); /* Mausform */

   /* E_MULTI-Strukturen besetzen */
   evnt.flags   = MU_MESAG|MU_KEYBD;
   evnt.mepbuff = mbuf;
   evnt.pmx = &pmx;
   evnt.pmy = &pmy;
   evnt.pmb = &pmb;
   evnt.pks = &pks;
   evnt.pkr = &pkr;
   evnt.pbr = &pbr;
   ne_newfunc( do_evnt, MU_MESAG, 0);
   ne_newfunc( me_kclick, MU_KEYBD, 0);

   menu_bar( hauptmenue, 1); /* Menuezeile ein */

   ne_multi( &evnt); /* von jetzt an liegt die Programmkontrolle
                        bis zum Programmende bei ne_multi */

   /* Programmende */
   cl_dialog(); /* nichtmodale Dialoge schlieûen */
   free_all(); /* allen von nalloc allozierten Speicher freigeben */
   menu_bar( hauptmenue, 0); /* Menue aus */
   v_clsvwk( wk_handle);
   end_userdef();
   appl_exit();

   return 0; /* das Programm ist beendet */
}