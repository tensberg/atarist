/* Routinen fÅr den Quelltextcursor */

#define UCE_CURSOR  1

#include <stdio.h>
#include <macros.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

/* Globale Variablen */
LONG cur_x, cur_y; /* Cursorposition */

void cursor( qw) /* Cursor zeichnen */
register WINDOW *qw;
{
   register WORD intersect;
   register WORD xyarray[4];
   GRECT cursor, interior;

   interior.g_x = qw->ix;
   interior.g_y = qw->iy;
   interior.g_w = qw->iw;
   interior.g_h = qw->ih;
   cursor.g_x = qw->ix+cur_x-qw->rx;
   cursor.g_y = qw->iy+cur_y-qw->ry;
   cursor.g_w = cur_width;
   cursor.g_h = phchar;
   intersect = rc_intersect( &interior, &cursor); /* SchnittflÑche Cursor/
                                                     Textfenster */
   if (!intersect) return;
   intersect = rc_intersect( &work, &cursor); /* SchnittflÑche Cursor/Bild-
                                                 schirmfenster */
   if (!intersect) return; /* keine SchnittflÑche */

   clip_on( wk_handle, cursor.g_x, cursor.g_y, cursor.g_w, cursor.g_h);
   xyarray[0] = cursor.g_x;
   xyarray[1] = cursor.g_y;
   xyarray[2] = cursor.g_x+cursor.g_w-1;
   xyarray[3] = cursor.g_y+cursor.g_h-1;
   wind_update( BEG_UPDATE);
   graf_mouse( M_OFF);
   vswr_mode( wk_handle, MD_XOR); /* Zeichenmodus Invertieren */
   vr_recfl( wk_handle, xyarray);
   vswr_mode( wk_handle, MD_REPLACE);
   graf_mouse( M_ON);
   wind_update( END_UPDATE);
   clip_off( wk_handle);
}

void new_cursor( qt, flag, is_top)
register QUELLTEXT *qt;
register WORD flag;
register WORD is_top;
{
   if (is_top)
   {
      if (qt->cursor_an) cursor( &qt->w);

      if (flag & ZEILE)  cur_y = qt->cursor_zeile*phchar;
      if (flag & SPALTE) cur_x = qt->cursor_spalte*pwchar;

      qt->cursor_an = TRUE;
      cursor( &qt->w);
      info_changed = TRUE;
   }
}

void mov_cursor( qt, dir) /* Cursor bewegen */
register QUELLTEXT *qt;
register WORD dir;
{
   switch (dir)
   {
      case UP :
        if (qt->cursor_zeile == 0) return;
        if (--qt->cursor_zeile < qt->o_zeile)
          qt->o_zeile--;
        break;

      case DOWN :
        if (qt->cursor_zeile == qt->zeilenzahl-1) return;
        if (++qt->cursor_zeile == qt->o_zeile+qt->a_zeilen)
          qt->o_zeile++;
        break;

      case LEFT :
        if (qt->cursor_spalte == 0)
        {
           if (qt->cursor_zeile == 0) return;
           if (--qt->cursor_zeile < qt->o_zeile) qt->o_zeile--;
           qt->cursor_spalte = min( ZEILENBREITE-1, toword(
                                    qt->zeile[qt->cursor_zeile][-4]));
           if (qt->cursor_spalte >= qt->l_spalte+qt->a_spalten)
             qt->l_spalte = min( ZEILENBREITE-qt->a_spalten,
                                 qt->cursor_spalte+5-qt->a_spalten);
           qt->cursor_spalte++;
        }
        if (--qt->cursor_spalte < qt->l_spalte)
        {
           qt->l_spalte -= 5;
           if (qt->l_spalte < 0) qt->l_spalte = 0;
        }
        break;

      case RIGHT :
        if (qt->cursor_spalte == ZEILENBREITE-1)
        {
           if (qt->cursor_zeile == qt->zeilenzahl-1) return;
           if (++qt->cursor_zeile == qt->o_zeile+qt->a_zeilen)
             qt->o_zeile++;
           qt->cursor_spalte = -1;
           qt->l_spalte = 0;
        }
        if (++qt->cursor_spalte == qt->l_spalte+qt->a_spalten)
        {
           qt->l_spalte += 5;
           if (qt->l_spalte+qt->a_spalten >= ZEILENBREITE-1)
             qt->l_spalte = ZEILENBREITE-qt->a_spalten-1;
        }
        break;
   }

   if (qt->cursor_an == TRUE) /* alten Cursor lîschen */
   {
      cursor( &qt->w);
      qt->cursor_an = FALSE;
   }
   nw_npos( &qt->w, W_INTERIOR, (LONG) qt->l_spalte*pwchar,
            qt->o_zeile*phchar);
   new_cursor( qt, ZEILE|SPALTE, TRUE);
}