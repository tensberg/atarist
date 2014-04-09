/* Prozeduren zur Quelltextfensterverarbeitung */

#define UCE_QT_FENSTER1  1

#include <stdio.h>
#include <macros.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

void qt_do_revnt( qw, mbuf)
register WINDOW *qw;
register WORD mbuf[];
{
   register QUELLTEXT *qt;
   register WORD w_handle;
   WORD top; /* Handle des obersten Fensters */
   register WORD is_top;
   WORD dummy;

   w_handle = mbuf[3];

   qt = t_find_qt( w_handle); /* Quelltext, den die Nachricht betrifft */
   is_top = (qt == a_qt);

   switch (mbuf[0]) /* Nachrichtennummer */
   {
      case WM_TOPPED :
        wind_set( w_handle, WF_TOP, 0, 0, 0, 0);
        a_qt = qt;
        cur_x = qt->cursor_spalte*pwchar;
        cur_y = qt->cursor_zeile*phchar;
        info_changed = FALSE;
        break;

      case WM_CLOSED :
        t_close_text( qt->q_nummer); /* Quelltextfenster schlieáen */
        wind_get( 0, WF_TOP, &top, &dummy, &dummy, &dummy);
        a_qt = t_find_qt( top);
        if (a_qt != NULL)
        {
           qt->cursor_an = TRUE;
           cur_x = a_qt->cursor_spalte*pwchar;
           cur_y = a_qt->cursor_zeile*phchar;
        }
        info_changed = FALSE;
        break;

      case WM_SIZED : case WM_FULLED :
        get_nsize( qt, qw, is_top);
        break;

      case WM_ARROWED :
        /* Cursorposition neu berechnen */
        switch (mbuf[4])
        {
           case WA_UPPAGE : case WA_DNPAGE :
             qt->cursor_zeile -= qt->o_zeile; /* Abstand Cursor/oberste
                                                 Zeile */
             qt->o_zeile = qw->ry/phchar;
             qt->cursor_zeile += qt->o_zeile;
             new_cursor( qt, ZEILE, is_top);
             break;

           case WA_LFPAGE : case WA_RTPAGE :
             qt->cursor_spalte -= qt->l_spalte; /* Abstand Cursor/linke
                                                   Spalte */
             qt->l_spalte = qw->rx/pwchar;
             qt->cursor_spalte += qt->l_spalte;
             new_cursor( qt, SPALTE, is_top);
             break;

          case WA_DNLINE :
            if (++qt->o_zeile > qt->cursor_zeile)
            {
               qt->cursor_zeile = qt->o_zeile;
               new_cursor( qt, ZEILE, is_top);
            }
            break;

          case WA_UPLINE :
            if (--qt->o_zeile+qt->a_zeilen <= qt->cursor_zeile)
            {
               qt->cursor_zeile = qt->o_zeile+qt->a_zeilen-1;
               new_cursor( qt, ZEILE, is_top);
            }
            break;

          case WA_RTLINE :
            qt->l_spalte = qw->rx/pwchar;
            if (qt->l_spalte > qt->cursor_spalte);
            {
               qt->cursor_spalte = qt->l_spalte;
               new_cursor( qt, SPALTE, is_top);
            }
            break;

          case WA_LFLINE :
            qt->l_spalte = qw->rx/pwchar;
            if (qt->l_spalte+qt->a_spalten <= qt->cursor_spalte)
            {
               qt->cursor_spalte = qt->l_spalte+qt->a_spalten-1;
               new_cursor( qt, SPALTE, is_top);
            }
            break;
        } /* switch */
        break;

      case WM_VSLID :
        qt->o_zeile = qw->ry/phchar;
        if (qt->cursor_zeile < qt->o_zeile)
          qt->cursor_zeile = qt->o_zeile;
        if (qt->cursor_zeile >= qt->o_zeile+qt->a_zeilen)
          qt->cursor_zeile = qt->o_zeile+qt->a_zeilen-1;
        new_cursor( qt, ZEILE, is_top);
        break;

      case WM_HSLID :
        qt->l_spalte = qw->rx/pwchar;
        if (qt->cursor_spalte < qt->l_spalte)
          qt->cursor_spalte = qt->l_spalte;
        if (qt->cursor_spalte >= qt->l_spalte+qt->a_spalten)
          qt->cursor_spalte = qt->l_spalte+qt->a_spalten-1;
        new_cursor( qt, SPALTE, is_top);
        break;
   } /* switch */
}

WORD qt_button( e_multi)
E_MULTI *e_multi;
{
   return 0;
}

WORD qt_timer( e_multi)
register E_MULTI *e_multi;
{
   register WINDOW *qw;

   if (info_changed)
   {
      info_changed = FALSE;
      upd_status( a_qt);
   }

   if (!ei_cursor_blinkt && a_qt->cursor_an)
     return 0; /* Cursor soll nicht blinken */

   qw = &a_qt->w;
   a_qt->cursor_an = !a_qt->cursor_an;
   cursor( qw);

   return 0;
}