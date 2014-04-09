/* Behandlung der Menuezeile */

#define UCE_MENU  1

#include <stdio.h>
#include <gemfast.h>
#include <osbind.h>
#include <window.h>
#include <uceinc.h>

WORD me_kclick( e_multi)
register E_MULTI *e_multi;
{
   WORD dummy;
   register WORD scan, ascii;
   register WORD title = 0, entry = 0;
   WORD handle; /* Fensterhandle */
   register QUELLTEXT *qt;
   register WORD back = 1;
   static KEYTAB *keytable = NULL;

   /* Adresse der Tastencode-Umwandlungstabelle holen */
   if (keytable == NULL) keytable = (KEYTAB *) Keytbl( -1l, -1l, -1l);

   if (!(*e_multi->pks & K_CTRL)) return 0; /* Control-Taste nicht gedrÅckt */

   scan = (*e_multi->pkr>>8 & 0xff); /* Scancode */
   ascii = keytable->unshift[scan]; /* ASCII-Code der Taste ohne CONTROL zu
                                      beachten */

   switch (ascii)
   {
      case 'w' : /* nÑchstes Fenster toppen */
        wind_get( 0, WF_TOP, &handle, &dummy, &dummy, &dummy);
        nw_nextwin( &handle); /* Handle des nÑchsten Fensters */
        if (handle != 0) /* es gibt noch ein anderes Fenster */
        {
           wind_set( handle, WF_TOP, dummy, dummy, dummy, dummy);
           qt = t_find_qt( handle);
           if (qt != NULL) /* Cursor neu berechnen */
           {
              cur_x = qt->cursor_spalte*pwchar;
              cur_y = qt->cursor_zeile*phchar;
              a_qt = qt;
           }
        }
        break;

      case 'n' : /* neu anlegen */
        title = T_DATEI;
        entry = M_NEU_ANLEGEN;
        break;

      case 'o' : /* Datei îffnen */
        title = T_DATEI;
        entry = M_OEFFNEN;
        break;

      case 'u' : /* Datei schlieûen */
        title = T_DATEI;
        entry = M_SCHLIESSEN;
        break;

      case 's' : /* Datei sichern */
        title = T_DATEI;
        entry = M_SICHERN;
        break;

      case 'm' : /* sichern unter */
        title = T_DATEI;
        entry = M_SICHERN_UNTER;
        break;

      case 'd' : /* Dateifenster */
        title = T_DATEI;
        entry = M_DATEIFENSTER;
        break;

      case 'f' : /* Suchen */
        title = T_EDIT;
        entry = M_SUCHEN;
        break;

      case 'z' : /* zu Zeile */
        title = T_EDIT;
        entry = M_ZU_ZEILE;
        break;

      case 'q' : /* Programmende */
        title = T_DATEI;
        entry = M_ENDE;
        break;

      default : /* Tastenkombination nicht bekannt */
        back = 0;
        break;
   }

   if (title != 0 && entry != 0)
   {
      menu_tnormal( hauptmenue, title, 0); /* Menuetitel hervorheben */
      me_domenu( title, entry); /* Aktion durchfÅhren */
   }

   return back;
}

WORD me_domenu( title, entry)
register WORD title; /* Menuetitel */
register WORD entry; /* Nummer des angeklickten Objekts */
{
   switch (entry)
   {
      case M_UCE_INFO :
        m_uce_info();
        break;

      case M_NEU_ANLEGEN :
        m_neu_anlegen();
        break;

      case M_OEFFNEN :
        m_oeffnen();
        break;

      case M_SCHLIESSEN :
        m_schliessen();
        break;

      case M_SICHERN :
        m_sichern();
        break;

      case M_SICHERN_UNTER :
        m_si_unter();
        break;

      case M_DATEIFENSTER :
        m_dateien();
        break;

      case M_ENDE :
        prgende = TRUE; /* Programm beenden */
        break;

      case M_GEMKLEMMBRETT :
        gemklemmbrett = !gemklemmbrett;
        menu_icheck( hauptmenue, M_GEMKLEMMBRETT, gemklemmbrett);
        break;

      case M_SUCHEN :
        m_suchen();
        break;

/*      case M_ERSETZEN :
        m_ersetzen();
        break;*/

/*      case M_ERNEUT_SUCHEN :
        m_erneut_suchen();
        break;*/

      case M_MARKE_SETZEN :
        m_ma_setzen();
        break;

      case M_ZU_MARKE :
        m_zu_marke();
        break;

      case M_ZU_ZEILE :
        m_zu_zeile();
        break;

      case M_WOERTERBUCH :
        m_woerter();
        break;

      case M_F_TASTEN :
        m_ftasten();
        break;

      case M_FENSTER : /* Fenster sortieren */
        m_fenster();
        break;

      case M_EINSTELLUNG :
        m_einstell();
        break;

      case M_EDITMODI :
        m_editmodi();
        break;
   }

   menu_tnormal( hauptmenue, title, 1); /* Menuetitel wieder normal */

   return 0;
}