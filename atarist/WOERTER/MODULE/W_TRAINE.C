/* DurchfÅhrung des Trainer-Dialoges */

#include <stdio.h>
#include <macros.h>
#include <gemfast.h>
#include <window.h>
#include <w_header.h>

/* globale Variablen */
static char **suchwort;
static char *antwort;
static WORD sprache, m_sprache;
static char *prozent = 0;
static WORD versuche = 0, korrekt = 0;
static WORD fragewort = -1;
static LONG *schnitt, schn_d_e = 0, schn_e_d = 0;
extern WORD h_trainer;

static WORD which_speech()
{
   if (selected( w_trainer, TR_E_D))
     return 0; /* Sprache Englisch */
   else
     if (selected( w_trainer, TR_D_E))
       return 1; /* Sprache Deutsch */
     else
       return 2; /* gemischt */
}

static void rechne_schnitt()
{
   register WORD i;

   for ( i=0; i<anz_d_e; i++)
     schn_d_e += entry[liste_d_e[i]].score;

   for ( i=0; i<anz_e_d; i++)
     schn_e_d += entry[liste_e_d[i]].score;
}

static void new_word() /* neues Suchwort */
{
   register ENTRY *eintrag;
   register WORD *liste, anz;
   register WORD durchschnitt;
   register WORD ok;
   register WORD zahl;

   if (sprache == 2)
     m_sprache = rand() % 2; /* Sprache zufÑllig auswÑhlen */
   else
     m_sprache = sprache;

   if (m_sprache == ENGLISCH)
   {
      liste = liste_e_d;
      anz = anz_e_d;
      schnitt = &schn_e_d;
   }
   else
   {
      liste = liste_d_e;
      anz = anz_d_e;
      schnitt = &schn_d_e;
   }

   if (anz == 0) return;

   durchschnitt = *schnitt/anz;

   zahl = rand()%anz-1;
   do
   {
      if (++zahl == anz) zahl = 0;
      fragewort = liste[zahl]; /* Eintrag zufÑllig ermitteln */
      eintrag = &entry[fragewort];
      ok = max( eintrag->score-durchschnitt, 0);
      if (ok > 0)
        ok *= rand()%(ok*3+10);
   } while (ok > 0);

   if (eintrag->sprache == m_sprache)
     *suchwort = eintrag->orginal;
   else
     *suchwort = eintrag->ueber[0];
}

void untersuche_antwort()
{
   register ENTRY *eintrag;
   register WORD richtig = FALSE;
   register WORD newscore, proz, laenge;
   register WORD i;
   WORD px, py;

   eintrag = &entry[fragewort];

   if (eintrag->sprache == m_sprache)
   {
      for ( i=0; i<eintrag->anzahl; i++)
        if (strcmp( antwort, eintrag->ueber[i]) == 0)
        {
           richtig = TRUE;
           break;
        }
   }
   else
      if (strcmp( antwort, eintrag->orginal) == 0)
        richtig = TRUE;

   if (richtig)
   {
      korrekt++;
      newscore = min( eintrag->score+3, 100);
      *antwort = '\0';
      objc_offset( w_trainer, TR_RAHMEN2, &px, &py);
      nw_redraw( nw_searchwin( h_trainer), 0, (LONG) px, (LONG) py,
                 (LONG) w_trainer[TR_RAHMEN2].ob_width,
                 (LONG) w_trainer[TR_RAHMEN2].ob_height);
   }
   else
   {
      pling();
      newscore = max( eintrag->score-1, 0);
   }

   *schnitt += newscore-eintrag->score;
   eintrag->score = newscore;

   proz = korrekt*100l/++versuche;
   itoa( proz, prozent, 10);
   laenge = 3-strlen( prozent);
   stradj( prozent, laenge);
   for ( i=0; i<laenge; i++)
     prozent[i] = ' ';
   objc_offset( w_trainer, TR_PROZENT, &px, &py);
   nw_redraw( nw_searchwin( h_trainer), 0, (LONG) px, (LONG) py,
              (LONG) w_trainer[TR_PROZENT].ob_width,
              (LONG) w_trainer[TR_PROZENT].ob_height);

   geaendert = TRUE;

   new_word();
   objc_offset( w_trainer, TR_RAHMEN, &px, &py);
   nw_redraw( nw_searchwin( h_trainer), 0, (LONG) px, (LONG) py,
              (LONG) w_trainer[TR_RAHMEN].ob_width,
              (LONG) w_trainer[TR_RAHMEN].ob_height);
}

/* ------- nach auûen sichtbare Prozeduren -------- */
void in_trainer()
{
   suchwort = &w_trainer[TR_SUCHWORT].ob_spec;
   antwort = ((TEDINFO *) w_trainer[TR_ANTWORT].ob_spec)->te_ptext;
   sprache = which_speech();
   prozent = w_trainer[TR_PROZENT].ob_spec;
   strcpy( prozent, "  0");

   rechne_schnitt();
   new_word();
}

void b_trainer( button)
register WORD button;
{
   switch (button)
   {
      case 0 : /* Dialog schlieûen */
        nf_end( h_trainer, TRUE);
        h_trainer = 0;
        break;

      case TR_D_E : case TR_E_D : case TR_GEMISCHT :
        sprache = which_speech();
        break;

      case TR_OK :
        untersuche_antwort();
        sel_object( nw_searchwin( h_trainer), w_trainer, button, FALSE);
        break;
   }
}