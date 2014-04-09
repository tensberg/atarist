/* die Includedatei fÅr alle Module des Projekts UCE
   Autor  : Michael Koch
   Beginn : 1.6.1993

   Modulliste:
     u_main.c     UCE_MAIN            Hauptprogramm
     u_inobjc.c   INIT_OBJC_ADDRESS   Objektbaumadressen ermitteln
     u_error.c    ERROR_HANDLER       Fehler behandeln
     u_menu.c     UCE_MENU            Behandlung der Menuezeile
     u_do_evn.c   UCE_DO_EVNT         Behandlung eines Ereignisses
     u_dialog.c   UCE_DIALOG          DurchfÅhrung der nichtmodalen Dialoge
     u_ld_ein.c   UCE_LD_EINSTELL     Einstellungen laden
     u_text1.c    UCE_TEXT1           Prozeduren zur Textbearbeitung
     u_text2.c    UCE_TEXT2               "       "         "
     u_text3.c    UCE_TEXT3               "       "         "
     u_qt_fen.c   UCE_QT_FENSTER1     Prozeduren zur Fensterverwaltung
     u_qt_fen.c   UCE_QT_FENSTER2     Prozeduren zur Fensterverwaltung
     u_dateif.c   UCE_DATEIFENSTER    Verwaltung des Dateifensters
     u_nalloc.c   UCE_NALLOC          Speicherverwaltungsroutinen
     u_dateim.c   UCE_DATEIMENUE      Bearbeitung von EintrÑgen des Dateimenues
     u_dauer.c    UCE_DAUER           Prozeduren fÅr den Dauer-Dialog
     u_cursor.c   UCE_CURSOR          Cursor zeichnen
     u_g_line.c   UCE_GET_LINES       obere/untere Zeile; linke/rechte Spalte
     u_slider.c   UCE_SLIDER          Sliderberechnung
     u_woerte.c   UCE_WOERTERBUCH     Wîrterbuch-Verwaltung
     u_ramsc1.c   UCE_RAMSCH1         verschiedene Prozeduren
     u_ramsc2.c   UCE_RAMSCH2              "           "
     u_keybd1.c   UCE_KEYBOARD1       Tastendruck auswerten
     u_keybd2.c   UCE_KEYBOARD2       Zeichen in Text einfÅgen
     u_keybd3.c   UCE_KEYBOARD3          "     "   "      "
     u_zu_zei.c   UCE_ZU_ZEILE        AusfÅhrung des Zu Zeile-Menuepunktes
     u_marke.c    UCE_MARKE           Marke setzen/lîschen
*/

#include <uce.h> /* Datei mit Konstanten der Resource-Datei */

/* externe Funktionen */
  extern WINDOW *nw_searchwin();

/* externe Variablen */
  extern WORD prgende; /* Flag, ob Programm beendet wird */

/* globale Strukturen */
  /* diese Struktur beschreibt alle Daten eines Quelltextes */
  typedef struct {
    BYTE    q_nummer;       /* Nummer des Quelltextes */
    BYTE    type;           /* Texttyp */
    WORD    geaendert;      /* Flag, ob Text geÑndert wurde */
    WORD    selected;       /* Flag, ob in Dateifenster angewÑhlt */
    WINDOW  w;              /* Fensterstruktur FÅr Quelltextfenster */
    char    *q_pfad;        /* Zeiger auf den Quelltextpfad */
    char    *q_name;        /* der Name des Quelltextes ohne Pfadinfo */
    LONG    zeilenzahl;     /* Anzahl der Zeilen */
    LONG    max_zeilen;     /* momentane maximale Zeilenzahl */
    LONG    o_zeile;        /* oberste sichtbare Zeile */
    WORD    l_spalte;       /* linke sichtbare Spalte */
    WORD    a_zeilen;       /* Anzahl sichtbarer Zeilen */
    WORD    a_spalten;      /* Anzahl sichtbarer Spalten */
    WORD    cursor_an;      /* Flag, ob Cursor sichtbar ist */
    LONG    cursor_zeile;   /* Position des Cursors */
    WORD    cursor_spalte;
    LONG    bstart_zeile;   /* Nummer der Zeile, in der der Block anfÑngt */
    WORD    bstart_spalte;  /* Spalte, in der der Block anfÑngt */
    LONG    bende_zeile;
    WORD    bende_spalte;
    LONG    marke[5];       /* Zeilenposition der Marken */
    char    **zeile;        /* Feld mit Zeigern auf Zeilen */
    } QUELLTEXT;

