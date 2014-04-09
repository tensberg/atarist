/* Verwaltung des Dateifensters */

#define UCE_DATEIFENSTER  1
#define BIT15  0x8000 /* wird bei Doppelklick gesetzt */

#include <stdio.h>
#include <macros.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

/* globale Variablen */
       WORD top_text = 0; /* oberster sichtbarer Eintrag */
static OBJECT *da_eintraege[7];
static char *da_haekchen[7];
static char leerstring[] = { '\0' };
static OBJECT *slider;
static OBJECT *slideframe;
static OBJECT *textback;
extern WORD h_dateien;

static void draw_entries( w, dir) /* Eintr„ge zeichnen */
register WINDOW *w;
WORD dir; /* nach oben/unten verschieben oder komplett neuzeichnen */
{
   register WORD i;
   WORD px, py;

   /* Eintr„ge setzen */
   for ( i=top_text; i<min( anz_texte, top_text+7); i++)
   {
      da_eintraege[i-top_text]->ob_spec = textfeld[i].q_name;
      if (textfeld[i].selected)
        da_eintraege[i-top_text]->ob_state |= SELECTED;
      else
        da_eintraege[i-top_text]->ob_state &= ~SELECTED;
      *da_haekchen[i-top_text] = textfeld[i].geaendert ? '' : ' ';
   }
   calc_slider( slider, slideframe, 7, anz_texte, top_text);

   if (w == NULL) return; /* Dateifenster nicht offen */

   /* neu zeichnen */
   draw_slider( h_dateien, w_dateien, DA_SLIDEFRAME);
   objc_offset( w_dateien, DA_TEXTBACK, &px, &py);
   if (dir == 0) /* komplett neu zeichnen */
     nw_redraw( w, 0, (LONG) px+1, (LONG) py, (LONG) textback->ob_width-2,
                      (LONG) textback->ob_height);
   else /* nur verschieben */
     nw_move( w, 0, (LONG) px+1, (LONG) py, (LONG) textback->ob_width-2,
              (LONG) textback->ob_height, 0, phchar*dir, TRUE);
}

static void sel_entries( w, select) /* mehrere Eintr„ge selektieren */
register WINDOW *w; /* Dialogfenster */
register WORD select; /* 0 : deselektieren/1 : selektieren */
{
   register QUELLTEXT *qt;
   WORD dummy;
   GRECT frame; /* Umrahmung der Eintr„ge */
   GRECT entry; /* Rand um den Eintrag */
   register GRECT *mom;
   WORD mx, my; /* Mausposition */
   register WORD event, mbuf[8];
   register WORD object; /* Nummer des Objekts unter der Maus */
   register WORD in; /* Flag, ob Mauszeiger aužerhalb der Box ist */

   /* Umrahmung der Eintr„ge ausrechnen */
   objc_offset( w_dateien, DA_TEXT1, &frame.g_x, &frame.g_y);
   objc_offset( w_dateien, DA_TEXT7, &frame.g_w, &frame.g_h);
   frame.g_w += da_eintraege[6]->ob_width-frame.g_x;
   frame.g_h += da_eintraege[6]->ob_height-frame.g_y;

   /* Breite und H”he eines Eintrags */
   entry.g_w = da_eintraege[0]->ob_width;
   entry.g_h = da_eintraege[0]->ob_height;

   wind_update( BEG_MCTRL);
   graf_mouse( POINT_HAND);
   graf_mkstate( &mx, &my, &dummy, &dummy);

   event = MU_M1;

   do
   {
      if (event & MU_M1)
      {
         /* Objekt unter dem Mauszeiger untersuchen */
         object = objc_find( w_dateien, 0, MAX_DEPTH, mx, my);
         if (object>=DA_TEXT1 && object<=DA_TEXT7)
         {
            in = TRUE;
            mom = &entry;
            objc_offset( w_dateien, object, &entry.g_x, &entry.g_y);
            qt = &textfeld[object-DA_TEXT1+top_text];
            if (qt->selected != select)
            {
               qt->selected = select;
               sel_object( w, w_dateien, object, select);
            }
         }
         else /* Mauszeiger befindet sich aužerhalb der Box */
         {
            in = FALSE;
            mom = &frame;
         }
      }

      if (event & MU_TIMER) /* Eintr„ge nach oben/unten scrollen */
      {
         if (my<frame.g_y && top_text != 0) /* nach oben scrollen */
         {
            textfeld[--top_text].selected = select;
            draw_entries( w, 1);
         }

         if (my>=frame.g_y+frame.g_h && top_text+7<anz_texte)
         {
            textfeld[++top_text+6].selected = select;
            draw_entries( w, -1);
         }
      }

      /* warten auf Selektion eines anderen Eintrags oder loslassen des
         Mausknopfes */
      event = evnt_multi( MU_BUTTON|MU_M1|(in ? 0 : MU_TIMER), 1, 1, 0, in,
                          mom->g_x, mom->g_y, mom->g_w, mom->g_h, 0, 0, 0, 0,
                          0, mbuf, 15, 0, &mx, &my, &dummy, &dummy, &dummy,
                          &dummy);
   } while (!(event & MU_BUTTON)); /* solange Mausknopf gedrckt */

   graf_mouse( ARROW);
   wind_update( END_MCTRL);
}

