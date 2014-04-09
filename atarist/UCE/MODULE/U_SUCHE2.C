/* Unterroutinen fÅrs Suchen */

#define UCE_SUCHEN2  1

#include <stdio.h>
#include <macros.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

#define GROSS_KLEIN  1

/* globale Variablen */
static char *text; /* Suchtext */
static WORD laenge; /* LÑnge des Suchtextes */

static WORD suche_gk( zeile)
/* Suchen mit Beachtung der Groû/Kleinschreibung */
register char *zeile;
{
   register char *pos, *ende;
   register char zeichen;
   register WORD i = 0, j;

   pos = zeile;
   ende = pos+toword( pos[-4])-laenge;
   zeichen = *text;

   while (ende > pos)
   {
      if (*pos == zeichen) /* erstes Zeichen stimmt Åberein */
      {
         /* restliche Zeichen untersuchen */
         for ( j=1; j<laenge; j++)
           if (pos[j] != text[j])
             break; /* nicht identisch */

         if (j == laenge) /* gefunden */
           return i;
      }
      pos++;
      i++;
   }

   return -1;
}

static WORD suche( zeile)
/* Suchen ohne Beachtung der Groû/Kleinschreibung */
register char *zeile;
{
   register char *pos, *ende;
   register char zeichen;
   register WORD i = 0, j;

   pos = zeile;
   ende = pos+toword( pos[-4])-laenge;
   zeichen = tolower( *text);

   while (ende > pos)
   {
      if (tolower( *pos) == zeichen) /* erstes Zeichen stimmt Åberein */
      {
         /* restliche Zeichen untersuchen */
         for ( j=1; j<laenge; j++)
           if (tolower( pos[j]) != tolower( text[j]))
             break; /* nicht identisch */

         if (j == laenge) /* gefunden */
           return i;
      }
      pos++;
      i++;
   }

   return -1;
}

/* ----- nach auûen sichtbare Funktionen ------ */
void suche_text( qt, suchtext, e_zeile, l_zeile, e_spalte, l_spalte,
                 zeile, spalte, modus)
register QUELLTEXT *qt;
register char *suchtext;
register LONG e_zeile, l_zeile;
register WORD e_spalte, l_spalte;
register LONG *zeile;
register WORD *spalte;
register WORD modus;
{
   register char **zeilen;
   register LONG i;

   text = suchtext;
   laenge = strlen( suchtext);

   zeilen = &qt->zeile[e_zeile];
   i = e_zeile;

   if (modus & GROSS_KLEIN)
     if (e_zeile >= l_zeile) /* abwÑrts suchen */
       do
         *spalte = suche_gk( *zeilen++);
       while (i++<l_zeile && *spalte==-1);
     else /* aufwÑrts suchen */
       do
         *spalte = suche_gk( *zeilen--);
       while (i-->l_zeile && *spalte==-1);
   else
     if (e_zeile >= l_zeile) /* abwÑrts suchen */
       do
         *spalte = suche( *zeilen++);
       while (i++<l_zeile && *spalte==-1);
     else /* aufwÑrts suchen */
       do
         *spalte = suche( *zeilen--);
       while (i-->l_zeile && *spalte==-1);

   if (*spalte == -1)
     *zeile = -1;
   else
     if (e_zeile <= l_zeile)
       *zeile = i-1;
     else
       *zeile = i+1;
}