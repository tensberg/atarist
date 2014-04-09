/* Funktionen, die beim Anw„hlen von Eintr„gen im Dateimenue ausgel”st
   werden */

#define UCE_DATEIMENUE  1

#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

void m_neu_anlegen()
{
   t_cr_text( "", "NAMENLOS");
   t_open_text( anz_texte-1);
}

void m_oeffnen()
{
   WORD status;
   WORD button;
   WORD pos;

   strcat( pfad, "*.*"); /* Suchmaske anh„ngen */

   status = fsel_exinput( pfad, name, &button, *s_d_oeffnen);

   redraw(); /* Redraw-Meldungen abwarten */

   /* Suchmaske wieder abschneiden */
   pos = strrpos( pfad, '\\'); /* letztes Auftreten des Zeichens im String */
   if (pos != -1) /* Zeichen gefunden */
     pfad[pos+1] = '\0';

   if (status == 0) return;
   if (button == 0) return; /* Es wurde er Abbruch-Button gedrckt */

   t_cr_text( pfad, name);
   t_load_text( anz_texte-1);
   t_open_text( anz_texte-1);
}

void m_si_unter()
{
   WORD status;
   WORD button;
   WORD pos;
   register char *filename;

   strcat( pfad, "*.*"); /* Suchmaske anh„ngen */

   status = fsel_exinput( pfad, name, &button, *s_d_si_unter);

   redraw(); /* Redraw-Meldungen abwarten */

   /* Suchmaske wieder abschneiden */
   pos = strrpos( pfad, '\\'); /* letztes Auftreten des Zeichens im String */
   if (pos != -1) /* Zeichen gefunden */
     pfad[pos+1] = '\0';

   if (status == 0) return;
   if (button == 0) return; /* Es wurde der Abbruch-Button gedrckt */

   /* Dateinamen zusammensetzen */
   filename = malloc( strlen( pfad)+strlen( name)+1);
   strcpy( filename, pfad);
   strcat( filename, name);

   /* berprfen ob Datei schon vorhanden ist */
   status = access( filename, 0);
   if (status) /* Datei vorhanden */
   {
      button = nmf_do( d_da_vorhanden, 0, ei_mausposition, FALSE,
                       ei_growshrink);
      if (button == VO_ABBRUCH) return;
      redraw();
   }

   free( a_qt->q_pfad);
   a_qt->q_pfad = strdup( pfad);
   free( a_qt->q_name);
   a_qt->q_name = strdup( name);

   da_newname( a_qt->q_nummer);
   nw_nname( &a_qt->w, filename);
   if (a_qt->geaendert)
   {
      a_qt->geaendert = FALSE;
      info_changed = TRUE;
   }
   free( filename);

   t_save_text( a_qt->q_nummer);
}

void m_sichern()
{
   if (!a_qt->geaendert) return; /* Datei wurde nicht geaendert */

   if (strcmp( a_qt->q_name, "NAMENLOS") == 0) /* Datei hat keinen Namen */
   {
      m_si_unter();
      return;
   }

   t_save_text( a_qt->q_nummer);
}

void m_schliessen()
{
   WORD top, dummy;

   t_close_text( a_qt->q_nummer);
   t_del_text( a_qt->q_nummer);

   wind_get( 0, WF_TOP, &top, &dummy, &dummy, &dummy);
   a_qt = t_find_qt( top);
   if (a_qt != NULL)
   {
      cur_x = a_qt->cursor_spalte*pwchar;
      cur_y = a_qt->cursor_zeile*phchar;
   }
   info_changed = FALSE;
}