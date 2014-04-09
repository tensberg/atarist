/* verschiedene Prozeduren und Funktionen */

#define UCE_RAMSCH1  1

#include <stdio.h>
#include <macros.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

/* -------- nach aužen sichtbare Prozeduren ---------- */
void sel_object( w, tree, obnr, flag) /* Objekt selektieren */
register WINDOW *w; /* Fenster, in dem das Objekt ist */
register OBJECT *tree; /* Objektbaum */
register WORD obnr; /* Objektnummer */
WORD flag; /* 0 : deselektieren, 1 : selektieren */
{
   WORD px, py; /* Redraw-Position */
   register OBJECT *obj;

   obj = &tree[obnr];
   if (flag)
     obj->ob_state |= SELECTED;
   else
     obj->ob_state &= ~SELECTED;

   if (w != NULL) /* Objekt neu zeichnen */
   {
      objc_offset( tree, obnr, &px, &py);
      nw_redraw( w, 0, (LONG) px, (LONG) py, (LONG) obj->ob_width,
                (LONG) obj->ob_height);
   }
}

WORD selected( tree, obnr) /* prft, ob Objekt selektiert ist */
OBJECT *tree;
WORD obnr;
{
   return (tree[obnr].ob_state & SELECTED);
}

void get_nsize( qt, qw, is_top) /* neue Fenstergr”že berechnen */
register QUELLTEXT *qt;
register WINDOW *qw;
register WORD is_top;
{
   qt->o_zeile = qw->ry/phchar;
   qt->l_spalte = qw->rx/pwchar;
   qt->a_zeilen = qw->ih/phchar;
   qt->a_spalten = qw->iw/pwchar;
   /* neue Cursorposition setzen */
   if (qt->o_zeile+qt->a_zeilen <= qt->cursor_zeile)
     qt->cursor_zeile = qt->o_zeile+qt->a_zeilen-1;
   if (qt->l_spalte+qt->a_spalten <= qt->cursor_spalte)
     qt->cursor_spalte = qt->l_spalte+qt->a_zeilen-1;
   if (is_top)
   {
      if (qt->cursor_an)
        cursor( qw);
      cur_x = qt->cursor_spalte*pwchar;
      cur_y = qt->cursor_zeile*phchar;
      cursor( qw);
      qt->cursor_an = TRUE;
   }
}