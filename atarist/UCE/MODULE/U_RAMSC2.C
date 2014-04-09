/* verschiedene Prozeduren und Funktionen */

#define UCE_RAMSCH2  1

#include <stdio.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

static WORD round32( len) /* len auf 32 aufrunden */
register WORD *len;
{
   *len += 32 - *len%32;
   if (*len > ZEILENBREITE) *len = ZEILENBREITE;

   return (*len + 6);
}

/* -------- nach aužen sichtbare Prozeduren ---------- */
char *make_line( len, maxlen)
/* neue Zeile erzeugen
   Aufbau einer Zeile:
     BYTE Flag, ob Zeiger gerundet wurde
     WORD Zeilenl„nge
     WORD maximale Zeilenl„nge
*/
register WORD len;
WORD maxlen;
{
   register char *zeile;
   register char round = 0;

   zeile = nalloc( round32( &maxlen));
   if (zeile == NULL) return NULL; /* kein Speicher mehr */
   if ((LONG) zeile%2 == 0) round = 1;
   zeile += round; /* auf ungerade Zahl runden */
   *(zeile++) = round;
   *((WORD *) zeile) = len;
   zeile += 2;
   *((WORD *) zeile) = maxlen-round;

   return zeile+2;
}

void free_line( zeile)
register char **zeile;
{
   nfree( *zeile-5-(*zeile)[-5], toword( (*zeile)[-2])+6+(*zeile)[-5]);
   *zeile = NULL;
}