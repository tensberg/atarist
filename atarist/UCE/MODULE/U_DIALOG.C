/* Modul zur DurchfÅhrung der nichtmodalen Dialoge */

#define UCE_DIALOG  1

#include <stdio.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

/* globale Variablen */
  static char *tabadr; /* Adresse des Tabulatorstrings */
  static char *zumadr; /* Adresse des Zeilenumbruchstrings */
  static char *zumadr2;
  static WORD dummy; /* Leervariable */
  /* Dialoghandles */
  static WORD h_uce_info = 0;
  static WORD h_ftasten = 0;
  static WORD h_einstell = 0;
  static WORD h_editmodi = 0;
         WORD h_woerter = 0;
         WORD h_dateien = 0;

/* Funktionsprototypen */
         void d_end(); /* Dialog beenden */
         void top(); /* Fenster toppen und aktivieren */

static void b_uce_info( button)
register WORD button;
{
   if (button == 0) /* das Dialogfenster wurde geschlossen */
     d_end( &h_uce_info, ei_growshrink);
}

static void b_ftasten( button)
register WORD button;
{
   if (button == 0) /* das Dialogfenster wurde geschlossen */
     d_end( &h_ftasten, ei_growshrink);
}

static void b_einstell( button)
register WORD button;
{
   register WORD i; /* ZÑhlvariable */

   switch (button)
   {
      case 0 : /* Dialog schlieûen */
        d_end( &h_einstell, ei_growshrink);
        break;

      case EI_HILFE :
        wo_help( "EINSTELLUNGEN");
        sel_object( nw_searchwin( h_einstell), w_einstell, button, 0);
        break;

      case EI_GROWSHRINK :
        ei_growshrink = selected( w_einstell, EI_GROWSHRINK);
        break;

      case EI_BYTEGRENZE :
        ei_bytegrenze = selected( w_einstell, EI_BYTEGRENZE);
        for ( i=0; i<anz_texte; i++)
          textfeld[i].w.stepx = (ei_bytegrenze) ? 8 : 1;
        break;

      case EI_MAUSPOSITION :
        ei_mausposition = selected( w_einstell, EI_MAUSPOSITION);
        break;

      case EI_CURSOR_BLINKT :
        ei_cursor_blinkt = selected( w_einstell, EI_CURSOR_BLINKT);
        break;

      case EI_WARNTON :
        ei_warnton = selected( w_einstell, EI_WARNTON);
        break;

      case EI_INF :
        ei_inf = selected( w_einstell, EI_INF);
        break;

      case EI_BAK :
        ei_bak = selected( w_einstell, EI_BAK);
        break;
   }
}

static void b_editmodi( button)
register WORD button;
{
   WORD ex_ob;
   WORD n_zu; /* neuer Zeilenumbruch */

   switch (button)
   {
      case 0 : /* Dialog beendet */
        d_end( &h_editmodi, ei_growshrink);
        break;

      case ED_EINFUEGEN : case ED_UEBERSCHREIBE : /* Radio-Button */
        ed_einfuegen = selected( w_editmodi, ED_EINFUEGEN);
        break;

      case ED_Z_EINFUEGEN : /* Zeile einfÅgen */
        ed_z_einfuegen = selected( w_editmodi, ED_Z_EINFUEGEN);
        break;

      case ED_ZEILENREST :
        ed_zeilenrest = selected( w_editmodi, ED_ZEILENREST);
        break;

      case ED_EINRUECKEN :
        ed_einruecken = selected( w_editmodi, ED_EINRUECKEN);
        break;

      case ED_ZEILENUMBRUCH :
        ed_zeilenumbruch = selected( w_editmodi, ED_ZEILENUMBRUCH);
        break;

      case ED_UMBRUCHBREITE :
        sel_object( nw_searchwin( h_editmodi), w_editmodi, button, 0);
        /* Dialog zur Tabulatoreinstellung */
        ex_ob = nmf_do( d_zeilenumbruch, ZE_TEXT, 1, FALSE, ei_growshrink);
        objc_change( d_zeilenumbruch, ex_ob, 0, 0, 0, 0, 0,
                     d_zeilenumbruch[ex_ob].ob_state & ~SELECTED, 0);
        n_zu = atoi( zumadr); /* neuer Zeilenumbruch */
        if (n_zu < 2 || n_zu > ZEILENBREITE) /* zu kleine/groûe Breite */
        {
           pling();
           strcpy( zumadr, zumadr2);
        }
        else
        {
           ed_umbruchbreite = atoi( zumadr);
           strcpy( zumadr2, zumadr);
        }
        break;

      case ED_TABWEITE :
        objc_change( w_editmodi, ED_TABWEITE, 0, 0, 0, 0, 0,
                     w_editmodi[ED_TABWEITE].ob_state & ~SELECTED, 0);
        /* Dialog zur Tabulatoreinstellung */
        ex_ob = nmf_do( d_tabweite, TA_TEXT, 1, FALSE, ei_growshrink);
        objc_change( d_tabweite, ex_ob, 0, 0, 0, 0, 0,
                     d_tabweite[ex_ob].ob_state & ~SELECTED, 0);
        ed_tabweite = atoi( tabadr);
        break;
   } /* switch */
}
/* --------- nach auûen sichtbare Prozeduren --------- */
void in_dial()
{
   tabadr  = ((TEDINFO *) d_tabweite[TA_TEXT].ob_spec)->te_ptext;
   zumadr  = ((TEDINFO *) d_zeilenumbruch[ZE_TEXT].ob_spec)->te_ptext;
   zumadr2 = ((TEDINFO *) w_editmodi[ED_UMBRUCHBREITE].ob_spec)->te_ptext;

   /* Tabweite-Strings zeigen auf einen String */
   ((TEDINFO *) w_editmodi[ED_TABWEITE].ob_spec)->te_ptext = tabadr;
}

