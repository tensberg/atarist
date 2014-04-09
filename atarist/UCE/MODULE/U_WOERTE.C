/* die Wîrterbuch-Routinen */

#define UCE_WOERTERBUCH  1
#define BIT15  0x8000

#include <stdio.h>
#include <macros.h>
#include <malloc.h>
#include <string.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

extern WORD h_woerter;

/* globale Variablen */
       WORD wo_resident; /* Flag, ob Wîrterbuchdatei im Speicher gehalten
                          werden soll */
static char **ind_entries = NULL; /* EintrÑge im Index */
static WORD anz_index = 0; /* Anzahl der EintrÑge im Index */
static WORD max_index = 0;
static char **woerterdatei = NULL; /* geladene Wîrterbuchdatei */
static WORD anz_wlin = 0; /* Anzahl Zeilen in woerterdatei */
static WORD max_wlin = 0;
static char **text = NULL; /* angezeigter Text */
static WORD anz_tlin = 0; /* Anzahl Zeilen in text */
static WORD max_tlin = 0;
static WORD top_lin = 0; /* oberste angezeigte Zeile */
static char filename[255]; /* Name der Wîrterbuchdatei */
static char leerstring[] = { '\0' };
static char **wo_eintraege[8];
static char *suchwort;
static OBJECT *slider;
static OBJECT *slideframe;
static OBJECT *textback;
static FILE *datei = NULL; /* Wîrterbuchdatei */

static char *close( datei) /* Datei schlieûen und Pointer nullen */
register FILE **datei;
{
   fclose( *datei);
   *datei = NULL;
}

static char *getline() /* liest eine Zeile aus der Wîrterbuchdatei */
{
   static char zeile[61];
   register WORD len;

   if (datei == NULL)
   {
      datei = fopen( filename, "r");
      if (datei == NULL) return NULL;
   }

   do
   {
      if (feof( datei)) /* Datei schlieûen */
      {
         close( &datei);
         return NULL;
      }
      else
      {
         /* Zeile lesen */
         fgets( zeile, 61, datei);

         /* newline lîschen */
         len = strlen( zeile);
         if (zeile[--len] == '\n') zeile[len] = '\0';

         /* Leerzeichen an Anfang und Ende lîschen */
         strtrim( zeile, " ");
      }
   } while (strlen( zeile) == 0); /* Leerzeilen Åberspringen */

   return zeile;
}

static WORD load_hlp() /* Wîrterbuch laden */
{
   register char *zeile;
   register char *speicher;
   register LONG bytes_read = 0; /* Anzahl gelesener Bytes */
   register LONG dat_len; /* DateilÑnge der Wîrterbuchdatei */

   dat_len = fsize( filename);
   if (dat_len == -1) return CANT_OPEN_WOERTER;

   zeile = getline();
   if (zeile == NULL) return CANT_OPEN_WOERTER;
   op_dauer( *s_wo_laden, "");

   while (zeile != NULL)
   {
      bytes_read += strlen( zeile);
      if (anz_wlin%10 == 0)
        up_dauer( bytes_read, dat_len);

      if (anz_wlin == max_wlin)
      {
         speicher = realloc( woerterdatei, sizeof(char *)*(max_wlin+50));
         if (speicher == NULL)
         {
            close( &datei);
            cl_dauer();
            return NO_MEMORY;
         }
         woerterdatei = (char **) speicher;
         max_wlin += 50;
      }

      if (*zeile != '!') /* keine Kommentarzeile */
      {
         woerterdatei[anz_wlin] = nalloc( 61);
         if (woerterdatei[anz_wlin] == NULL)
         {
            close( &datei);
            cl_dauer();
            return NO_MEMORY;
         }

         strcpy( woerterdatei[anz_wlin++], zeile);
      }
      zeile = getline();
   } /* while */
   wo_resident = 2;
   up_dauer( dat_len, dat_len);
   cl_dauer();

   return NO_ERROR;
}

static void free_hlp() /* Wîrterbuchdatei lîschen */
{
   static WORD i;

   for ( i=0; i<anz_wlin; i++) /* Zeilenspeicher freigeben */
     nfree( woerterdatei[i], 61);

   free( woerterdatei);
   anz_wlin = 0;
   max_wlin = 0;
}