static void b_dateien( button)
register WORD button;
{
   register WORD doppelklick;
            WORD event, mbuf[8], dummy;
   register QUELLTEXT *qt;
   register WINDOW *w; /* Dialogfenster */

   doppelklick = (button & BIT15);
   button &= ~BIT15;

   w = nw_searchwin( h_dateien);

   if (button>=DA_TEXT1 && button<=DA_TEXT7)
   {
     qt = &textfeld[button-DA_TEXT1+top_text];
     if (doppelklick) /* Quelltext ”ffnen oder Fenster toppen */
     {
        if (!qt->selected)
          sel_object( w, w_dateien, button, 1);

        if (!qt->w.w_open)
          t_open_text( qt->q_nummer);
        else
          top( qt->w.w_handle);

        a_qt = qt;
        if (!qt->selected)
          sel_object( w, w_dateien, button, 0);
     }
     else
     {
        event = evnt_multi( MU_BUTTON|MU_TIMER, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
                            0, 0, 0, mbuf, 15, 0, &dummy, &dummy, &dummy,
                            &dummy, &dummy, &dummy);

        if (event & MU_BUTTON) /* nur Einfachselektion eines Eintrags */
        {
           qt->selected = !qt->selected;
           sel_object( w, w_dateien, button, qt->selected);
        }
        else
          sel_entries( w, !textfeld[button-DA_TEXT1+top_text].selected);
     }

     return;
   }

   switch (button)
   {
      case 0 : /* Dialog schliežen */
        d_end( &h_dateien);
        break;

      case DA_UP :
        if (top_text == 0) return;
        top_text--;
        draw_entries( w, 1);
        break;

      case DA_DOWN :
        if (top_text+8 > anz_texte) return;
        top_text++;
        draw_entries( w, -1);
        break;

      case DA_SLIDER :
        if (anz_texte > 7)
        {
           top_text = move_slider( w_dateien, DA_SLIDER, DA_SLIDEFRAME, 7,
                                   anz_texte);
           draw_entries( w, 0);
        }
        break;

     case DA_SLIDEFRAME :
       page_slider( w, w_dateien, DA_SLIDER, &top_text, 7, anz_texte,
                    draw_entries);
       break;
   }
}
/* --------- nach aužen sichtbare Funktionen ----------*/
void in_dateifenster()
{
   register WORD i; /* Z„hlvariable */

   for ( i=DA_HAEKCHEN1; i<=DA_HAEKCHEN7; i++)
   {
      da_haekchen[i-DA_HAEKCHEN1] = (char *) &w_dateien[i].ob_spec;
      *da_haekchen[i-DA_HAEKCHEN1] = ' ';
   }

   for ( i=DA_TEXT1; i<=DA_TEXT7; i++)
   {
      da_eintraege[i-DA_TEXT1] = &w_dateien[i];
      w_dateien[i].ob_spec = leerstring; /* leerer Eintrag */
      w_dateien[i].ob_state |= DISABLED; /* nicht anw„hlbar */
   }

   slider = &w_dateien[DA_SLIDER];
   slideframe = &w_dateien[DA_SLIDEFRAME];
   textback = &w_dateien[DA_TEXTBACK];
   slider->ob_y = 0;
   slider->ob_height = slideframe->ob_height;
}

