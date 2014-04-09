/* Prozeduren zur Textbearbeitung */

#define UCE_TEXT1  1

#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

/* globale Variablen */
BYTE anz_texte = 0;
BYTE max_texte = 0;
QUELLTEXT *textfeld = NULL;
QUELLTEXT *a_qt = NULL; /* aktiver Quelltext */
extern WORD h_dateien;

static void draw_growshrink( flag, t_handle, qw)
register WORD flag, t_handle;
register WINDOW *qw;
{
   WORD gx, gy, gw, gh;
   register WORD t_nr;

   if (ei_growshrink)
   {
      if (h_dateien) /* Dateifenster ist offen */
      {
         t_nr = t_handle-top_text;
         if (t_nr>=0 && t_nr<7)
         {
            objc_offset( w_dateien, t_nr+DA_TEXT1, &gx, &gy);
            gw = w_dateien[t_nr+DA_TEXT1].ob_width;
            gh = w_dateien[t_nr+DA_TEXT1].ob_height;
         }
         else
         {
            objc_offset( w_dateien, DA_TEXTBACK, &gx, &gy);
            gw = w_dateien[DA_TEXTBACK].ob_width;
            gh = w_dateien[DA_TEXTBACK].ob_height;
         }
      }
      else
      {
         gx = qw->wx+qw->ww/2-5;
         gy = qw->wy+qw->wh/2-5;
         gw = gh = 10;
      }

      if (flag)
        graf_growbox( gx, gy, gw, gh, qw->wx, qw->wy, qw->ww, qw->wh);
      else
        graf_shrinkbox( gx, gy, gw, gh, qw->wx, qw->wy, qw->ww, qw->wh);
   }
}

static void status( qt, info) /* Statuszeile berechnen */
register QUELLTEXT *qt;
register char *info;
{
   register char zahl[10];
   register WORD laenge, i;

   ltoa( qt->cursor_zeile+1, zahl, 10);
   /* Zahl rechtsbÅndig machen */
   laenge = 5-strlen( zahl);
   stradj( zahl, laenge);
   for ( i=0; i<laenge; i++)
     zahl[i] = ' ';
   /* Zahl in Infostring einfÅgen */
   strncpy( &info[6], zahl, 5);
   itoa( qt->cursor_spalte+1, zahl, 10);
   /* Zahl rechtsbÅndig machen */
   laenge = 3-strlen( zahl);
   stradj( zahl, laenge);
   for ( i=0; i<laenge; i++)
     zahl[i] = ' ';
   /* Zahl in Infostring einfÅgen */
   strncpy( &info[19], zahl, 3);
   info[23] = (qt->geaendert) ? '' : ' ';
}

/* --------- nach auûen sichtbare Prozeduren ------- */
WORD t_cr_text( q_pfad, q_name) /* Quelltext erzeugen */
register char *q_pfad, *q_name; /* Textpfad und -name */
{
   register char *naddr; /* neue Adresse */
   register QUELLTEXT *qt; /* Adresse der Textstruktur */
   register WINDOW *qw;    /* Adresse des Textstruktur-Fensters */
   register E_MULTI *qe;   /* Adresse der Fenster-E_MULTI-Struktur */
   register WORD i; /* ZÑhlervariable */

   if (anz_texte == max_texte)
   {
      naddr = realloc( textfeld, sizeof(QUELLTEXT)*(max_texte+5));
      if (naddr == NULL) return W_NO_MEMORY;
      max_texte += 5;
      for ( i=0; i<anz_texte; i++)
        if (((QUELLTEXT *) naddr)[i].w.w_open)
          nw_newaddr( &textfeld[i].w, &((QUELLTEXT *) naddr)[i].w);
      textfeld = (QUELLTEXT *) naddr;
   }

   qt = &textfeld[anz_texte]; /* Adresse des neuen Quelltexts */
   qw = &qt->w; /* Adresse der WINDOW-Struktur */
   qe = &qw->e_multi; /* Adresse der E_MULTI-Struktur */

   /* QUELLTEXT-Struktur initialisieren */
   qt->q_nummer = anz_texte;
   qt->geaendert = FALSE;
   qt->selected = FALSE;
   qt->q_pfad = strdup( q_pfad);
   if (qt->q_pfad == NULL) return W_NO_MEMORY;
   qt->q_name = strdup( q_name);
   if (qt->q_name == NULL) return W_NO_MEMORY;
   qt->zeilenzahl = 1;
   qt->max_zeilen = 500;
   qt->cursor_zeile = 0;
   qt->cursor_spalte = 0;
   qt->bstart_zeile = 0;
   for ( i=0; i<5; i++)
     qt->marke[i] = -1;
   qt->zeile = (char **) malloc( sizeof(char *)*500);
   if (qt->zeile == 0) return W_NO_MEMORY;
   qt->zeile[0] = make_line( 0, 32); /* String fÅr erste Zeile */
   if (qt->zeile[0] == NULL)
   {
      free( qt->zeile);
      return W_NO_MEMORY;
   }
   *qt->zeile[0] = '\0'; /* leere Zeile */
   for ( i=1; i<500; i++)
     qt->zeile[i] = NULL; /* Restliche Zeilen zeigen auf keinen String */

   /* WINDOW-Struktur initialisieren */
   nw_stdwind( qw);
   qw->w_kind = NAME|INFO|CLOSER|FULLER|MOVER|SIZER|UPARROW|DNARROW|VSLIDE|
                LFARROW|RTARROW|HSLIDE;
   qw->w_events = REDRAW|CLOSED|FULLED|ARROWED|HSLID|VSLID|SIZED|MOVED;
   qw->r_events = CLOSED|FULLED|ARROWED|HSLID|VSLID|SIZED;
   qw->do_event = qt_do_revnt;
   qw->rw = (ZEILENBREITE+1)*pwchar;
   qw->rh = phchar;
   if (ei_bytegrenze) /* Fenster auf Bytegrenze legen */
   {
      qw->stepx = 8;
      qw->ww -= pwchar;
      qw->max_w -= pwchar;
   }
   qw->stepw = pwchar;
   qw->vslidstep = 5*pwchar;
   qw->steph = qw->hslidstep = phchar;
   qw->w_sredraw = qt_sredraw;
   qw->r_sparam = anz_texte;

   /* E_MULTI-Struktur initialisieren */
   qe->flags = MU_KEYBD|MU_BUTTON|MU_TIMER;
   qe->time = cur_freq; /* Cursorblinkintervall */
   qe->bclk = 2;
   qe->bmsk = 1;
   qe->bst  = 1;
   qe->keybd = qt_keybd;
   qe->button = qt_button;
   qe->timer = qt_timer;

   anz_texte++;
   da_newentry( anz_texte-1);

   return NO_ERROR;
}