static WORD dfind_word( wort) /* Wort in der Wîrterbuchdatei suchen */
register char *wort;
{
   register char *zeile;
   register char *z_ende;
   register WORD i = 0;

   zeile = getline();
   if (zeile == NULL) return CANT_OPEN_WOERTER;

   while (zeile != NULL)
   {
      if (zeile[0] == ':') /* Strings vergleichen */
        if (strcmp( zeile+1, wort) == 0) return NO_ERROR;

      zeile = getline();
   }

   return WORD_NOT_FOUND;
}

static WORD sfind_word( wort) /* Wort im Wîrterbuchfeld finden */
register char *wort;
{
   register char *zeile;
   register WORD i = 0;

   while (i < anz_wlin)
   {
      zeile = woerterdatei[i];

      if (zeile[0] == ':') /* Strings vergleichen */
        if (strcmp( zeile+1, wort) == 0) return i;

      i++;
   }

   return 0;
}

static WORD index_entry( zeile) /* Eintrag zum Index hinzufÅgen */
register char *zeile;
{
   register char *index_zeile;
   register char *speicher;

   if (anz_index == max_index)
   {
      speicher = realloc( ind_entries, sizeof(char *)*(max_index+10));
      if (speicher == NULL) return -1;
      ind_entries = (char **) speicher;
      max_index += 10;
   }

   switch (zeile[0])
   {
      case '!' : /* Kommentarzeile */
        break; /* garnichts machen */

      case ':' : /* Ende des Indexeintrags */
        return 1;

      case '$' : /* Querverweis */
        if (anz_index > 0)
        {
           index_zeile = nalloc( 63);
           if (index_zeile == NULL) return -1;
           *index_zeile = *ind_entries[anz_index-1]+1; /* Offset zum Quer-
                                                           verweis */
           strcpy( index_zeile+1, zeile+1);
           ind_entries[anz_index++] = index_zeile;
        }
        break;

      default :
        index_zeile = nalloc( 63);
        if (index_zeile == NULL) return -1;
        *index_zeile = 0;
        strcpy( index_zeile+1, zeile);
        ind_entries[anz_index++] = index_zeile;
        break;
   } /* switch */

   return 0;
}

static WORD get_index() /* Index laden */
{
   register WORD fehler;
   register char *zeile;
   register WORD z_nr;

   if (wo_resident == 0) /* Wîrterbuchdatei nicht im Speicher */
   {
      fehler = dfind_word( "INDEX");
      if (fehler) return fehler;

      do
      {
         zeile = getline();
         fehler = index_entry( zeile);
         if (fehler == -1) return NO_MEMORY;
      } while (zeile!=NULL && !fehler);
      close( &datei);
   }
   else
   {
      z_nr = sfind_word( "INDEX");
      if (z_nr == 0) return INDEX_NOT_FOUND;
      if (z_nr == anz_wlin-1) return NO_INDEX;

      do
      {
         zeile = woerterdatei[++z_nr];
         fehler = index_entry( zeile);
         if (fehler == -1) return NO_MEMORY;
      } while (z_nr<anz_wlin && !fehler);
   }

   return NO_ERROR;
}

static WORD text_entry( zeile)
register char *zeile;
{
   register char *speicher;

   if (*zeile == '!') return NO_ERROR; /* Zeile ist Kommentar */

   if (anz_tlin == max_tlin)
   {
      speicher = realloc( text, sizeof(char *)*(max_tlin+10));
      if (speicher == NULL) return NO_MEMORY;
      text = (char **) speicher;
      max_tlin += 10;
   }

   text[anz_tlin] = nalloc( 61);
   if (text[anz_tlin] == NULL) return NO_MEMORY;
   strcpy( text[anz_tlin++], zeile);

   return NO_ERROR;
}

static WORD load_text( wort) /* Texteintrag laden */
register char *wort;
{
   register WORD fehler, i;
   register char *zeile;
   register char *speicher;

   if (wo_resident == 0)
   {
      fehler = dfind_word( wort);
      if (fehler) return fehler;

      for ( i=0; i<anz_tlin; i++) /* alte EintrÑge lîschen */
        nfree( text[i], 61);
      anz_tlin = 0;

      zeile = getline();
      while (zeile!=NULL && *zeile!=':')
      {
         fehler = text_entry( zeile);
         if (fehler)
         {
            close( &datei);
            return fehler;
         }
         zeile = getline();
      }
      close( &datei);
   }
   else
   {
      i = sfind_word( wort);
      if (i == 0) return WORD_NOT_FOUND;

      anz_tlin = 0;
      zeile = woerterdatei[++i];
      while (i<anz_wlin && *zeile!=':')
      {
         if (anz_tlin == max_tlin)
         {
            speicher = realloc( text, sizeof(char *)*(max_tlin+10));
            if (speicher == NULL) return NO_MEMORY;
            text = (char **) speicher;
            max_tlin += 10;
         }

         text[anz_tlin++] = zeile;
         zeile = woerterdatei[++i];
      }
   }

   return NO_ERROR;
}

