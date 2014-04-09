/* laden der W”rterbuchdatei */

#include <stdio.h>
#include <gemfast.h>
#include <window.h>
#include <w_header.h>

#define  min(x,y)    (((x)<(y))?(x):(y))

extern WORD comp_entries();
extern WORD _bsearch;
extern WORD h_neues_wort;
extern OBJECT *wo_wortzahl;
extern OBJECT *wo_slider, *wo_slframe;
extern OBJECT *wo_woerter[];

static void ins_liste( eintrag)
register ENTRY *eintrag;
{
   WORD **liste;
   WORD *anz, *max;

   s_sprache = eintrag->sprache;
   to_language( eintrag->sprache, &liste, &anz, &max);
   bsearch( eintrag->orginal, *liste, *anz, sizeof(WORD), comp_entries);
   ins_index( liste, anz, max, _bsearch+1, anz_entries);

   if (eintrag->anzahl == 1)
   {
      s_sprache = !eintrag->sprache;
      to_language( !eintrag->sprache, &liste, &anz, &max);
      bsearch( eintrag->ueber[0], *liste, *anz, sizeof(WORD), comp_entries);
      ins_index( liste, anz, max, _bsearch+1, anz_entries);
   }

}

static void enter_words()
{
   register ENTRY *eintrag;
   register WORD *liste;
   register WORD anz;
   register WORD sprache;
   register WORD i;

   sprache = selected( w_woerterbuch, WO_D_E);

   if (sprache == ENGLISCH)
   {
      liste = liste_e_d;
      anz = anz_e_d;
   }
   else
   {
      liste = liste_d_e;
      anz = anz_d_e;
   }

   for ( i=0; i<min( 8, anz); i++)
   {
      eintrag = &entry[liste[i]];
      if (sprache == eintrag->sprache)
        wo_woerter[i]->ob_spec = eintrag->orginal;
      else
        wo_woerter[i]->ob_spec = eintrag->ueber[0];
      wo_woerter[i]->ob_state = 0;
   }
}

/* -------- nach aužen sichtbare Prozeduren --------- */
WORD ld_woerter()
{
   register FILE *datei;
   register ENTRY *eintrag;
   register LONG schnitt = 0;
   register char ende;
   register WORD fehler, laenge;
   register WORD i;
   WORD px, py;

   datei = fopen( "WOERTER.DAT", "r");
   if (datei == NULL) return NO_ERROR;

   while (ende != EOF)
   {
      if (anz_entries == max_entries)
      {
         fehler = more_entries();
         if (fehler) return fehler;
      }

      /* Daten lesen */
      eintrag = &entry[anz_entries];
      eintrag->score = fgetc( datei)-'0';
      schnitt += eintrag->score;
      eintrag->sprache = fgetc( datei)-'0';
      eintrag->anzahl = fgetc( datei)-'0';
      /* Orginal lesen */
      fgets( eintrag->orginal, 32, datei);
      eintrag->orginal[strlen( eintrag->orginal)-1] = '\0';
      /* šbersetzungen lesen */
      for ( i=0; i<eintrag->anzahl; i++)
      {
         fgets( eintrag->ueber[i], 32, datei);
         eintrag->ueber[i][strlen( eintrag->ueber[i])-1] = '\0';
      }

      ins_liste( eintrag); /* Eintrag in Suchlisten einfgen */

      anz_entries++;

      ende = fgetc( datei);
      if (ende != EOF) fungetc( ende, datei);
   }

   fclose( datei);
   durchschnitt = schnitt/anz_entries;

   enter_words();

   itoa( anz_entries, wo_wortzahl->ob_spec, 10);
   for ( i=0; i<laenge; i++)
     wo_wortzahl->ob_spec[i] = ' ';

   calc_slider( wo_slider, wo_slframe, 8, anz_entries, 0);

   return NO_ERROR;
}