/* #define's */
  /* char in WORD umwandeln */
  #define toword(a)  *((WORD *)&(a))

  /* Zeilenbreite fÅr Quelltexte */
  #define ZEILENBREITE  255

  /* Konstanten fÅr new_cursor() */
  #define ZEILE   1
  #define SPALTE  2

  /* Cursorbewegunsrichtungen */
  #define LEFT   1
  #define RIGHT  2
  #define UP     3
  #define DOWN   4

  /* Fehlerreturnwerte und Parameter fÅr error() */
  #define NO_ERROR            0 /* kein Fehler */
  #define U_ERROR             1 /* allgemeiner Fehler */
  #define ABORT               2 /* Funktion vom Benutzer abgebrochen */
  #define INIT_ERROR          3 /* Fehler bei der Initialisierung */
  #define NO_MEMORY           4 /* kein Speicherplatz mehr */
  #define NO_WINDOW           5 /* Fenster kann nicht geîffnet werden */
  #define CANT_OPEN_FILE      6 /* Datei kann nicht geîffnet werden */
  #define QT_WRONG_HANDLE     7
  #define QT_IS_OPEN          8
  #define QT_NOT_OPEN         9
  #define CANT_OPEN_WOERTER  10
  #define WORD_NOT_FOUND     11
  #define INDEX_NOT_FOUND    12
  #define NO_INDEX           13
  #define WRITE_ERROR        14 /* Fehler beim Schreiben einer Datei */

