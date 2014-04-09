/* Unterroutinen zum Tastendruck auswerten */

#define UCE_KEYBOARD3  1

#include <stdio.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

void k_return( qt, qw)
register QUELLTEXT *qt;
register WINDOW *qw;
{
   register char *zeile1, *zeile2;
   register WORD spalte = 0, len = 0, dif;
   register WORD i;

   if (qt->cursor_an)
   {
      qt->cursor_an = FALSE;
      cursor( qw);
   }

   if (ed_z_einfuegen)
   {
      zeile1 = qt->zeile[qt->cursor_zeile++];
      dif = toword( zeile1[-4])-qt->cursor_spalte;
      if (ed_einruecken)
      {
         while (zeile1[spalte] == ' ')
           spalte++;
         if (zeile1[spalte] == '\0') spalte = 0;
         if (ed_zeilenrest && spalte>qt->cursor_spalte)
           spalte = qt->cursor_spalte;
         len = spalte;
      }
      if (ed_zeilenrest && dif>0)
        len += dif;

      t_ins_line( qt, qt->cursor_zeile, 1, len);
      zeile2 = qt->zeile[qt->cursor_zeile];

      if (ed_einruecken)
      {
         for ( i=0; i<spalte; i++)
           zeile2[i] = ' ';
         zeile2[spalte] = '\0';
      }
      if (ed_zeilenrest && dif>0)
      {
         strcpy( &zeile2[spalte], &zeile1[qt->cursor_spalte]);
         zeile1[qt->cursor_spalte] = '\0';
         toword( zeile1[-4]) = qt->cursor_spalte;
         nw_redraw( qw, 2, (LONG) qt->cursor_spalte*pwchar, (qt->cursor_zeile-1)
                    *phchar, (LONG) dif*pwchar, (LONG) phchar);
      }

      toword( zeile2[-4]) = len;

      /* Fenster neuzeichnen */
      if (qt->o_zeile+qt->a_zeilen != qt->cursor_zeile)
        nw_move( qw, 2, (LONG) qt->l_spalte*pwchar, qt->cursor_zeile*phchar,
                 (LONG) qw->iw, (qt->o_zeile+qt->a_zeilen-qt->cursor_zeile)
                 *phchar, 0, phchar, TRUE);

      if (!qt->geaendert)
      {
         qt->geaendert = TRUE;
         da_chkentry( qt->q_nummer);
      }
   }
   else
   {
      qt->cursor_zeile++;
      if (qt->cursor_zeile == qt->zeilenzahl)
      {
         t_ins_line( qt, qt->cursor_zeile, 1, 1);
         if (!qt->geaendert)
         {
            qt->geaendert = TRUE;
            da_chkentry( qt->q_nummer);
         }
      }
   }

   qt->cursor_spalte = spalte;
   if (qt->cursor_spalte < qt->l_spalte) qt->l_spalte = qt->cursor_spalte;
   if (qt->cursor_zeile >= qt->o_zeile+qt->a_zeilen-1)
     qt->o_zeile = qt->cursor_zeile-qt->a_zeilen+1;
   nw_npos( qw, W_INTERIOR, (LONG) qt->l_spalte*pwchar, qt->o_zeile*phchar);
   new_cursor( qt, ZEILE|SPALTE, TRUE);
}

