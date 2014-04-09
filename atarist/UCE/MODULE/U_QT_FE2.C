/* Prozeduren zur Quelltextfensterbearbeitung */

#define UCE_QT_FENSTER2  1

#include <stdio.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

void qt_sredraw( w, wx, wy, ww, wh) /* Redraw-Routine fr Textfensterinhalt */
register WINDOW *w;
register WORD wx, wy, ww, wh;
{
   register WORD xyarray[4];
   register QUELLTEXT *qt;
   LONG o_zeile, u_zeile;
   WORD l_spalte, r_spalte;
   WORD ok_zeile, uk_zeile, lk_spalte, rk_spalte;
   register char zeichen; /* Zwischenspeicher fr Zeichen */
   register char *zeichen2 = "x";
   register char *r_zeichen; /* Adresse des zwischenzuspeichernden Zeichens */
   register char *zeile; /* Adresse der Textzeile */
   register char **liste; /* Feld mit Zeilenzeigern */
   register WORD offs_x, offs_x2, offs_y; /* Textposition */
   register WORD i; /* Z„hlervariable */

   if (!ww || !wh) return; /* ungltige Breite/H”he */

   qt = &textfeld[w->r_sparam];

   /* Hintergrund l”schen */
   xyarray[0] = wx;
   xyarray[1] = wy;
   xyarray[2] = wx+ww-1;
   xyarray[3] = wy+wh-1;
   vsf_color( wk_handle, 0); /* Fllfarbe weiá */
   v_bar( wk_handle, xyarray);
   vsf_color( wk_handle, 1);

   /* Text zeichnen */
   ok_zeile = get_top( qt, wy, wy+wh, &o_zeile);
   uk_zeile = get_bottom( qt, wy, wy+wh, &u_zeile);
   lk_spalte = get_left( qt, wx, wx+ww, &l_spalte);
   rk_spalte = get_right( qt, wx, wx+ww, &r_spalte);
   offs_x = l_spalte*pwchar-w->rx+w->ix;
   offs_x2 = r_spalte*pwchar-w->rx+w->ix;
   offs_y = o_zeile*phchar-w->ry+w->iy;

   /* Randzeilen neuzeichnen */
   clip_on( wk_handle, wx, wy, ww, wh);
   if (!ok_zeile && toword( qt->zeile[o_zeile][-4])>l_spalte) /* oberste Zeile neu */
     v_gtext( wk_handle, offs_x, offs_y, &qt->zeile[o_zeile][l_spalte]);
   if (!uk_zeile && toword( qt->zeile[u_zeile][-4])>l_spalte) /* unterste Zeile neu */
     v_gtext( wk_handle, offs_x, (WORD) (offs_y+(u_zeile-o_zeile)*phchar),
              &qt->zeile[u_zeile][l_spalte]);

   if (!ok_zeile)
   {
      o_zeile++;
      offs_y += phchar;
   }
   if (!uk_zeile) u_zeile--;

   /* Randspalten neuzeichnen */
   if (!lk_spalte) /* linke Spalte zeichnen */
   {
      liste = &qt->zeile[o_zeile];
      for ( i=0; i<=u_zeile-o_zeile; i++)
      {
         zeile = *liste++;
         if (toword( zeile[-4]) > l_spalte)
         {
            *zeichen2 = zeile[l_spalte];
            v_gtext( wk_handle, offs_x, offs_y+i*phchar, zeichen2);
         }
      }
      l_spalte++;
      offs_x += pwchar;
   }
   if (!rk_spalte) /* rechte Spalte zeichnen */
   {
      liste = &qt->zeile[o_zeile];
      for ( i=0; i<=u_zeile-o_zeile; i++)
      {
         zeile = *liste++;
         if (toword( zeile[-4]) > r_spalte)
         {
            *zeichen2 = zeile[r_spalte];
            v_gtext( wk_handle, offs_x2, offs_y+i*phchar, zeichen2);
         }
      }
      r_spalte--;
   }
   clip_off( wk_handle);

   /* restlichen Text neuzeichnen */
   r_spalte++;
   liste = &qt->zeile[o_zeile];
   if (l_spalte < r_spalte)
     for ( i=0; i<=u_zeile-o_zeile; i++)
     {
        zeile = *liste++;
        if (toword( zeile[-4]) > l_spalte)
        {
           r_zeichen = &zeile[r_spalte];
           zeichen = *r_zeichen;
           *r_zeichen = '\0';
           v_gtext( wk_handle, offs_x, offs_y+i*phchar, &zeile[l_spalte]);
           *r_zeichen = zeichen;
        }
     }

   /* Cursor zeichnen */
   if (a_qt==qt && qt->cursor_an)
   {
      xyarray[0] = w->ix+cur_x-w->rx;
      xyarray[1] = w->iy+cur_y-w->ry;
      xyarray[2] = xyarray[0]+cur_width-1;
      xyarray[3] = xyarray[1]+phchar-1;
      clip_on( wk_handle, wx, wy, ww, wh);
      vswr_mode( wk_handle, MD_XOR); /* Zeichenmodus Invertieren */
      vr_recfl( wk_handle, xyarray);
      vswr_mode( wk_handle, MD_REPLACE);
      clip_off( wk_handle);
   }
}