#ifndef UCE_MAIN
  /* allgemeine Variablen */
  extern WORD ap_id; /* ID des eigenen Programms */
  extern WORD wk_handle; /* Handle der virtuellen VDI-Workstation */
  extern WORD pwchar, phchar, pwbox, phbox; /* Ausmaûe eines Zeichens */
  extern GRECT work; /* Ausmaûe der BildschirmarbeitsflÑche */
  extern E_MULTI evnt;
  extern WORD pmx, pmy, pmb, pks, pkr, pbr;
  extern char *f_name; /* Fenstername */
  extern WORD vwk_out[]; /* RÅckgabeparameter von v_opnvwk */
  extern WORD cur_width; /* Cursorbreite */
  extern LONG cur_freq; /* Cursorblinkfrequenz */
  extern char pfad[];
  extern char *spfad;
  extern char name[];
  extern WORD gemklemmbrett;
  extern WORD info_changed; /* Flag, ob Infozeile verÑndert wurde */

  /* Variablen, die in w_einstell und w_editmodi verÑndert werden kînnen */
  extern WORD ed_einfuegen;     /* Buchstaben einfÅgen oder Åberschreiben ? */
  extern WORD ed_z_einfuegen;   /* bei Return Zeile einfÅgen ? */
  extern WORD ed_zeilenrest;    /* bei Return Zeilenrest mitnehmen ? */
  extern WORD ed_einruecken;    /* bei Return einrÅcken ? */
  extern WORD ed_zeilenumbruch; /* Wortumbruch am Zeilenende ? */
  extern WORD ed_umbruchbreite;
  extern WORD ed_tabweite;      /* Tabulatorbreite */
  extern WORD ei_growshrink;    /* Grow/Shrinkboxen zeichnen ? */
  extern WORD ei_bytegrenze;    /* Fenster auf Bytegrenze legen ? */
  extern WORD ei_mausposition;  /* Dialoge an Mausposition ? */
  extern WORD ei_cursor_blinkt; /* Cursor blinkt ? */
  extern WORD ei_warnton;       /* Warnton bei Fehlern ? */
  extern WORD ei_inf;           /* *.INF-Dateien fÅr Quelltexte speichern ? */
  extern WORD ei_bak;           /* alte Dateien in *.BAK umbenennen ? */

  /* hier folgen die globalen Variablen mit Objektbaumadressen
     w_ : nichtmodaler Dialog
     d_ : modaler Dialog
     p_ : Popupmenue
     i_ : Infodialog ohne Button
     a_ : Alertbox
     s_ : freier String           */
  extern OBJECT *hauptmenue;
  extern OBJECT *w_info;
  extern OBJECT *w_ftasten;
  extern OBJECT *w_editmodi;
  extern OBJECT *w_einstell;
  extern OBJECT *w_woerter;
  extern OBJECT *w_dateien;
  extern OBJECT *d_suchen;
  extern OBJECT *d_ersetzen;
  extern OBJECT *d_zu_zeile;
  extern OBJECT *d_b_schieb;
  extern OBJECT *d_drucken;
  extern OBJECT *d_tabweite;
  extern OBJECT *d_zeilenumbruch;
  extern OBJECT *d_da_vorhanden;
  extern OBJECT *p_fenster;
  extern OBJECT *p_msetzen;
  extern OBJECT *p_zumarke;
  extern OBJECT *i_dauer;
  extern char  **a_init;
  extern char  **a_no_memory;
  extern char  **a_no_window;
  extern char  **s_infozeile;
  extern char  **s_d_oeffnen;
  extern char  **s_d_si_unter;
  extern char  **s_t_laden;
  extern char  **s_t_sichern;
  extern char  **s_t_loeschen;
  extern char  **s_n_gefunden;
  extern char  **s_wo_laden;
  extern char  **s_erlaubt;
#endif /* #ifndef UCE_MAIN */

#ifndef UCE_MENU /* Dropdown-Menue-Verwaltungsteil */
  extern void me_kclick();
    /* prÅft, ob der Tastendruck einen Menueeintrag aktiviert und ruft
       me_domenu() auf */

  extern WORD me_domenu();
    /* ruft die Funktion auf, die zum entsprechenden Menueeintrag gehîrt */
#endif

#ifndef INIT_OBJC_ADDRESS /* Objektadressen ermitteln */
  extern WORD in_objc_addr();
#endif

#ifndef ERROR_HANDLER /* behandelt Fehler und stellt Alertboxen dar */
  extern void error();
#endif

#ifndef UCE_DO_EVNT /* Behandlung eines Ereignisses */
  extern void do_evnt();
#endif

#ifndef UCE_DIALOG /* DurchfÅhrung der nichtmodalen Dialoge */
  extern void m_uce_info();
  extern void m_ftasten();
  extern void m_einstellungen();
  extern void m_editmodi();
  extern void cl_dialog(); /* alle Dialoge schlieûen */
  extern void d_end(); /* Dialog schlieûen */
  extern void top(); /* Dialogfenster toppen */
#endif

#ifndef UCE_LD_EINSTELL /* Standarteinstellung laden */
  extern void ld_einstell();
#endif

#ifndef UCE_TEXT1
  /* Variablen */
  extern BYTE anz_texte; /* Anzahl Quelltexte */
  extern BYTE max_texte; /* mom. Maximalzahl Quelltexte */
  extern QUELLTEXT *textfeld; /* Feld von Quelltexten */
  extern QUELLTEXT *a_qt; /* aktiver Quelltext */

  /* Funktionen */
  extern WORD t_cr_text(); /* Text erzeugen */
  extern WORD t_open_text(); /* Quelltextfenster îffnen */
  extern WORD t_close_text(); /* Quelltextfenster schlieûen */
  extern WORD t_del_text(); /* Text lîschen */
  extern QUELLTEXT *t_find_qt(); /* Quelltextadresse ermitteln */
