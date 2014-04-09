/* WOERTER.ACC :
   ein einfaches Deutsch-Englisch-Wîrterbuch
   von Michael Koch
   Beginn : 23.8.1993
*/

#include <woerter.h>

/* typedefs */
typedef struct { /* Eintrag im Wîrterbuch */
  char score;
  char sprache; /* 1: Deutsch->Englisch/0: Englisch->Deutsch */
  char anzahl; /* Anzahl der öbersetzungsmîglichkeiten */
  char orginal[32];
  char ueber[5][32];
  } ENTRY;

/* externe Funktionen */
  extern WINDOW *nw_searchwin();
  extern char *bsearch();

/* externe Variablen */
  extern WORD prgende;

/* globale Variablen */
  /* Resource-Variablen */
  extern OBJECT *m_menue;
  extern OBJECT *w_info;
  extern OBJECT *w_woerterbuch;
  extern OBJECT *w_neues_wort;
  extern OBJECT *w_trainer;
  extern char  **s_info;
  extern char  **s_woerterbuch;
  extern char  **s_neues_wort;
  extern char  **s_trainer;
  extern char  **s_nicht_gefunden;

  extern E_MULTI e_multi;

  extern WORD anz_entries; /* Anzahl EintrÑge im Wîrterbuch */
  extern WORD max_entries;
  extern ENTRY *entry; /* Feld mit EintrÑgen */
  extern WORD anz_d_e;
  extern WORD max_d_e;
  extern WORD *liste_d_e;
  extern WORD anz_e_d;
  extern WORD max_e_d;
  extern WORD *liste_e_d;
  extern WORD durchschnitt;
  extern WORD geaendert;
  extern WORD s_sprache; /* Suchsprache fÅr comp_entries() */
  extern WORD phchar;

/* Fehlerkonstanten */
#define NO_ERROR    0
#define W_ERROR     1
#define NO_MEMORY   2
#define FILE_OPEN   3
#define FILE_ERROR  4

/* sonstige Konstanten */
#define ENGLISCH  0