static WORD compare( str1, str2) /* Vergleichsroutine fÅr qsort */
register char **str1, **str2;
{
   return (strcmp( *str1, *str2));
}

static WORD suche( owort)
register char *owort;
{
   register WORD fehler;
   register WORD i = 0;
   register char *wort; /* Wortkopie */
   register char *speicher;

   wort = strdup( owort);
   if (wort == NULL) return NO_MEMORY;
   strupr( wort); /* wort in Groûbuchstaben umwandeln */

   if (wo_resident == 1)
   {
      fehler = load_hlp();
      if (fehler) return fehler;
   }

   if (anz_index == 0) /* Index muû geladen werden */
   {
      fehler = get_index();
      if (fehler) return fehler;
   }

   top_lin = 0;

   if (strcmp( "INDEX", wort) == 0) /* Index anzeigen */
   {
      if (wo_resident == 0)
        for ( i=0; i<anz_tlin; i++) /* alte EintrÑge lîschen */
          nfree( text[i]);
      anz_tlin = 0;

      for ( i=0; i<anz_index; i++)
        if (*ind_entries[i] == 0) /* Querverweise auslassen */
        {
           if (anz_tlin == max_tlin)
           {
              speicher = realloc( text, sizeof(char *)*(max_tlin+10));
              if (speicher == NULL) return NO_MEMORY;
              text = (char **) speicher;
              max_tlin += 10;
           }

           text[anz_tlin++] = ind_entries[i]+1;
        }

      /* EintrÑge sortieren */
      qsort( text, anz_tlin, sizeof(char *), compare);
   }
   else /* im Wîrterbuch suchen */
   {
      while (i<anz_index && strcmp( ind_entries[i]+1, wort))
        i++;

      if (i == anz_index) /* Wort nicht gefunden */
      {
         anz_tlin = 0;
         *wo_eintraege[0] = *s_n_gefunden;
         for ( i=1; i<8; i++)
           *wo_eintraege[i] = leerstring;
         return NO_ERROR;
      }
      else
      {
         i -= *ind_entries[i]; /* mîglicher Querverweis */
         fehler = load_text( ind_entries[i]+1);
         if (fehler) return fehler;
      }
   }

   /* Text im Dialogfeld eintragen */
   for ( i=0; i<min( 8, anz_tlin); i++)
     *wo_eintraege[i] = text[i];
   if (anz_tlin < 8)
     for ( i=anz_tlin; i<8; i++)
       *wo_eintraege[i] = leerstring;

   return NO_ERROR;
}

static void draw_entries( w, dir)
register WINDOW *w;
register WORD dir;
{
   register WORD i;
   WORD px, py;

   /* Texte im Dialog neu eintragen */
   for ( i=0; i<8; i++)
     *wo_eintraege[i] = text[i+top_lin];

   calc_slider( slider, slideframe, 8, anz_tlin, top_lin);
   draw_slider( h_woerter, w_woerter, WO_SLIDEFRAME);
   objc_offset( w_woerter, WO_TEXTBACK, &px, &py);
   if (dir == 0) /* komplett neu zeichnen */
     nw_redraw( w, 0, (LONG) px+1, (LONG) py, (LONG) textback->ob_width-2,
                      (LONG) textback->ob_height);
   else /* nur verschieben */
     nw_move( w, 0, (LONG) px+1, (LONG) py, (LONG) textback->ob_width-2,
              (LONG) textback->ob_height, 0, phchar*dir, TRUE);
}

