/* Sliderberechnung */

#define UCE_SLIDER  1

#include <stdio.h>
#include <macros.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

void calc_slider( slider, slideframe, vis_el, anz_el, el_pos)
register OBJECT *slider, *slideframe;
register WORD vis_el, anz_el; /* Anzahl der sichtbaren/aller Elemente */
register WORD el_pos; /* Position des obersten Elements */
{
   if (anz_el <= vis_el)
   {
      slider->ob_height = slideframe->ob_height;
      slider->ob_y = 0;
   }
   else
   {
      slider->ob_height = max( slideframe->ob_height*vis_el/anz_el, phchar);
      slider->ob_y = (slideframe->ob_height-slider->ob_height)*el_pos
                     /(anz_el-vis_el);
   }
}

WORD move_slider( ob_tree, slidernr, slideframenr, vis_el, anz_el)
register OBJECT *ob_tree;
register WORD slidernr, slideframenr;
register WORD vis_el, anz_el;
{
   register WORD newpos, newtop;
   register OBJECT *slider, *slideframe;

   slider = &ob_tree[slidernr];
   slideframe = &ob_tree[slideframenr];

   newpos = graf_slidebox( ob_tree, slideframenr, slidernr, 1);

   newtop = (LONG) (anz_el-vis_el)*newpos/1000;

   return newtop;
}

void draw_slider( w_handle, ob_tree, slidenr)
register WORD w_handle;
register OBJECT *ob_tree;
register WORD slidenr; /* Nummer des Sliderrahmens */
{
   register OBJECT *slideframe;
   GRECT frame_size, rect;
   WORD intersect;

   slideframe = &ob_tree[slidenr];
   objc_offset( ob_tree, slidenr, &frame_size.g_x, &frame_size.g_y);
   frame_size.g_w = slideframe->ob_width;
   frame_size.g_h = slideframe->ob_height-1;

   wind_update( BEG_UPDATE);
   graf_mouse( M_OFF);

   wind_get( w_handle, WF_FIRSTXYWH, &rect.g_x, &rect.g_y, &rect.g_w,
             &rect.g_h);
   while (rect.g_w>0 && rect.g_h>0)
   {
      intersect = rc_intersect( &frame_size, &rect);
      if (intersect && rect.g_w>0 && rect.g_h>0)
        objc_draw( ob_tree, slidenr, MAX_DEPTH, rect.g_x, rect.g_y, rect.g_w,
                   rect.g_h);
      wind_get( w_handle, WF_NEXTXYWH, &rect.g_x, &rect.g_y, &rect.g_w,
                &rect.g_h);
   }

   wind_update( END_UPDATE);
   graf_mouse( M_ON);
}

void page_slider( w, ob_tree, slidenr, top, vis_el, anz_el, draw)
/* Slider eine Seite nach oben/unten verschieben */
register WINDOW *w;
register OBJECT *ob_tree;
register WORD slidenr, *top, vis_el, anz_el;
register void (*draw)();
{
   WORD py, my, button, dummy;

   objc_offset( ob_tree, slidenr, &dummy, &py);
   graf_mkstate( &dummy, &my, &dummy, &dummy);

   if (py<my) /* es wird nach unten gescrollt */
     do
     {
        if (*top+vis_el != anz_el)
        {
           *top += vis_el;
           if (*top+vis_el>anz_el) *top = anz_el-vis_el;
           (*draw)( w, 0);
        }

        graf_mkstate( &dummy, &dummy, &button, &dummy);
     } while (button & 1); /* solange linke Maustaste gedrÅckt */
   else /* es wird nach oben gescrollt */
     do
     {
        if (*top != 0)
        {
           *top -= vis_el;
           if (*top<0) *top = 0;
           (*draw)( w, 0);
        }

        graf_mkstate( &dummy, &dummy, &button, &dummy);
     } while (button & 1); /* solange linke Maustaste gedrÅckt */
}