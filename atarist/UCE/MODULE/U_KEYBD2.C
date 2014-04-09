/* Zeichen in Text einfÅgen */

#define UCE_KEYBOARD2  1

#include <stdio.h>
#include <string.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

static WORD enl_line( zeile, len, maxlen, newlen)
register char **zeile;
register WORD **len, **maxlen;
WORD newlen;
{
   register char *speicher;
   register WORD fehler;

   fehler = t_enl_line( zeile, newlen+1);
   if (fehler) return fehler;
   *len = (WORD *) (*zeile-4);
   *maxlen = (WORD *) (*zeile-2);
}

static void fill_zeile( zeile, len, maxlen, spalte)
/* Zeile mit Leerzeichen auffÅllen */
register char **zeile;
register WORD **len, **maxlen;
register WORD spalte;
{
   WORD nlen;
   register char *speicher;
   register WORD i;

   if (**maxlen <= spalte) /* neuen Speicher allozieren */
     enl_line( zeile, len, maxlen, spalte+1);

   /* String auffÅllen */
   for ( i=**len; i<spalte; i++)
     (*zeile)[i] = ' ';
   (*zeile)[spalte] = '\0';
   **len = spalte;
}

static void draw_char( ascii, x, y) /* Zeichen zeichnen */
register char ascii;
register WORD x, y;
{
   register char *zeile = " ";
   register WORD xyarray[4];

   clip_on( wk_handle, work.g_x, work.g_y, work.g_w, work.g_h);
   graf_mouse( M_OFF);
   wind_update( BEG_UPDATE);
   /* Hintergrund lîschen */
   xyarray[0] = x;
   xyarray[1] = y;
   xyarray[2] = x+pwchar-1;
   xyarray[3] = y+phchar-1;
   vsf_color( wk_handle, 0); /* FÅllfarbe wei· */
   v_bar( wk_handle, xyarray);
   vsf_color( wk_handle, 1);
   /* Zeichen ausgeben */
   *zeile = ascii;
   v_gtext( wk_handle, x, y, zeile);
   wind_update( END_UPDATE);
   graf_mouse( M_ON);
   clip_off( wk_handle);
}

static void z_umbruch( qt, qw)
register QUELLTEXT *qt;
register WINDOW *qw;
{
   register char *line, *line2;
   register WORD i, j;
   register WORD len; /* WortlÑnge */
   register LONG zeile;
   register WORD spalte;

   zeile = qt->cursor_zeile;
   spalte = qt->cursor_spalte;

   line = qt->zeile[zeile++];

   if (!ed_zeilenumbruch) /* in nÑchste Zeile gehen */
   {
      if (zeile == qt->zeilenzahl)
        t_ins_line( qt, qt->zeilenzahl, 1, 1);
      spalte = 0;
   }
   else
   {
      /* Wortanfang suchen */
      i = spalte;
      while (i>0 && ischar( line[i]))
        i--;
      if (!ischar( line[i])) i++;

      len = toword( line[-4])-i;

      spalte = 0;
      if (ed_einruecken)
      {
         while (line[spalte] == ' ')
           spalte++;
         if (spalte > i) spalte = i;
      }

      /* Zeile einfÅgen */
      t_ins_line( qt, zeile, 1, spalte+len);
      line2 = qt->zeile[zeile];

      /* Zeile mit Leerzeichen auffÅllen */
      for ( j=0; j<spalte; j++)
        line2[j] = ' ';

      /* Wort umkopieren */
      strcpy( &line2[spalte], &line[i]);
      line[i] = '\0';
      toword( line[-4]) = i;
      toword( line2[-4]) = spalte+len;
      spalte += qt->cursor_spalte-i+1;

      /* neuzeichnen */
      nw_redraw( qw, 2, (LONG) i*pwchar, qt->cursor_zeile*
                 phchar, (LONG) qw->iw, (LONG) phchar);
      if (zeile < qt->o_zeile+qt->a_zeilen)
        nw_move( qw, 2, (LONG) qt->l_spalte*pwchar, zeile*phchar, (LONG) qw->iw,
                 (zeile-qt->o_zeile+qt->a_zeilen)*phchar, 0, phchar, TRUE);
   }

   if (zeile >= qt->o_zeile+qt->a_zeilen)
     qt->o_zeile = zeile-qt->a_zeilen+1;
   if (spalte < qt->l_spalte)
     qt->l_spalte = spalte;

   qt->cursor_zeile = zeile;
   qt->cursor_spalte = spalte;

   nw_npos( qw, W_INTERIOR, (LONG) qt->l_spalte*pwchar,
            qt->o_zeile*phchar);
   new_cursor( qt, ZEILE|SPALTE, TRUE);
}

/* -------- nach au·en sichtbare Prozeduren --------- */
void ins_char( qt, zeichen)
register QUELLTEXT *qt;
register WORD zeichen;
{
   register WINDOW *qw;
   register char ascii;
   register char **zeile;
   WORD *len; /* ZeilenlÑnge */
   WORD *maxlen; /* maximale ZeilenlÑnge */

   qw = &qt->w;
   ascii = zeichen & 0xff;
   zeile = &qt->zeile[qt->cursor_zeile];
   len = (WORD *) (*zeile-4);
   maxlen = (WORD *) (*zeile-2);

   if (qt->cursor_spalte >= *len)
     fill_zeile( zeile, &len, &maxlen, qt->cursor_spalte);

   if (!ed_einfuegen || qt->cursor_spalte==*len) /* Zeichen Åberschreiben */
   {
      (*zeile)[qt->cursor_spalte] = ascii;
      (*zeile)[qt->cursor_spalte+1] = '\0';
      (*len)++;
      draw_char( ascii, (WORD) (qt->cursor_spalte*pwchar-qw->rx+qw->ix),
                        (WORD) (qt->cursor_zeile*phchar-qw->ry+qw->iy));
      qt->cursor_an = FALSE;
   }
   else /* Zeichen einfÅgen */
   {
      if (*len == ZEILENBREITE) /* Zeile zu lang */
      {
         pling();
         return;
      }
      if (*len == *maxlen)
        enl_line( zeile, &len, &maxlen, *len+1);
      if (qt->cursor_an)
      {
         cursor( qw);
         qt->cursor_an = FALSE;
      }
      stradj( &(*zeile)[qt->cursor_spalte], 1);
      (*zeile)[qt->cursor_spalte] = ascii;
      nw_move( qw, 2, (LONG) qt->cursor_spalte*pwchar,
               qt->cursor_zeile*phchar, (LONG) (*len-qt->cursor_spalte+1)*
               pwchar, (LONG) phchar, pwchar, 0, TRUE);
      (*len)++;
   }

   if (qt->cursor_spalte==ZEILENBREITE-1 || ed_zeilenumbruch &&
       qt->cursor_spalte+1 == ed_umbruchbreite)
       z_umbruch( qt, qw);
   else
     mov_cursor( qt, RIGHT);

   if (!qt->geaendert)
   {
      qt->geaendert = TRUE;
      info_changed = TRUE;
      da_chkentry( qt->q_nummer);
   }
}