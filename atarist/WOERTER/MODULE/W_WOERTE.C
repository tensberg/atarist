/* Wîrterbuch-DurchfÅhrung */

#include <stdio.h>
#include <macros.h>
#include <gemfast.h>
#include <window.h>
#include <w_header.h>

/* externe Funktionen */
extern WORD selected();
extern WORD comp_entries();
extern WORD comp_words();

/* Funktionsprototypen */
void woerter();

/* globale Variablen */
static char *leerstring = "";
static char orginal[31];
static char **ueber[5];
static WORD sprache;
static WORD gewaehlt = -1;
static WORD *anz, *top, **liste;
       WORD top_d_e = 0;
       WORD top_e_d = 0;
       OBJECT *wo_slider, *wo_slframe;
static OBJECT *wo_frame;
       OBJECT *wo_wortzahl;
       OBJECT *wo_woerter[8];
extern WORD h_woerterbuch;
extern WORD _bsearch;

static void loesche_state()
{
   register WORD i;

   for ( i=0; i<min( 8, *anz); i++)
     wo_woerter[i]->ob_state = 0;
}

static WORD zeichne( w, dir)
register WINDOW *w;
register WORD dir;
{
   WORD px, py;

   woerter();

   calc_slider( wo_slider, wo_slframe, 8, *anz, *top);
   draw_slider( h_woerterbuch, w_woerterbuch, WO_SLIDEFRAME);

   objc_offset( w_woerterbuch, WO_FRAME, &px, &py);
   if (dir == 0)
     nw_redraw( w, 0, (LONG) px, (LONG) py,
                (LONG) w_woerterbuch[WO_FRAME].ob_width,
                (LONG) w_woerterbuch[WO_FRAME].ob_height);
   else
     nw_move( w, 0, (LONG) px, (LONG) py,
             (LONG) w_woerterbuch[WO_FRAME].ob_width,
             (LONG) w_woerterbuch[WO_FRAME].ob_height, 0, phchar*dir, TRUE);
}

static void zeichne_orginal()
{
   WORD px, py;

   objc_offset( w_woerterbuch, WO_ORGINAL, &px, &py);
   nw_redraw( nw_searchwin( h_woerterbuch), 0, (LONG) px, (LONG) py-2,
              (LONG) w_woerterbuch[WO_ORGINAL].ob_width,
              (LONG) w_woerterbuch[WO_ORGINAL].ob_height+4);
}

static void zeichne_uebersetzung()
{
   WORD px, py;

   objc_offset( w_woerterbuch, WO_RAHMEN, &px, &py);
   nw_redraw( nw_searchwin( h_woerterbuch), 0, (LONG) px, (LONG) py,
              (LONG) w_woerterbuch[WO_RAHMEN].ob_width,
              (LONG) w_woerterbuch[WO_RAHMEN].ob_height);
}

static void suche_wort()
{
   register ENTRY *eintrag;
   register WORD *ein_nr;
   register WORD i;

   s_sprache = sprache;
   ein_nr = (WORD *) bsearch( orginal, *liste, *anz, sizeof(WORD),
                              comp_entries);

   if (ein_nr==NULL) /* Wort nicht gefunden */
   {
      *ueber[0] = *s_nicht_gefunden;
      for ( i=1; i<5; i++)
        *ueber[i] = leerstring;
   }
   else
   {
      eintrag = &entry[*ein_nr];

      if (eintrag->sprache == sprache)
        for ( i=0; i<eintrag->anzahl; i++)
          *ueber[i] = eintrag->ueber[i];
      else
        *ueber[0] = eintrag->orginal;
      for ( i=eintrag->anzahl; i<5; i++)
        *ueber[i] = leerstring;

      *top = _bsearch;
      if (*top+8 > *anz) *top = max( 0, *anz-8);
      loesche_state();
      wo_woerter[_bsearch-*top]->ob_state = SELECTED;
      zeichne( nw_searchwin( h_woerterbuch), 0);
   }

   zeichne_uebersetzung();
}

static void loesche_wort()
{
   register WORD *liste_2, *anz_2;
   register WORD ein_nr, liste_nr;
   register WORD i;
   WORD px, py;

   for ( i=0; i<8; i++)
     if (wo_woerter[i]->ob_state == SELECTED)
     {
        liste_nr = *top+i;
        ein_nr = (*liste)[liste_nr];
        wo_woerter[i]->ob_state = 0;
        break;
     }

   if (i == 8)
   {
      pling();
      return;
   }

   if (liste_nr+1 != *anz)
     lmemmove( &(*liste)[liste_nr], &(*liste)[liste_nr+1], (LONG) sizeof(WORD)*
               (*anz-liste_nr-1));
   (*anz)--;
   for ( i=0; i<*anz; i++)
     if ((*liste)[i]>ein_nr) (*liste)[i]--;

   if (sprache == ENGLISCH)
   {
      liste_2 = liste_d_e;
      anz_2 = &anz_d_e;
   }
   else
   {
      liste_2 = liste_e_d;
      anz_2 = &anz_e_d;
   }

   if (entry[ein_nr].anzahl == 1)
   {
      liste_nr = 0;
      while (liste_2[liste_nr] != ein_nr)
        liste_nr++;

      if (liste_nr+1 != *anz_2)
        lmemmove( &liste_2[liste_nr], &liste_2[liste_nr+1], (LONG) sizeof(WORD)*
                  (*anz_2-liste_nr-1));
      (*anz_2)--;
   }

   for ( i=0; i<*anz_2; i++)
     if (liste_2[i]>ein_nr) liste_2[i]--;

   if (ein_nr+1 != anz_entries)
     lmemmove( &entry[ein_nr], &entry[ein_nr+1], (LONG) sizeof(ENTRY)*
               (anz_entries-ein_nr-1));
   anz_entries--;

   if (*top+8 > *anz)
   {
      (*top)--;
      if (*top < 0)
      {
         *top = 0;
         wo_woerter[*anz]->ob_state = DISABLED;
      }
   }

   zeichne( nw_searchwin( h_woerterbuch), 0);

   itoa( anz_entries, wo_wortzahl->ob_spec, 10);
   objc_offset( w_woerterbuch, WO_WORTZAHL, &px, &py);
   nw_redraw( nw_searchwin( h_woerterbuch), 0, (LONG) px, (LONG) py,
              (LONG) wo_wortzahl->ob_width, (LONG) wo_wortzahl->ob_height);

   geaendert = TRUE;
}