void m_dateien()
{
   if (h_dateien == 0) /* Dialogfenster ”ffnen */
   {
      draw_entries( NULL, 0);
      h_dateien = nf_do( w_dateien, 0, ei_mausposition, TRUE, f_name, b_dateien,
                         &evnt, ei_growshrink);
   }
   else /* Dialogfenster toppen */
     top( h_dateien);
}

void da_newentry( t_nr)
register WORD t_nr; /* Nummer des Textes, der neu eingetragen werden soll */
{
   register WORD ein_nr; /* Nummer des Eintrags, in den t_nr eingetragen wird */
   register WINDOW *w; /* Dialogfenster */
   register OBJECT *eintrag;
   WORD px, py; /* Redraw-Koordinaten */

   calc_slider( slider, slideframe, 7, anz_texte, top_text);
   if (h_dateien != 0) draw_slider( h_dateien, w_dateien, DA_SLIDEFRAME);

   ein_nr = t_nr-top_text;
   if (ein_nr<0 || ein_nr>6) return; /* Eintrag nicht sichtbar */

   eintrag = da_eintraege[ein_nr];
   eintrag->ob_spec = textfeld[t_nr].q_name;
   eintrag->ob_state ^= DISABLED; /* Eintrag anw„hlbar */

   /* Dialogausschnitt neuzeichnen */
   if (h_dateien != 0) /* Dialog ist offen */
   {
      w = nw_searchwin( h_dateien);
      objc_offset( w_dateien, DA_TEXT1+ein_nr, &px, &py);
      nw_redraw( w, 0, (LONG) px, (LONG) py, (LONG) eintrag->ob_width,
                (LONG) eintrag->ob_height);
   }
}

void da_delentry( t_nr)
register WORD t_nr; /* Nummer des Textes, der gel”scht werden soll */
{
   register WORD ein_nr; /* Nummer des Eintrags */

   ein_nr = t_nr-top_text;
   if (ein_nr<0 || ein_nr>6) return; /* Eintrag nicht sichtbar */

   if (anz_texte-top_text < 7)
   {
      da_eintraege[anz_texte-top_text]->ob_spec = leerstring;
      da_eintraege[anz_texte-top_text]->ob_state = DISABLED;
      *da_haekchen[anz_texte-top_text] = ' ';
   }

   if (top_text+7>anz_texte && top_text!=0)
     top_text--;

   calc_slider( slider, slideframe, 7, anz_texte, top_text);
   draw_entries( nw_searchwin( h_dateien), 0);
}

void da_chkentry( t_nr) /* H„kchen zeichnen */
register WORD t_nr;
{
   register WINDOW *w; /* Dialogfenster */
   register WORD ein_nr;
   WORD px, py; /* Redraw-Koordinaten */
   register OBJECT *eintrag;

   ein_nr = t_nr-top_text;
   if (ein_nr<0 || ein_nr>6) return; /* Eintrag nicht sichtbar */

   *da_haekchen[ein_nr] = textfeld[t_nr].geaendert ? '' : ' ';

   if (h_dateien != 0) /* Dialog ist ge”ffnet */
   {
      w = nw_searchwin( h_dateien);
      objc_offset( w_dateien, DA_HAEKCHEN1+ein_nr, &px, &py);
      eintrag = &w_dateien[DA_HAEKCHEN1+ein_nr];
      nw_redraw( w, 0, (LONG) px, (LONG) py, (LONG) eintrag->ob_width,
                 (LONG) eintrag->ob_height);
   }
}

void da_newname( t_nr)
register WORD t_nr;
{
   register WINDOW *w; /* Dialogfenster */
   register WORD ein_nr;
   WORD px, py; /* Redraw-Koordinaten */
   register OBJECT *eintrag;

   ein_nr = t_nr-top_text;
   if (ein_nr<0 || ein_nr>6) return; /* Eintrag nicht sichtbar */

   da_eintraege[ein_nr]->ob_spec = textfeld[t_nr].q_name;

   if (h_dateien != 0) /* Dialog ist ge”ffnet */
   {
      w = nw_searchwin( h_dateien);
      objc_offset( w_dateien, DA_TEXT1+ein_nr, &px, &py);
      nw_redraw( w, 0, (LONG) px, (LONG) py, (LONG) da_eintraege[ein_nr]->
                 ob_width, (LONG) da_eintraege[ein_nr]->ob_height);
   }
}