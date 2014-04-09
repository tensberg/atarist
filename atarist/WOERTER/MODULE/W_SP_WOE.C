/* speichern der W”rterbuchdatei */

#include <stdio.h>
#include <gemfast.h>
#include <window.h>
#include <w_header.h>

WORD sp_woerter()
{
   register FILE *datei;
   register ENTRY *eintrag;
   register WORD fehler;
   register WORD i, j;

   datei = fopen( "WOERTER.DAT", "w");
   if (datei == NULL) return FILE_OPEN;

   eintrag = entry;

   for ( i=0; i<anz_entries; i++)
   {
      /* ENTRY schreiben */
      fputc( eintrag->score+'0', datei);
      fputc( eintrag->sprache+'0', datei);
      fputc( eintrag->anzahl+'0', datei);
      fputs( eintrag->orginal, datei);
      fputs( "\n", datei);
      for ( j=0; j<eintrag->anzahl; j++)
      {
         fputs( eintrag->ueber[j], datei);
         fputs( "\n", datei);
      }

      eintrag++;

      fehler = ferror( datei);
      if (fehler)
      {
         fclose( datei);
         return FILE_ERROR;
      }
   }

   fclose( datei);

   return NO_ERROR;
}