/* ----------- nach auûen sichtbare Funktionen ---------- */
void in_woerter()
{
   register WORD i;

   /* Wîrterbuchdatei finden */
   strcpy( filename, "UCE.HLP");
   shel_find( filename);

   for ( i=0; i<8; i++)
   {
      wo_eintraege[i] = &w_woerter[i+WO_TEXT1].ob_spec;
      *wo_eintraege[i] = leerstring;
   }

   slider = &w_woerter[WO_SLIDER];
   slideframe = &w_woerter[WO_SLIDEFRAME];
   textback = &w_woerter[WO_TEXTBACK];
   slider->ob_y = 0;
   slider->ob_height = slideframe->ob_height;
   suchwort = ((TEDINFO *) w_woerter[WO_SUCHE_TEXT].ob_spec)->te_ptext;
}

WORD wo_suche( owort)
register char *owort;
{
   register WINDOW *w; /* Dialogfenster */
   register WORD fehler;
   WORD tx, ty;

   fehler = suche( owort);
   if (fehler) return fehler;

   /* Fensterausschnitt neuzeichnen */
   w = nw_searchwin( h_woerter);
   objc_offset( w_woerter, WO_TEXTBACK, &tx, &ty);
   calc_slider( slider, slideframe, 8, anz_tlin, 0);
   nw_redraw( w, 0, (LONG) tx, (LONG) ty+1,
              (LONG) w_woerter[WO_TEXTBACK].ob_width,
              (LONG) w_woerter[WO_TEXTBACK].ob_height-2);
   draw_slider( h_woerter, w_woerter, WO_SLIDEFRAME);

   return NO_ERROR;
}

WORD wo_help( wort)
register char *wort;
{
   strcpy( suchwort, wort); /* Wort in Wîrterbuchdialog kopieren */

   m_woerter(); /* Dialog îffnen oder toppen */
   if (h_woerter == 0) return NO_WINDOW;

   suche( suchwort); /* Wort suchen und darstellen */
   calc_slider( slider, slideframe, 8, anz_tlin, 0);
}

void b_woerterbuch( button)
register WORD button;
{
   register WINDOW *w;
   register WORD doppelklick, first, last;
   static char such[60];
   register char *source;

   doppelklick = (button & BIT15);
   button &= ~BIT15;
   w = nw_searchwin( h_woerter);

   if (doppelklick && button>=WO_TEXT1 && button<=WO_TEXT8 &&
       button-WO_TEXT1+top_lin<anz_tlin)
   {
      if (stricmp( "INDEX", suchwort) == 0)
        strcpy( such, text[button-WO_TEXT1+top_lin]);
      else /* gesuchtes Wort aus Text ausschneiden */
      {
         source = text[button-WO_TEXT1+top_lin];
         first = strpos( source, '\'');
         if (first == -1) return;
         last = strrpos( source, '\'');
         if (last-first < 3) return;
         substr( such, source, first+1, last-1);
      }

      /* Wort suchen */
      wo_help( such);
      nw_redraw( w, 1, 0L, 0L, (LONG) w_woerter[0].ob_width,
                (LONG) w_woerter[0].ob_height);
      return;
   }

   switch (button)
   {
      case 0 : /* Dialog schlieûen */
        d_end( &h_woerter);
        break;

      case WO_HILFE :
        wo_help( "WOERTERBUCH");
        nw_redraw( w, 1, 0L, 0L, (LONG) w_woerter[0].ob_width,
                  (LONG) w_woerter[0].ob_height);
        sel_object( w, w_woerter, button, 0);
        break;

      case WO_SUCHEN :
        wo_suche( ((TEDINFO *) w_woerter[WO_SUCHE_TEXT].ob_spec)->te_ptext);
        sel_object( w, w_woerter, button, 0);
        break;

      case WO_UP :
        if (top_lin == 0) return;
        top_lin--;
        draw_entries( w, 1);
        break;

      case WO_DOWN :
        if (top_lin+8 >= anz_tlin) return;
        top_lin++;
        draw_entries( w, -1);
        break;

      case WO_SLIDER :
        if (anz_tlin > 8)
        {
           top_lin = move_slider( w_woerter, WO_SLIDER, WO_SLIDEFRAME, 8,
                                  anz_tlin);
           draw_entries( w, 0);
        }
        break;

      case WO_SLIDEFRAME :
        page_slider( w, w_woerter, WO_SLIDER, &top_lin, 8, anz_tlin,
                     draw_entries);
        break;

      case WO_RESIDENT :
        if (wo_resident == 0)
          wo_resident = 1;
        else
        {
           if (wo_resident == 2) /* Speicher freigeben */
             free_hlp();
           wo_resident = 0;
        }
        break;
   }
}