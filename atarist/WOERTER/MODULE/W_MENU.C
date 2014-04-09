/* Message- und Tastendruckverarbeitung */

#include <stdio.h>
#include <osbind.h>
#include <gemfast.h>
#include <window.h>
#include <w_header.h>

static void do_menu( title, entry)
register WORD title, entry;
{
   switch (entry)
   {
      case M_INFO :
        m_info();
        break;

      case M_WOERTERBUCH :
        m_woerterbuch();
        break;

      case M_NEUES_WORT :
        m_neues_wort();
        break;

      case M_TRAINER :
        m_trainer();
        break;

      case M_ENDE :
        prgende = 1;
        break;
   }

   menu_tnormal( m_menue, title, 1);
}

/* --------- nach aužen sichtbare Prozeduren -------- */
WORD do_message( e_m)
register E_MULTI *e_m;
{
   register WORD fertig;
   register WORD *mbuf;

   mbuf = e_m->mepbuff;

   fertig = nw_chkmesag( mbuf);

   if (fertig == W_DONE) return 0;

   if (mbuf[0] == MN_SELECTED)
     do_menu( mbuf[3], mbuf[4]);

   return 0;
}

WORD do_keybd( e_m)
register E_MULTI *e_m;
{
   static KEYTAB *keytable;
   register WORD scan, ascii;
   WORD handle, dummy;

   /* Adresse der Tastencode-Umwandlungstabelle holen */
   if (keytable == NULL) keytable = (KEYTAB *) Keytbl( -1l, -1l, -1l);

   if (!(*e_m->pks & K_CTRL)) return 0; /* Control-Taste nicht gedrckt */

   scan = (*e_m->pkr>>8 & 0xff); /* Scancode */
   ascii = keytable->unshift[scan]; /* ASCII-Code der Taste ohne CONTROL zu
                                      beachten */

   switch (ascii)
   {
      case 'w' : /* n„chstes Fenster toppen */
        wind_get( 0, WF_TOP, &handle, &dummy, &dummy, &dummy);
        nw_nextwin( &handle); /* Handle des n„chsten Fensters */
        if (handle != 0) /* es gibt noch ein anderes Fenster */
          wind_set( handle, WF_TOP, dummy, dummy, dummy, dummy);
        break;

      case 'q' : /* Programmende */
        menu_tnormal( m_menue, T_OPTIONEN, 0);
        do_menu( T_OPTIONEN, M_ENDE);
        break;
   }
}