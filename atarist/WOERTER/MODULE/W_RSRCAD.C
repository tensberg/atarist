/* Objektadressen ermitteln */

#include <stdio.h>
#include <gemfast.h>
#include <window.h>
#include <w_header.h>

void in_rsrcaddr()
{
   rsrc_gaddr( R_TREE, M_MENUE, &m_menue);
   rsrc_gaddr( R_TREE, W_INFO, &w_info);
   rsrc_gaddr( R_TREE, W_WOERTERBUCH, &w_woerterbuch);
   rsrc_gaddr( R_TREE, W_NEUES_WORT, &w_neues_wort);
   rsrc_gaddr( R_TREE, W_TRAINER, &w_trainer);
   rsrc_gaddr( R_FRSTR, S_INFO, &s_info);
   rsrc_gaddr( R_FRSTR, S_WOERTERBUCH, &s_woerterbuch);
   rsrc_gaddr( R_FRSTR, S_NEUES_WORT, &s_neues_wort);
   rsrc_gaddr( R_FRSTR, S_TRAINER, &s_trainer);
   rsrc_gaddr( R_FRSTR, S_NICHT_GEFUNDEN, &s_nicht_gefunden);
}