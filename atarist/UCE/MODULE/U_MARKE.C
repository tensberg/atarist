/* Marke setzen/l”schen */

#define UCE_MARKE  1

#include <stdio.h>
#include <macros.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

void m_ma_setzen()
{
   register WORD gewaehlt;
   register WORD i;

   for ( i=0; i<5; i++)
     if (a_qt->marke[i] != -1) *p_msetzen[MS_M1+i].ob_spec = '';

   gewaehlt = popup( p_msetzen, 0, MS_BACK, ei_growshrink);

   for ( i=0; i<5; i++)
     *p_msetzen[MS_M1+i].ob_spec = ' ';

   if (gewaehlt == 0) return;

   a_qt->marke[gewaehlt-MS_M1] = a_qt->cursor_zeile;
}

void m_zu_marke()
{
   register WINDOW *qw;
   register WORD gewaehlt;
   register WORD marke_pos;
   register WORD i;

   for ( i=0; i<5; i++)
     if (a_qt->marke[i] == -1) p_zumarke[ZU_M1+i].ob_state = DISABLED;

   gewaehlt = popup( p_zumarke, 0, ZU_BACK, ei_growshrink);

   for ( i=0; i<5; i++)
     p_zumarke[ZU_M1+i].ob_state = 0;

   if (gewaehlt == 0) return;

   gewaehlt -= ZU_M1;
   marke_pos = min( a_qt->marke[gewaehlt], a_qt->zeilenzahl-1);

   a_qt->o_zeile -= a_qt->cursor_zeile; /* Abstand Cursor/oberste Zeile */
   a_qt->cursor_zeile = marke_pos;
   a_qt->o_zeile += marke_pos;

   if (a_qt->o_zeile+a_qt->a_zeilen >= a_qt->zeilenzahl)
     a_qt->o_zeile = a_qt->zeilenzahl-a_qt->a_zeilen;
   if (a_qt->o_zeile < 0) a_qt->o_zeile = 0;

   qw = &a_qt->w;
   if (a_qt->cursor_an)
   {
      a_qt->cursor_an = FALSE;
      cursor( qw);
   }
   nw_npos( qw, W_INTERIOR, (LONG) a_qt->l_spalte*pwchar,
            a_qt->o_zeile*phchar);
   new_cursor( a_qt, ZEILE, TRUE);
}