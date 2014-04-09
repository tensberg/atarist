/* Prozeduren zur Textbearbeitung zum dritten */

#define UCE_TEXT3  1

#include <stdio.h>
#include <malloc.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

WORD t_ins_line( qt, pos, anz, maxlen) /* Zeilen einfgen */
register QUELLTEXT *qt;
register LONG pos;
register WORD anz, maxlen;
{
   register char *speicher;
   register LONG i;

   if (maxlen == 0) maxlen = 1;

   if (qt->zeilenzahl+anz > qt->max_zeilen)
   {
      speicher = realloc( qt->zeile, (WORD) (sizeof(char *)*
                          (qt->max_zeilen+500)));
      if (speicher == NULL) return NO_MEMORY;
      qt->zeile = (char **) speicher;
      qt->max_zeilen += 500;
   }

   /* Zeilenadressen verschieben */
   if (pos != qt->zeilenzahl)
     lmemmove( &qt->zeile[pos+anz], &qt->zeile[pos],
               sizeof(char *)*(qt->zeilenzahl-pos));

   for ( i=pos; i<pos+anz; i++)
   {
      qt->zeile[i] = make_line( 0, maxlen);
      if (qt->zeile[i] == NULL) break;
      *qt->zeile[i] = '\0';
   }

   if (i<pos+anz) /* nicht genug Speicher */
   {
      /* Speicher wieder freigeben */
      for ( ; i>=pos; i--)
        free_line( &qt->zeile[i]);

      /* Zeilenadressen zurckkopieren */
      if (pos != qt->zeilenzahl)
        lmemmove( &qt->zeile[pos], &qt->zeile[pos+anz],
                  sizeof(char *)*(qt->zeilenzahl-pos));

      return NO_MEMORY;
   }

   qt->zeilenzahl += anz;
   nw_nsize( &qt->w, W_INTERIOR, (LONG) (ZEILENBREITE+1)*pwchar,
             qt->zeilenzahl*phchar);

   return NO_ERROR;
}

void t_del_line( qt, pos, anz) /* Zeilen l”schen */
register QUELLTEXT *qt;
register LONG pos;
register WORD anz;
{
   register LONG i;

   /* Zeilenspeicher freigeben */
   for ( i=pos; i<pos+anz; i++)
     free_line( &qt->zeile[i]);

   /* Zeilenadressen verschieben */
   if (pos+anz != qt->zeilenzahl)
     lmemmove( &qt->zeile[pos], &qt->zeile[pos+anz],
               sizeof(char *)*(qt->zeilenzahl-pos-anz));

   qt->zeilenzahl -= anz;
   nw_nsize( &qt->w, W_INTERIOR, (LONG) (ZEILENBREITE+1)*pwchar,
             qt->zeilenzahl*phchar);
   qt->o_zeile = qt->w.ry/phchar;
}

WORD t_enl_line( zeile, len)
register char **zeile;
register WORD len;
{
   register char *speicher;

   /* neue Zeile erzeugen */
   speicher = make_line( toword( (*zeile)[-4]), len);
   if (speicher == NULL) return NO_MEMORY;
   /* String an neue Adresse kopieren */
   strcpy( speicher, *zeile);
   /* alten Speicher freigeben */
   free_line( zeile);
   *zeile = speicher;
}