/* ------- nach auûen sichtbare Prozeduren --------- */
void in_woerterbuch()
{
   register WORD i;

   sprache = selected( w_woerterbuch, WO_D_E);
   if (sprache == ENGLISCH)
   {
      anz = &anz_e_d;
      top = &top_e_d;
      liste = &liste_e_d;
   }
   else
   {
      anz = &anz_d_e;
      top = &top_d_e;
      liste = &liste_d_e;
   }

   wo_wortzahl = &w_woerterbuch[WO_WORTZAHL];
   wo_slider = &w_woerterbuch[WO_SLIDER];
   wo_slframe = &w_woerterbuch[WO_SLIDEFRAME];
   wo_slider->ob_height = wo_slframe->ob_height;
   wo_frame = &w_woerterbuch[WO_FRAME];

   for ( i=0; i<8; i++)
   {
      wo_woerter[i] = &w_woerterbuch[WO_WORT1+i];
      wo_woerter[i]->ob_spec = leerstring;
      wo_woerter[i]->ob_state = DISABLED;
   }

   *orginal = '\0';
   ((TEDINFO *) w_woerterbuch[WO_ORGINAL].ob_spec)->te_ptext = orginal;

   for ( i=0; i<5; i++)
   {
      ueber[i] = &w_woerterbuch[WO_UEBER1+i].ob_spec;
      *ueber[i] = leerstring;
   }
}

void b_woerterbuch( button)
register WORD button;
{
   register ENTRY *eintrag;
   register WORD i;

   if (button>=WO_WORT1 && button<=WO_WORT8)
   {
      eintrag = &entry[(*liste)[button-WO_WORT1+*top]];

      if (eintrag->sprache == sprache)
      {
         strcpy( ((TEDINFO *) w_woerterbuch[WO_ORGINAL].ob_spec)->te_ptext,
                 eintrag->orginal);
         for ( i=0; i<eintrag->anzahl; i++)
           *ueber[i] = eintrag->ueber[i];
      }
      else
      {
         strcpy( ((TEDINFO *) w_woerterbuch[WO_ORGINAL].ob_spec)->te_ptext,
                 eintrag->ueber[0]);
         *ueber[0] = eintrag->orginal;
      }
      for ( i=eintrag->anzahl; i<5; i++)
        *ueber[i] = leerstring;

      zeichne_orginal();
      zeichne_uebersetzung();
   }

   switch (button)
   {
      case 0 : /* Dialog schlieûen */
        nf_end( h_woerterbuch, TRUE);
        h_woerterbuch = 0;
        break;

      case WO_D_E : case WO_E_D :
        sprache = selected( w_woerterbuch, WO_D_E);
        if (sprache == ENGLISCH)
        {
           anz = &anz_e_d;
           top = &top_e_d;
           liste = &liste_e_d;
        }
        else
        {
           anz = &anz_d_e;
           top = &top_d_e;
           liste = &liste_d_e;
        }
        loesche_state();
        zeichne( nw_searchwin( h_woerterbuch), 0);
        break;

      case WO_SUCHE :
        suche_wort();
        sel_object( nw_searchwin( h_woerterbuch), w_woerterbuch, WO_SUCHE,
                    FALSE);
        break;

      case WO_UP :
        if (*top == 0) return;
        (*top)--;
        loesche_state();
        zeichne( nw_searchwin( h_woerterbuch), 0);
        break;

      case WO_DOWN :
        if (*anz-*top <= 8) return;
        (*top)++;
        loesche_state();
        zeichne( nw_searchwin( h_woerterbuch), 0);
        break;

      case WO_SLIDER :
        if (*anz <= 8) return;
        *top = move_slider( w_woerterbuch, WO_SLIDER, WO_SLIDEFRAME, 8,
                            *anz);
        loesche_state();
        zeichne( nw_searchwin( h_woerterbuch), 0);
        break;

      case WO_SLIDEFRAME :
        loesche_state();
        page_slider( nw_searchwin( h_woerterbuch), w_woerterbuch, WO_SLIDER,
                     top, 8, *anz, zeichne);
        break;

      case WO_LOESCHEN :
        loesche_wort();
        sel_object( nw_searchwin( h_woerterbuch), w_woerterbuch, WO_LOESCHEN,
                    FALSE);
        break;
   }
}

void woerter()
{
   register WORD i;
   register ENTRY *eintrag;

   for ( i=0; i<min( 8, *anz); i++)
   {
      eintrag = &entry[(*liste)[*top+i]];
      if (eintrag->sprache == sprache)
        wo_woerter[i]->ob_spec = eintrag->orginal;
      else
        wo_woerter[i]->ob_spec = eintrag->ueber[0];
   }

   for ( i=*anz; i<8; i++)
   {
      wo_woerter[i]->ob_spec = leerstring;
      wo_woerter[i]->ob_state = DISABLED;
   }
}