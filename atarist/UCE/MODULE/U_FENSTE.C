/* Fenster sortieren */

#define UCE_FEN_SORTIEREN  1

#include <stdio.h>
#include <macros.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

static WORD count_open() /* offene Quelltextfenster z„hlen */
{
   register WORD i;
   register WORD anz_offen = 0;

   for ( i=0; i<anz_texte; i++)
     if (textfeld[i].w.w_open) anz_offen++;

   return anz_offen;
}

static void sort_neben() /* Fenster nebeneinander sortieren */
{
   register QUELLTEXT *qt;
   register WINDOW *qw;
   register WORD xpos; /* Neue Fensterposition */
   register WORD breite; /* Breite jedes Fensters */
   register WORD anz_offen; /* Anzahl offener Quelltextfenster */
   register WORD i;

   anz_offen = count_open();
   breite = work.g_w/anz_offen;
   xpos = work.g_x;

   for ( i=0; i<anz_texte; i++)
   {
      qt = &textfeld[i];
      qw = &qt->w;
      if (qw->w_open)
      {
         nw_npos( qw, W_FRAME, (LONG) xpos, (LONG) work.g_y);
         nw_nsize( qw, W_FRAME, (LONG) max( breite, pwchar*8),
                   (LONG) work.g_h);
         get_nsize( qt, qw, (qt==a_qt));
         xpos = qw->wx+breite;
      }
   }
}

static void sort_ueber()
{
   register QUELLTEXT *qt;
   register WINDOW *qw;
   register WORD ypos; /* Neue Fensterposition */
   register WORD hoehe; /* H”he jedes Fensters */
   register WORD anz_offen; /* Anzahl offener Quelltextfenster */
   register WORD i;

   anz_offen = count_open();
   hoehe = work.g_h/anz_offen;
   ypos = work.g_y;

   for ( i=0; i<anz_texte; i++)
   {
      qt = &textfeld[i];
      qw = &qt->w;
      if (qw->w_open)
      {
         nw_npos( qw, W_FRAME, (LONG) work.g_x, (LONG) ypos);
         nw_nsize( qw, W_FRAME, (LONG) work.g_w, (LONG) max( hoehe, phchar*8));
         get_nsize( qt, qw, (qt==a_qt));
         ypos += hoehe;
      }
   }
}

static void sort_verschachtelt()
{
   register QUELLTEXT *qt, *t_qt;
   register WINDOW *qw;
   register WORD xpos, ypos; /* Neue Fensterposition */
   register WORD breite, hoehe;
   register WORD anz_offen; /* Anzahl offener Quelltextfenster */
   register WORD i;
   WORD ydif; /* H”he des Fenstertitelbalkens */
   WORD top; /* oberstes Fenster */
   WORD dummy;

   wind_calc( WC_WORK, NAME|CLOSER|FULLER, 0, 0, 100, 100, &dummy, &ydif,
              &dummy, &dummy);
   wind_get( 0, WF_TOP, &top, &dummy, &dummy, &dummy);
   t_qt = t_find_qt( top);

   anz_offen = count_open();
   xpos = work.g_x;
   ypos = work.g_y;
   breite = max( work.g_w-(anz_offen-1)*pwchar*2, pwchar*8);
   hoehe = max( work.g_h-(anz_offen-1)*ydif, phchar*8);

   for ( i=0; i<anz_texte; i++)
   {
      qt = &textfeld[i];
      qw = &qt->w;
      if (qw->w_open && qt!=t_qt)
      {
         nw_npos( qw, W_FRAME, (LONG) xpos, (LONG) ypos);
         nw_nsize( qw, W_FRAME, (LONG) breite, (LONG) hoehe);
         get_nsize( qt, qw, (qt==a_qt));
         xpos = qw->wx+pwchar*2;
         ypos += ydif;
         wind_set( qw->w_handle, WF_TOP, 0, 0, 0, 0);
      }
   }

   if (t_qt != NULL)
   {
      qw = &t_qt->w;
      nw_npos( qw, W_FRAME, (LONG) xpos, (LONG) ypos);
      nw_nsize( qw, W_FRAME, (LONG) breite, (LONG) hoehe);
      get_nsize( qt, qw, (qt==a_qt));
      wind_set( qw->w_handle, WF_TOP, 0, 0, 0, 0);
   }
}

/* ------- nach aužen sichtbare Prozeduren -------- */
void m_fenster()
{
   register WORD select;

   select = popup( p_fenster, 0, FE_BACK, ei_growshrink);
   redraw();

   switch (select)
   {
      case FE_NEBEN :
        sort_neben();
        break;

      case FE_UEBER :
        sort_ueber();
        break;

      case FE_VERSCHACHTELT :
        sort_verschachtelt();
        break;
   }
}