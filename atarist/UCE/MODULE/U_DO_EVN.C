/* do_evnt() wird von ne_multi() aufgerufen und verarbeitet eine AES-Message
   */

#define UCE_DO_EVNT  1

#include <stdio.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

WORD do_evnt( e_multi)
register E_MULTI *e_multi;
{
   WORD not_done;
   register WORD *mbuf;

   mbuf = e_multi->mepbuff;
   not_done = nw_chkmesag( mbuf);
   if (!not_done) return; /* Message ausgefhrt */

   if (mbuf[0] == MN_SELECTED) /* Menuepunkt gew„hlt */
     me_domenu( mbuf[3], mbuf[4]);

   return 0;
}