void m_uce_info()
{
   if (h_uce_info == 0) /* Dialogfenster îffnen */
     h_uce_info = nf_do( w_info, 0, ei_mausposition, FALSE, f_name, b_uce_info,
                         &evnt, ei_growshrink);
   else /* Dialogfenster toppen */
     top( h_uce_info);
}

void m_woerter()
{
   if (h_woerter == 0) /* Dialogfenster îffnen */
     h_woerter = nf_do( w_woerter, WO_SUCHE_TEXT, ei_mausposition, TRUE,
                        f_name, b_woerter, &evnt, ei_growshrink);
   else /* Dialogfenster toppen */
     top( h_woerter);
}

void m_ftasten()
{
   if (h_ftasten == 0) /* Dialogfenster îffnen */
     h_ftasten = nf_do( w_ftasten, FT_F1, ei_mausposition, FALSE, f_name,
                        b_ftasten, &evnt, ei_growshrink);
   else /* Dialogfenster toppen */
     top( h_ftasten);
}

void m_einstell()
{
   if (h_einstell == 0) /* Dialogfenster îffnen */
     h_einstell = nf_do( w_einstell, 0, ei_mausposition, FALSE, f_name,
                         b_einstell, &evnt, ei_growshrink);
   else /* Dialogfenster toppen */
     top( h_einstell);
}

void m_editmodi()
{
   if (h_editmodi == 0) /* Dialogfenster îffnen */
     h_editmodi = nf_do( w_editmodi, 0, ei_mausposition, FALSE, f_name,
                         b_editmodi, &evnt, ei_growshrink);
   else /* Dialogfenster toppen */
     top( h_editmodi);
}

void cl_dialog()
{
   if (h_uce_info != 0) d_end( &h_uce_info, ei_growshrink);
   if (h_woerter != 0) d_end( &h_woerter, ei_growshrink);
   if (h_ftasten != 0) d_end( &h_ftasten, ei_growshrink);
   if (h_einstell != 0) d_end( &h_einstell, ei_growshrink);
   if (h_editmodi != 0) d_end( &h_editmodi, ei_growshrink);
   if (h_dateien != 0) d_end( &h_dateien, ei_growshrink);
}

void top( handle) /* Dialogfenster toppen */
WORD handle;
{
   wind_set( handle, WF_TOP, &dummy, &dummy, &dummy);
}

void d_end( d_handle)
WORD *d_handle;
{
   WORD w_handle, dummy;

   nf_end( *d_handle, ei_growshrink);
   *d_handle = 0;

   /* neues Fenster aktivieren */
   wind_get( 0, WF_TOP, &w_handle, &dummy, &dummy, &dummy);
   a_qt = t_find_qt( w_handle);
   if (a_qt != NULL)
   {
      a_qt->cursor_an = TRUE;
      cur_x = a_qt->cursor_spalte*pwchar;
      cur_y = a_qt->cursor_zeile*phchar;
      info_changed = FALSE;
   }
}