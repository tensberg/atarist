/* Prozeduren zur Textbearbeitung */

#define UCE_TEXT2

#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

/* globale Variablen */
static FILE *datei;

static WORD readline( lineaddr) /* Zeile lesen */
register char **lineaddr;
{
   static char z_buffer[ZEILENBREITE+1]; /* Zeilenpuffer */
   WORD bytes_read; /* gelesene Zeichen */
   register WORD len; /* ZeilenlÑnge */
   WORD maxlen;

   fgets( z_buffer, ZEILENBREITE+1, datei); /* Zeile lesen */

   bytes_read = len = strlen( z_buffer);
   if (z_buffer[len-1] == '\n') /* 'nl'-Zeichen lîschen */
     z_buffer[--len] = '\0';

   maxlen = len;
   if (*lineaddr == NULL) /* Speicher fÅr Zeile allozieren */
   {
      *lineaddr = make_line( len, maxlen);
      if (*lineaddr == NULL) return -1; /* Speicher alle */
   }
   else /* prÅfen, ob Zeilenspeicher groû genug ist */
     if (toword( (*lineaddr)[-2]) < len) /* Speicher vergrîûern */
     {
        /* Speicher freigeben */
        free_line( lineaddr);
        /* neuen Speicher allozieren */
        *lineaddr = make_line( len, maxlen);
        if (*lineaddr == NULL) return -1; /* Speicher alle */
     }
     else
       toword( (*lineaddr)[-4]) = len;

   /* String kopieren */
   strcpy( *lineaddr, z_buffer);

   return bytes_read;
}

static void break_load( datei)
FILE *datei;
{
   fclose( datei);
   cl_dauer();
}

/* --------- nach auûen sichtbare Funktionen --------- */
WORD t_load_text( t_handle)
register WORD t_handle;
{
   register QUELLTEXT *qt;
   register WINDOW *qw;
   char *filename;
   register ULONG i=0, j=0; /* ZeilenzÑhler */
   char *temp;
   register LONG dat_size, dat_read = 0;
   register LONG bytes_read; /* Anzahl gelesener Zeichen */

   qt = &textfeld[t_handle];
   qw = &qt->w;

   /* Filenamen zusammensetzen */
   filename = malloc( strlen(qt->q_pfad)+strlen(qt->q_name)+1);
   if (filename == NULL) return NO_MEMORY;
   strcpy( filename, qt->q_pfad);
   strcat( filename, qt->q_name);

   /* Datei zum Lesen îffnen */
   dat_size = fsize( filename);
   datei = fopen( filename, "r");
   if (datei == NULL) return CANT_OPEN_FILE;

   op_dauer( *s_t_laden, qt->q_name); /* Dauer-Dialog îffnen */

   /* Zeilen lesen */
   while (!feof( datei))
   {
      if (i == qt->max_zeilen) /* Feld mit Zeilenzeigern vergrîûern */
      {
         temp = realloc( qt->zeile, (WORD) (sizeof(char *)*
                                            (qt->max_zeilen+500)));
         if (temp == NULL) /* Speicher alle */
         {
            break_load( datei);
            return NO_MEMORY;
         }
         qt->zeile = (char **) temp;
         qt->max_zeilen += 500;
         for ( j=i; j<qt->max_zeilen; j++)
           qt->zeile[j] = NULL; /* Zeile hat keinen Inhalt */
      }

      /* Zeile lesen */
      bytes_read = readline( &qt->zeile[i]); /* Zeile lesen */
      if (bytes_read == -1) /* Fehler beim Zeilenlesen */
      {
         break_load( datei); /* Laden abbrechen */
         return NO_MEMORY;
      }
      dat_read += bytes_read;

      if (++i%15 == 0) /* alle 15 Zeilen Dauer-Dialog aktualisieren */
        up_dauer( dat_read, dat_size);
   } /* while */

   fclose( datei);

   /* Dauer-Dialog beenden */
   up_dauer( dat_size, dat_size);
   cl_dauer();

   qt->zeilenzahl = i;
   qt->cursor_an = TRUE;
   qt->cursor_zeile = qt->cursor_spalte = 0;
   qt->bstart_zeile = 0;
   for ( j=0; j<5; j++)
     qt->marke[j] = 0;
   qw->rx = qw->ry = 0;
   qw->rh = i*phchar;

   return NO_ERROR;
}

WORD t_save_text( t_handle)
register WORD t_handle;
{
   register QUELLTEXT *qt;
   register char *filename;
   register char **zeile;
   register LONG i;

   qt = &textfeld[t_handle];

   /* Filenamen zusammensetzen */
   filename = malloc( strlen(qt->q_pfad)+strlen(qt->q_name)+1);
   if (filename == NULL) return NO_MEMORY;
   strcpy( filename, qt->q_pfad);
   strcat( filename, qt->q_name);

   /* Datei zum Schreiben îffnen */
   datei = fopen( filename, "w");
   if (datei == NULL) return CANT_OPEN_FILE;

   op_dauer( *s_t_sichern, qt->q_name);

   zeile = qt->zeile;
   fputs( *zeile++, datei); /* Zeile schreiben */
   for ( i=1; i<qt->zeilenzahl; i++)
   {
      fputs( "\n", datei); /* newline anhÑngen */
      fputs( *zeile++, datei); /* Zeile schreiben */
      if (ferror( datei)) /* ein Fehler ist beim Schreiben aufgetreten */
      {
         fclose( datei);
         cl_dauer();
         return WRITE_ERROR;
      }

      if (i%15 == 0) /* alle 15 Zeilen Dauer-Dialog aktualisieren */
        up_dauer( i, qt->zeilenzahl);
   }

   up_dauer( qt->zeilenzahl, qt->zeilenzahl);
   cl_dauer();
   fclose( datei);
   qt->geaendert = FALSE;
   info_changed = TRUE;
   da_chkentry( t_handle);

   return NO_ERROR;
}