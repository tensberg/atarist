/* Suchen */

#define UCE_SUCHEN1  1

#include <stdio.h>
#include <macros.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

#define GROSS_KLEIN  1
#define KOMMENTAR    2

/* globale Variablen */
static char *suchtext;

/* externe Funktionen */
extern char *obst_save();

void in_suchen()
{
   suchtext = ((TEDINFO *) d_suchen[SU_SUCHTEXT].ob_spec)->te_ptext;
}

void m_suchen()
{
   register char *dial_sp;
   register WORD button;
   register LONG e_zeile, l_zeile;
   register WORD e_spalte, l_spalte; /* erste/letzte Spalte */
   register WORD modus;
   LONG zeile;
   WORD spalte;

   /* Objekte speichern */
   dial_sp = obst_save( d_suchen, SELECTED, TRUE);

   /* Suchdialog durchfhren */
   nmf_init( d_suchen, SU_SUCHTEXT, ei_mausposition, FALSE, ei_growshrink);
   do
     button = nmf_button();
   while (button!=SU_OK && button!=SU_ABBRUCH && button!=SU_HILFE);
   nmf_end();

   /* Button auswerten */
   if (button == SU_OK)
   {
      free( dial_sp);
      d_suchen[SU_OK].ob_state = 0;
   }
   else
   {
      obst_restore( dial_sp, TRUE);
      if (button == SU_HILFE) wo_help( "SUCHE");
      return;
   }

   /* Suchrichtung ermitteln */
   if (d_suchen[SU_DOWN].ob_state & SELECTED)
   {
      e_zeile = a_qt->cursor_zeile;
      l_zeile = a_qt->zeilenzahl-1;
      l_spalte = a_qt->cursor_spalte;
      e_spalte = toword( a_qt->zeile[l_zeile][-4]);
   }
   else if (d_suchen[SU_UP].ob_state & SELECTED)
        {
           e_zeile = a_qt->cursor_zeile;
           l_zeile = 0;
           l_spalte = 0;
           e_spalte = toword( a_qt->zeile[0][-4]);
        }
   else if (d_suchen[SU_TEXTANFANG].ob_state & SELECTED)
        {
           e_zeile = 0;
           l_zeile = a_qt->zeilenzahl-1;
           l_spalte = 0;
           e_spalte = toword( a_qt->zeile[l_zeile][-4]);
        }
   else if (d_suchen[SU_BLOCK].ob_state & SELECTED)
        {
           e_zeile = a_qt->bstart_zeile;
           l_zeile = a_qt->bende_zeile;
           l_spalte = a_qt->bstart_spalte;
           e_spalte = a_qt->bende_spalte;
        }

   if (d_suchen[SU_GROSSKLEIN].ob_state & SELECTED) modus = GROSS_KLEIN;

   /* Text suchen */
   suche_text( a_qt, suchtext, e_zeile, l_zeile, e_spalte, l_spalte,
               &zeile, &spalte, modus);

   /* Ergebnis auswerten */
   if (zeile == -1) /* Text nicht gefunden */
     zeile = zeile;
     /*form_alert( 1, a_nicht_gefunden);*/
   else /* Cursor zum gefundenen Wort */
   {
      /* neue Cursor- und Textausschnittsposition berechnen */
      a_qt->o_zeile -= a_qt->cursor_zeile;
      a_qt->l_spalte = 0;
      a_qt->cursor_zeile = zeile;
      a_qt->cursor_spalte = spalte;
      a_qt->o_zeile += a_qt->cursor_zeile;

      if (a_qt->o_zeile+a_qt->a_zeilen >= a_qt->zeilenzahl)
        a_qt->o_zeile = max( 0, a_qt->zeilenzahl-a_qt->a_zeilen);

      if (a_qt->a_spalten <= spalte)
        a_qt->l_spalte = spalte-a_qt->a_spalten+5;

      /* neu zeichnen */
      if (a_qt->cursor_an)
      {
         a_qt->cursor_an = FALSE;
         cursor( &a_qt->w);
      }

      nw_npos( &a_qt->w, W_INTERIOR, (LONG) a_qt->l_spalte*pwchar,
               a_qt->o_zeile*phchar);
      new_cursor( a_qt, ZEILE|SPALTE, TRUE);
   }
}