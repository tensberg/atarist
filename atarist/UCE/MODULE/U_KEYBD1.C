/* Tastendruck auswerten */

#define UCE_KEYBOARD1  1

#include <stdio.h>
#include <macros.h>
#include <ctype.h>
#include <osbind.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

/* Funktionsprototypen */
WORD ischar();

static WORD find_lword( zeile, spalte)
register char *zeile;
register WORD spalte;
{
   if (spalte == 0) return 0;
   if (spalte >= toword( zeile[-4])) spalte = toword( zeile[-4]);
   spalte--;

   if (!ischar(zeile[spalte])) /* Wortende finden */
     while (spalte>0 && !ischar(zeile[spalte]))
       spalte--;
   if (spalte == 0) return 0;

   /* Wortanfang finden */
   while (spalte>0 && ischar(zeile[spalte]))
     spalte--;
   if (!ischar(zeile[spalte])) spalte++;

   return spalte;
}

static WORD find_rword( zeile, spalte)
register char *zeile;
register WORD spalte;
{
   register WORD len; /* ZeilenlÑnge */

   len = toword( zeile[-4]);

   if (spalte >= len) return spalte;

   if (ischar(zeile[spalte])) /* Wortende suchen */
     while (spalte<len && ischar(zeile[spalte]))
       spalte++;
   if (spalte == len) return spalte;

   /* Wortanfang suchen */
   while (spalte<len && !ischar(zeile[spalte]))
     spalte++;

   return spalte;
}

/* ------- nach auûen sichtbare Prozeduren -------- */
WORD ischar( zeichen)
register char zeichen;
{
   register char *zeiger;
   register WORD i = 0;

   if (isalnum( (WORD) zeichen)) return 1;

   zeiger = *s_erlaubt;
   while (*zeiger != '\0')
     if (zeichen == *(zeiger++)) return 1;

   return 0;
}

