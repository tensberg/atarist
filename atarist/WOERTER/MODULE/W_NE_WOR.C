/* neues Wort-Dialogbearbeitung */

#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <gemfast.h>
#include <window.h>
#include <w_header.h>

#define min(x,y)    (((x)<(y))?(x):(y))

/* externe Prozeduren */
extern WORD selected();
extern WORD comp_entries();

/* globale Variablen */
static char *leerstring = "";
static char orginal[31];
static char ueber[5][31];
static OBJECT *ne_wortzahl;
static WORD sprache;
extern WORD h_neues_wort;
extern WORD h_woerterbuch;
extern WORD _bsearch;
extern OBJECT *wo_wortzahl;
extern OBJECT *wo_slider, *wo_slframe;
extern OBJECT *wo_woerter[];
extern WORD top_d_e, top_e_d;

static void search_pos( pos_1, pos_2, anz_ueber, ueber_stat)
register WORD *pos_1, *pos_2;
register WORD anz_ueber, ueber_stat;
{
   register char *zeiger;
   register WORD ueber_num; /* Nummer des ersten šbersetzungseintrages */

   s_sprache = sprache;
   if (sprache == ENGLISCH)
     zeiger = bsearch( orginal, liste_e_d, anz_e_d, sizeof (WORD),
                       comp_entries);
   else
     zeiger = bsearch( orginal, liste_d_e, anz_d_e, sizeof (WORD),
                       comp_entries);

   if (zeiger != NULL) /* Eintrag schon vorhanden */
   {
      *pos_1 = -2;
      pling();
      return;
   }

   *pos_1 = _bsearch;

   if (anz_ueber == 1)
   {
      ueber_num = 0;
      while (!(ueber_stat & 1<<ueber_num))
        ueber_num++;

      s_sprache = !sprache;
      if (sprache == ENGLISCH)
        zeiger = bsearch( ueber[ueber_num], liste_d_e, anz_d_e,
                          sizeof (WORD), comp_entries);
      else
        zeiger = bsearch( ueber[ueber_num], liste_e_d, anz_e_d,
                          sizeof (WORD), comp_entries);

      if (zeiger != NULL)
      {
         *pos_2  = -2;
         pling();
         return;
      }

      *pos_2 = _bsearch;
   }
}

static void insert_entries( eintrag, pos_1, pos_2, anz_ueber)
register ENTRY *eintrag;
register WORD pos_1, pos_2, anz_ueber;
{
   WORD **liste;
   WORD *anz, *max;

   to_language( sprache, &liste, &anz, &max);
   ins_index( liste, anz, max, pos_1, anz_entries);

   if (anz_ueber == 1)
   {
      to_language( !sprache, &liste, &anz, &max);
      ins_index( liste, anz, max, pos_2, anz_entries);
   }
}

static void ins_word( pos_1, pos_2, anz_ueber)
register WORD pos_1, pos_2;
register WORD anz_ueber;
{
   register ENTRY *eintrag;
   register WORD wo_sprache;
   register WORD *liste, anz, pos, top;
   register WORD i;
   WORD px, py;

   wo_sprache = selected( w_woerterbuch, WO_D_E);
   if (wo_sprache!=sprache && anz_ueber!=1) return;

   if (wo_sprache == ENGLISCH)
   {
      liste = liste_e_d;
      anz = anz_e_d;
      top = top_e_d;
   }
   else
   {
      liste = liste_d_e;
      anz = anz_d_e;
      top = top_d_e;
   }

   pos = ((sprache==wo_sprache) ? pos_1 : pos_2)-top;
   if (pos<0 || pos>7) return;

   for ( i=pos; i<min( 8, anz); i++)
   {
      eintrag = &entry[liste[i+top]];
      if (eintrag->sprache == wo_sprache)
        wo_woerter[i]->ob_spec = eintrag->orginal;
      else
        wo_woerter[i]->ob_spec = eintrag->ueber[0];
      wo_woerter[i]->ob_state = 0;
   }

   calc_slider( wo_slider, wo_slframe, 8, anz, top);
   if (h_woerterbuch != 0)
   {
      draw_slider( h_woerterbuch, w_woerterbuch, WO_SLIDEFRAME);

      objc_offset( w_woerterbuch, WO_FRAME, &px, &py);
      nw_redraw( nw_searchwin( h_woerterbuch), 0, (LONG) px, (LONG) py,
                 (LONG) w_woerterbuch[WO_FRAME].ob_width,
                 (LONG) w_woerterbuch[WO_FRAME].ob_height);
   }
}

