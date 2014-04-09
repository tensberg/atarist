/* Vergleichsprozedur fr bsearch() */

#include <stdio.h>
#include <string.h>
#include <gemfast.h>
#include <window.h>
#include <w_header.h>

/* globale Variablen */
WORD s_sprache; /* Suchsprache */

WORD comp_entries( ein_nr, wort)
register WORD *ein_nr;
register char *wort;
{
   register ENTRY *eintrag;

   eintrag = &entry[*ein_nr];
   if (eintrag->sprache == s_sprache)
     return -stricmp( wort, eintrag->orginal);
   else
     return -stricmp( wort, eintrag->ueber[0]);
}