WORD qt_keybd( e_multi)
register E_MULTI *e_multi;
{
   register QUELLTEXT *qt;
   register WINDOW *qw;
   register WORD taste;
   register WORD pkstate;

   taste = mapkey( *e_multi->pkr);
   pkstate = *e_multi->pks;
   qt = a_qt;
   qw = &qt->w;

   switch (*e_multi->pkr>>8 & 0xff) /* Scancode untersuchen */
   {
      case KbHOME :
        if (pkstate & KsSHIFT) /* zum Textende */
        {
           qt->cursor_zeile = qt->zeilenzahl-1;
           qt->cursor_spalte = 0;
           qt->o_zeile = max( 0l, qt->zeilenzahl-qt->a_zeilen);
           qt->l_spalte = 0;
           nw_npos( qw, W_INTERIOR, 0l, qt->o_zeile*phchar);
        }
        else /* zum Textanfang */
        {
           qt->cursor_zeile = 0;
           qt->cursor_spalte = 0;
           qt->o_zeile = 0;
           qt->l_spalte = 0;
           nw_npos( qw, W_INTERIOR, 0l, 0l);
        }
        new_cursor( qt, ZEILE|SPALTE, TRUE);
        break;

      case KbUP :
        if (pkstate & KsSHIFT) /* eine Seite zurÅckblÑttern */
        {
           if (qt->o_zeile == 0)
             qt->cursor_zeile = 0;
           else
           {
              qt->cursor_zeile -= qt->o_zeile;
              qt->o_zeile -= qt->a_zeilen;
              if (qt->o_zeile < 0) qt->o_zeile = 0;
              qt->cursor_zeile += qt->o_zeile;
              nw_npos( qw, W_INTERIOR, (LONG) qt->l_spalte*pwchar,
                       qt->o_zeile*phchar);
           }
           new_cursor( qt, ZEILE, TRUE);
        }
        else
          mov_cursor( qt, UP); /* eine Zeile hoch */
        break;

      case KbDOWN :
        if (pkstate & KsSHIFT) /* eine Seite runter */
        {
           if (qt->o_zeile+qt->a_zeilen >= qt->zeilenzahl)
           {
              qt->cursor_zeile = qt->o_zeile+qt->a_zeilen-1;
              if (qt->cursor_zeile >= qt->zeilenzahl)
                qt->cursor_zeile = qt->zeilenzahl-1;
           }
           else
           {
              qt->cursor_zeile -= qt->o_zeile;
              qt->o_zeile += qt->a_zeilen;
              if (qt->o_zeile+qt->a_zeilen >= qt->zeilenzahl)
                qt->o_zeile = qt->zeilenzahl-qt->a_zeilen;
              qt->cursor_zeile += qt->o_zeile;
              nw_npos( qw, W_INTERIOR, (LONG) qt->l_spalte*pwchar,
                       qt->o_zeile*phchar);
           }
           new_cursor( qt, ZEILE, TRUE);
        }
        else
          mov_cursor( qt, DOWN); /* eine Zeile runter */
        break;

      case KbLEFT :
        if (pkstate & KsSHIFT)
        {
           qt->l_spalte = 0;
           qt->cursor_spalte = 0;
           nw_npos( qw, W_INTERIOR, 0l, qt->o_zeile*phchar);
           new_cursor( qt, SPALTE, TRUE);
        }
        else
          mov_cursor( qt, LEFT);
        break;

      case KbRIGHT :
        if (taste & KbSHIFT)
        {
           qt->cursor_spalte = toword( qt->zeile[qt->cursor_zeile][-4]);
           if (qt->l_spalte+qt->a_spalten <= qt->cursor_spalte)
           {
              qt->l_spalte = min( qt->cursor_spalte-qt->a_spalten+5,
                                  ZEILENBREITE-qt->a_spalten);
              nw_npos( qw, W_INTERIOR, (LONG) qt->l_spalte*pwchar,
                       qt->o_zeile*phchar);
           }
           new_cursor( qt, SPALTE, TRUE);
        }
        else
          mov_cursor( qt, RIGHT);
        break;

      case 115 : /* CONTROL + <- , Wort nach links */
        qt->cursor_spalte = find_lword( qt->zeile[qt->cursor_zeile],
                                        qt->cursor_spalte);
        if (qt->l_spalte > qt->cursor_spalte)
        {
           qt->l_spalte = qt->cursor_spalte;
           nw_npos( qw, W_INTERIOR, (LONG) qt->l_spalte*pwchar,
                    qt->o_zeile*phchar);
        }
        new_cursor( qt, SPALTE, TRUE);
        break;

      case 116 : /* CONTROL + -> , Wort nach rechts */
        qt->cursor_spalte = find_rword( qt->zeile[qt->cursor_zeile],
                                        qt->cursor_spalte);
        if (qt->l_spalte+qt->a_spalten <= qt->cursor_spalte)
        {
           qt->l_spalte = min( qt->cursor_spalte-qt->a_spalten+5,
                               ZEILENBREITE-qt->a_spalten);
           nw_npos( qw, W_INTERIOR, (LONG) qt->l_spalte*pwchar,
                    qt->o_zeile*phchar);
        }
        new_cursor( qt, SPALTE, TRUE);
        break;

      default :
        if (!(taste & (KbSCAN|KbCONTROL)))
          switch (taste & 0xff) /* ASCII-Code untersuchen */
          {
             case 13 : /* Return-Taste */
               k_return( qt, qw);
               break;

             case 8 : /* Backspace */
               k_backspace( qt, qw);
               break;

             case 127 :
               k_delete( qt, qw);
               break;

             default :
               if (taste & KbALT)
                 switch (taste & 0xff)
                 {
                    case 132 : /* 'Ñ' */
                      taste = 93 | taste&0xff00; /* ']' */
                      break;

                    case 142 : /* 'é' */
                      taste = 125 | taste&0xff00; /* '}' */
                      break;

                    case 148 : /* 'î' */
                      taste = 91 | taste &0xff00; /* '[' */
                      break;

                    case 153 : /* 'ô' */
                      taste = 123 | taste&0xff00; /* '}' */
                      break;

                    case 129 : /* 'Å' */
                      taste = 64 | taste&0xff00; /* '@' */
                      break;

                    case 154 : /* 'ö' */
                      taste = 92 | taste &0xff00; /* '\' */
                      break;
                 }
               ins_char( qt, taste); /* Zeichen in Text einfÅgen */
               break;
          }
        break;
   } /* switch */

   return 1;
}