void k_backspace( qt, qw)
register QUELLTEXT *qt;
register WINDOW *qw;
{
   register char *zeile, **zeile2;
   register WORD newlen;

   zeile = qt->zeile[qt->cursor_zeile];
   if (qt->cursor_an)
   {
      cursor( qw);
      qt->cursor_an = FALSE;
   }

   if (qt->cursor_spalte == 0)
     if (ed_zeilenrest && qt->cursor_zeile!=0)
     {
        /* Zeile zur vorherigen Zeile addieren */
        zeile2 = &qt->zeile[qt->cursor_zeile-1];
        newlen = toword( zeile[-4])+toword( (*zeile2)[-4]);
        if (newlen <= ZEILENBREITE)
        {
           /* Zeile zurÅckkopieren */
           if (newlen > toword( (*zeile2)[-2])) /* Zeilenspeicher vergrîûern */
             t_enl_line( zeile2, newlen);
           qt->cursor_spalte = toword( (*zeile2)[-4]);
           /* Zeilenrest in vorige Zeile kopieren */
           strcpy( &(*zeile2)[qt->cursor_spalte], zeile);
           t_del_line( qt, qt->cursor_zeile, 1); /* alte Zeile lîschen */
           toword( (*zeile2)[-4]) = newlen; /* neue ZeilenlÑnge */

           /* neuzeichnen */
           nw_redraw( qw, 2, (LONG) qt->cursor_spalte*pwchar,
                      (qt->cursor_zeile-1)*phchar, (LONG) qw->iw,
                      (LONG) phchar);
           nw_move( qw, 2, (LONG) qt->l_spalte*pwchar,
                    (qt->cursor_zeile+1)*phchar, (LONG) qw->iw,
                    (qt->o_zeile+qt->a_zeilen-qt->cursor_zeile--)*phchar,
                     0, -phchar, TRUE);
           new_cursor( qt, ZEILE|SPALTE, TRUE);
           if (!qt->geaendert)
           {
              qt->geaendert = TRUE;
              da_chkentry( qt->q_nummer);
           }
        }
        else
          pling();
     }
     else /* in vorherige Zeile gehen */
       mov_cursor( qt, LEFT);
   else
   {
      if (qt->cursor_spalte <= toword( zeile[-4]))
      {
         /* Zeichen vor dem Cursor lîschen */
         stradj( &zeile[qt->cursor_spalte-1], -1);
         (toword( zeile[-4]))--;
         nw_move( qw, 2, (LONG) (qt->cursor_spalte-1)*pwchar,
                  qt->cursor_zeile*phchar, (LONG) qw->iw, (LONG) phchar,
                  -pwchar, 0, TRUE);
         if (!qt->geaendert)
         {
            qt->geaendert = TRUE;
            da_chkentry( qt->q_nummer);
         }
     }
     mov_cursor( qt, LEFT); /* ein Zeichen zurÅck gehen */
  }
}

void k_delete( qt, qw)
register QUELLTEXT *qt;
register WINDOW *qw;
{
   register char **zeile, *zeile2;
   register WORD i;
   register WORD newlen;

   zeile = &qt->zeile[qt->cursor_zeile];
   if (qt->cursor_an)
   {
      cursor( qw);
      qt->cursor_an = FALSE;
   }

   if (qt->cursor_spalte < toword( (*zeile)[-4])) /* Buchstaben lîschen */
   {
      stradj( &(*zeile)[qt->cursor_spalte], -1);
      nw_move( qw, 2, (LONG) qt->cursor_spalte*pwchar,
               qt->cursor_zeile*phchar, (LONG) (toword( (*zeile)[-4])
               -qt->cursor_spalte)*pwchar, (LONG) phchar, -pwchar, 0, TRUE);
      (toword( (*zeile)[-4]))--;
      if (!qt->geaendert)
      {
         qt->geaendert = TRUE;
         info_changed = TRUE;
         da_chkentry( qt->q_nummer);
      }
   }
   else
     if (qt->cursor_zeile+1 != qt->zeilenzahl) /* untere Zeile hochziehen */
     {
        zeile2 = qt->zeile[qt->cursor_zeile+1];
        newlen = qt->cursor_spalte+toword( zeile2[-4]);
        if (newlen <= ZEILENBREITE)
        {
           /* Zeilenspeicher vergrîûern */
           if (newlen > toword( (*zeile)[-2]))
             t_enl_line( zeile, newlen);
           /* Zeile mit Leerzeichen auffÅllen */
           for ( i=toword( (*zeile)[-4]); i<qt->cursor_zeile; i++)
             (*zeile)[i] = ' ';
           /* untere Zeile nach vorne kopieren */
           strcpy( &(*zeile)[qt->cursor_spalte], zeile2);
           toword( (*zeile)[-4]) = newlen;
           /* Zeilenspeicher freigeben */
           t_del_line( qt, qt->cursor_zeile+1, 1);

           /* neuzeichnen */
           nw_redraw( qw, 2, (LONG) qt->cursor_spalte*pwchar,
                      qt->cursor_zeile*phchar, (LONG) qw->iw,
                      (LONG) phchar);
           nw_move( qw, 2, (LONG) qt->l_spalte*pwchar,
                    (qt->cursor_zeile+1)*phchar, (LONG) qw->iw,
                    (qt->o_zeile+qt->a_zeilen-qt->cursor_zeile)*phchar,
                     0, -phchar, TRUE);
           if (!qt->geaendert)
           {
              qt->geaendert = TRUE;
              info_changed = TRUE;
              da_chkentry( qt->q_nummer);
           }
        }
        else
          pling();
     }
     else /* Zeile lîschen */
       if (qt->zeilenzahl!=1 && toword( (*zeile)[-4])==0)
       {
          t_del_line( qt, qt->cursor_zeile--, 1);
          cur_y = qt->cursor_zeile*phchar;
       }

   qt->cursor_an = TRUE;
   cursor( qw);
}