#endif

#ifndef UCE_TEXT2
  extern WORD t_load_text(); /* Text laden */
  extern WORD t_save_text(); /* Text speichern */
#endif

#ifndef UCE_TEXT3
  extern WORD t_ins_line(); /* Leerzeilen in Text einfÅgen */
  extern WORD t_del_line(); /* Zeilen aus Text lîschen */
  extern WORD t_enl_line(); /* Zeilenspeicher vergrîûern */
#endif

#ifndef UCE_QT_FENSTER1
  extern void qt_do_revnt();
  extern WORD qt_button();
  extern WORD qt_timer();
#endif

#ifndef UCE_QT_FENSTER2
  extern void qt_sredraw();
#endif

#ifndef UCE_CURSOR
  /* Variablen */
  extern WORD cursor_an; /* Cursor eingeschaltet ? */
  extern LONG cur_x, cur_y; /* Cursor-X/Y-Position */

  /* Funktionen */
  extern void new_cursor(); /* neue Cursorposition berechnen und zeichnen */
  extern void cursor(); /* Cursor zeichnen */
  extern void mov_cursor(); /* Cursor bewegen */
#endif

#ifndef UCE_GET_LINES
  extern WORD get_top();
  extern WORD get_bottom();
  extern WORD get_left();
  extern WORD get_right();
#endif

#ifndef UCE_DATEIFENSTER
  /* Variablen */
  extern WORD top_text; /* oberster angezeigter Text */

  /* Funktionen */
  extern void in_dateien(); /* Initialisierung */
  extern void m_dateien();
  extern void da_newentry(); /* neuer Eintrag im Dateienfeld */
  extern void da_delentry(); /* Eintrag entfernen */
  extern void da_chkentry(); /* HÑkchen zeichnen */
  extern void da_newname(); /* neuer Dateiname */
#endif

#ifndef UCE_NALLOC
  extern char *nalloc();
  extern WORD nfree();
  extern void free_all();
#endif

#ifndef UCE_DATEIMENUE
  extern void m_neu_anlegen();
  extern void m_oeffnen();
  extern void m_sichern();
  extern void m_si_unter();
  extern void m_schliessen();
#endif

#ifndef UCE_DAUER
  extern void in_dauer();
  extern void op_dauer();
  extern void up_dauer();
  extern void cl_dauer();
#endif

#ifndef UCE_SLIDER
  extern void calc_slider();
  extern WORD move_slider();
  extern void draw_slider();
  extern WORD page_slider();
#endif

#ifndef UCE_WOERTERBUCH
  /* Variablen */
  extern WORD wo_resident; /* Flag, ob Wîrterbuch im Speicher gehalten wird */

  /* Funktionen */
  extern void in_woerter();
  extern WORD wo_suche(); /* Wort im Wîrterbuch finden und darstellen */
  extern WORD wo_help();
  extern void b_woerter();
#endif

#ifndef UCE_RAMSCH1
  extern void sel_object(); /* Objekt selektieren */
  extern WORD selected(); /* prÅft, ob Objekt selektiert ist */
  extern void get_nsize(); /* neue Fenstergrîûe */
#endif

#ifndef UCE_RAMSCH2
  extern char *make_line();
  extern void free_line();
#endif

#ifndef UCE_KEYBOARD1
  extern WORD ischar();
  extern WORD qt_keybd();
#endif

#ifndef UCE_KEYBOARD2
  extern void ins_char();
#endif

#ifndef UCE_KEYBOARD3
  extern void do_return();
  extern void do_backspace();
  extern void do_delete();
#endif

#ifndef UCE_ZU_ZEILE
  extern void m_zu_zeile();
#endif

#ifndef UCE_MARKE
  extern void m_ma_setzen();
  extern void m_zu_marke();
#endif