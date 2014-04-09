/* Infodialog darstellen */

#include <stdio.h>
#include <gemfast.h>
#include <window.h>
#include <w_header.h>

/* externe Prozeduren */
  extern void b_woerterbuch();
  extern void b_neues_wort();
  extern void b_trainer();

/* globale Variablen */
  /* Dialoghandle */
  static WORD h_info = 0;
         WORD h_woerterbuch = 0;
         WORD h_neues_wort = 0;
         WORD h_trainer = 0;

static void b_info( button)
register WORD button;
{
   if (button == 0) /* Dialog schliežen */
   {
      nf_end( h_info, TRUE);
      h_info = 0;
   }
}

/* ------- nach aužen sichtbare Prozeduren ------- */
void m_info()
{
   if (h_info == 0)
     h_info = nf_do( w_info, 0, FALSE, FALSE, *s_info, b_info, &e_multi, TRUE);
   else
     wind_set( h_info, WF_TOP, 0, 0, 0, 0);
}

void m_woerterbuch()
{
   if (h_woerterbuch == 0)
     h_woerterbuch = nf_do( w_woerterbuch, WO_ORGINAL, FALSE, FALSE,
                            *s_woerterbuch, b_woerterbuch, &e_multi, TRUE);
   else
     wind_set( h_woerterbuch, WF_TOP, 0, 0, 0, 0);
}

void m_neues_wort()
{
   if (h_neues_wort == 0)
     h_neues_wort = nf_do( w_neues_wort, NE_ORGINAL, FALSE, FALSE,
                           *s_neues_wort, b_neues_wort, &e_multi, TRUE);
   else
     wind_set( h_neues_wort, WF_TOP, 0, 0, 0, 0);
}

void m_trainer()
{
   if (h_trainer == 0)
     h_trainer = nf_do( w_trainer, TR_ANTWORT, FALSE, FALSE, *s_trainer,
                        b_trainer, &e_multi, TRUE);
   else
     wind_set( h_trainer, WF_TOP, 0, 0, 0, 0);
}

void cl_dialog()
{
   if (h_info != 0) nf_end( h_info, FALSE);
   if (h_woerterbuch != 0) nf_end( h_woerterbuch, FALSE);
   if (h_neues_wort != 0) nf_end( h_neues_wort, FALSE);
   if (h_trainer != 0) nf_end( h_trainer, FALSE);
}