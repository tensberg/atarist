/* AusfÅhrung des Zu Zeile-Menuepunktes */

#define UCE_ZU_ZEILE  1

#include <stdio.h>
#include <macros.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

void m_zu_zeile()
{
   register char *z_nummer; /* Zeiger auf Zeilennummernstring */
   register LONG zeile;
   register WORD button;

   z_nummer = ((TEDINFO *) d_zu_zeile[ZU_Z_NUMMER].ob_spec)->te_ptext;
   *z_nummer = '\0';

   /* Dialog ausfÅhren */
   button = nmf_do( d_zu_zeile, ZU_Z_NUMMER, ei_mausposition, FALSE,
                    ei_growshrink);

   d_zu_zeile[button].ob_state ^= SELECTED;
   if (button == ZU_ABBRUCH) return;
   zeile = atol( z_nummer)-1;
   if (zeile<0 || zeile>=a_qt->zeilenzahl) /* ungÅltiger Wert */
   {
      pling();
      return;
   }

   redraw();
   if (a_qt->cursor_an == TRUE)
   {
      cursor( &a_qt->w);
      a_qt->cursor_an = FALSE;
   }

   a_qt->cursor_zeile -= a_qt->o_zeile;
   a_qt->o_zeile = zeile-a_qt->cursor_zeile;
   a_qt->cursor_zeile += a_qt->o_zeile;

   if (a_qt->o_zeile+a_qt->a_zeilen > a_qt->zeilenzahl)
     a_qt->o_zeile = max( 0, a_qt->zeilenzahl-a_qt->a_zeilen);

   nw_npos( &a_qt->w, W_INTERIOR, (LONG) a_qt->l_spalte*pwchar,
            a_qt->o_zeile*phchar);

   new_cursor( a_qt, ZEILE, TRUE);
}