WORD t_open_text( t_handle)
register BYTE t_handle; /* Texthandle */
{
   register QUELLTEXT *qt;
   register WINDOW *qw;
   WORD fehler;
   register char *name; /* Fensternamen */
   register char *info; /* Fensterinfo */

   if (t_handle >= anz_texte) return QT_WRONG_HANDLE;

   qt = &textfeld[t_handle];
   qw = &qt->w;
   if (qw->w_open) return QT_IS_OPEN; /* Fenster war schon geîffnet */

   /* Fernsternamen erzeugen */
   name = malloc( strlen(qt->q_pfad)+strlen(qt->q_name)+1);
   if (name == NULL) return W_NO_MEMORY;
   strcpy( name, qt->q_pfad);
   strcat( name, qt->q_name);
   qw->wf_name = name;

   /* Fensterinfo erzeugen */
   info = strdup( *s_infozeile);
   if (info == NULL)
   {
      free( name);
      return W_NO_MEMORY;
   }
   status( qt, info);
   qw->wf_info = info;

   fehler = nw_create( qw);
   if (fehler != W_NO_ERROR) return fehler;
   free( name);
   free( info);

   draw_growshrink( TRUE, t_handle, qw);
   nw_open( qw);

   qt->o_zeile = qw->ry/phchar;
   qt->l_spalte = qw->rx/pwchar;
   qt->a_zeilen = qw->ih/phchar;
   qt->a_spalten = qw->iw/pwchar;

   a_qt = qt;
   qt->cursor_an = TRUE;
   cur_x = qt->cursor_spalte*pwchar;
   cur_y = qt->cursor_zeile*phchar;
   info_changed = FALSE;

   return NO_ERROR;
}

WORD t_close_text( t_handle)
register BYTE t_handle;
{
   register QUELLTEXT *qt;
   register WINDOW *qw;

   if (t_handle >= anz_texte) return QT_WRONG_HANDLE;

   qt = &textfeld[t_handle];
   qw = &qt->w;

   nw_close( qw);
   redraw();
   draw_growshrink( FALSE, t_handle, qw);
   nw_delete( qw);
   qw->w_handle = 0;

   return NO_ERROR;
}

WORD t_del_text( t_handle)
register BYTE t_handle;
{
   register QUELLTEXT *qt;
   register LONG i;

   if (t_handle >= anz_texte) return QT_WRONG_HANDLE;

   qt = &textfeld[t_handle];

   anz_texte--;

   /* Zeilenspeicher freigeben */
   op_dauer( *s_t_loeschen, qt->q_name);
   for ( i=0; i<qt->zeilenzahl; i++)
   {
      free_line( &qt->zeile[i]);
      if ((i+1)%15 == 0) up_dauer( i, qt->zeilenzahl);
   }
   free( qt->zeile);
   up_dauer( qt->zeilenzahl, qt->zeilenzahl);
   cl_dauer();

   for ( i=t_handle+1; i<anz_texte+1; i++)
   {
      textfeld[i].q_nummer--;
      if (textfeld[i].w.w_open == TRUE)
        nw_newaddr( &textfeld[i].w, &textfeld[i-1].w);
   }

   if (t_handle != anz_texte)
     memmove( &textfeld[t_handle], &textfeld[t_handle+1], sizeof(QUELLTEXT)*
              (anz_texte-t_handle));

   da_delentry( t_handle);

   return NO_ERROR;
}

QUELLTEXT *t_find_qt( w_handle)
register WORD w_handle;
{
   register WORD i=0;

   if (w_handle == 0) return NULL;

   while (i<anz_texte && textfeld[i].w.w_handle!=w_handle)
     i++;

   if (i == anz_texte) return NULL; /* nicht gefunden */

   return &textfeld[i];
}

void upd_status( qt)
register QUELLTEXT *qt;
{
   static char *info = NULL;

   if (info == NULL) info = strdup( *s_infozeile);

   status( qt, info);
   nw_ninfo( &qt->w, info);
}