static void neues_wort()
{
   register WORD anz_ueber = 0; /* Anzahl der šbersetzungen */
   register WORD ueber_stat = 0; /* Bitfeld mit šbersetzungszeilenstatus */
   WORD pos_1 = 0, pos_2 = 0;
   register WORD laenge;
   register WORD i, j;
   register ENTRY *eintrag;
   WORD px, py; /* Redraw-Koordinaten */

   if (anz_entries == max_entries) more_entries();
   eintrag = &entry[anz_entries];

   if (strcmp( orginal, leerstring) == 0)
   {
      pling();
      return;
   }

   /* šbersetzungszeilen finden */
   for ( i=0; i<5; i++)
   {
      if (strcmp( ueber[i], leerstring) != 0)
      {
         anz_ueber++;
         ueber_stat |= 1<<i;
      }
   }

   if (anz_ueber == 0) /* kein šbersetzungseintrag gefunden */
   {
      pling();
      return;
   }

   /* Position suchen, an der Eintrag eingefgt wird */
   search_pos( &pos_1, &pos_2, anz_ueber, ueber_stat);
   if (pos_1++==-2 || pos_2++==-2) return;

   /* Eintrag mit Wertern besetzen */
   eintrag->score = 0;
   eintrag->sprache = sprache;
   eintrag->anzahl = anz_ueber;
   strcpy( eintrag->orginal, orginal);

   /* šbersetzungszeilen mit Inhalt kopieren */
   j = 0;
   for ( i=0; i<anz_ueber; i++)
     if (ueber_stat & 1<<i) strcpy( eintrag->ueber[j++], ueber[i]);

   /* Eintrag in Listen einsetzen */
   insert_entries( eintrag, pos_1, pos_2, anz_ueber);
   ins_word( pos_1, pos_2, anz_ueber);

   anz_entries++;
   itoa( anz_entries, ne_wortzahl->ob_spec, 10);

   objc_offset( w_neues_wort, NE_WORTZAHL, &px, &py);
   nw_redraw( nw_searchwin( h_neues_wort), 0, (LONG) px, (LONG) py,
              (LONG) ne_wortzahl->ob_width, (LONG) ne_wortzahl->ob_height);

   if (h_woerterbuch != 0)
   {
      objc_offset( w_woerterbuch, WO_WORTZAHL, &px, &py);
      nw_redraw( nw_searchwin( h_woerterbuch), 0, (LONG) px, (LONG) py,
                 (LONG) wo_wortzahl->ob_width, (LONG) wo_wortzahl->ob_height);
   }

   geaendert = TRUE;
}

/* -------- nach aužen sichtbare Prozeduren --------- */
void in_neues_wort()
{
   register WORD i;

   sprache = selected( w_neues_wort, NE_D_E);
   ne_wortzahl = &w_neues_wort[NE_WORTZAHL];
   ne_wortzahl->ob_spec = wo_wortzahl->ob_spec;
   *orginal = '\0';
   ((TEDINFO *) w_neues_wort[NE_ORGINAL].ob_spec)->te_ptext = orginal;
   for ( i=0; i<5; i++)
   {
      *ueber[i] = '\0';
      ((TEDINFO *) w_neues_wort[NE_UEBER1+i].ob_spec)->te_ptext = ueber[i];
   }
}

void b_neues_wort( button)
register WORD button;
{
   switch (button)
   {
      case 0 : /* Dialog schliežen */
        nf_end( h_neues_wort, TRUE);
        h_neues_wort = 0;
        break;

      case NE_D_E : case NE_E_D :
        sprache = selected( w_neues_wort, NE_D_E);
        break;

      case NE_AUFNEHMEN : /* neues Wort in Liste aufnehmen */
        neues_wort();
        sel_object( nw_searchwin( h_neues_wort), w_neues_wort, button,
                    FALSE);
        break;
   }
}