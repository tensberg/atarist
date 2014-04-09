/* UCE-Modul INIT_OBJC_ADDRESS ermittelt die Objektadressen und besetzt die
   globalen Variaben */

#define INIT_OBJC_ADDRESS  1

#include <stdio.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

WORD in_objc_addr()
{
   WORD ok;

   ok  = rsrc_gaddr( R_TREE, HAUPTMENUE, &hauptmenue);
   ok &= rsrc_gaddr( R_TREE, W_INFO, &w_info);
   ok &= rsrc_gaddr( R_TREE, W_FTASTEN, &w_ftasten);
   ok &= rsrc_gaddr( R_TREE, W_EDITMODI, &w_editmodi);
   ok &= rsrc_gaddr( R_TREE, W_EINSTELL, &w_einstell);
   ok &= rsrc_gaddr( R_TREE, W_WOERTER, &w_woerter);
   ok &= rsrc_gaddr( R_TREE, W_DATEIEN, &w_dateien);
   ok &= rsrc_gaddr( R_TREE, D_SUCHEN, &d_suchen);
   ok &= rsrc_gaddr( R_TREE, D_ERSETZEN, &d_ersetzen);
   ok &= rsrc_gaddr( R_TREE, D_ZU_ZEILE, &d_zu_zeile);
   ok &= rsrc_gaddr( R_TREE, D_B_SCHIEB, &d_b_schieb);
   ok &= rsrc_gaddr( R_TREE, D_DRUCKEN, &d_drucken);
   ok &= rsrc_gaddr( R_TREE, D_TABWEITE, &d_tabweite);
   ok &= rsrc_gaddr( R_TREE, D_ZEILENUMBRUCH, &d_zeilenumbruch);
   ok &= rsrc_gaddr( R_TREE, D_DA_VORHANDEN, &d_da_vorhanden);
   ok &= rsrc_gaddr( R_TREE, P_FENSTER, &p_fenster);
   ok &= rsrc_gaddr( R_TREE, P_MSETZEN, &p_msetzen);
   ok &= rsrc_gaddr( R_TREE, P_ZUMARKE, &p_zumarke);
   ok &= rsrc_gaddr( R_TREE, I_DAUER, &i_dauer);
   ok &= rsrc_gaddr( R_FRSTR, A_INIT, &a_init);
   ok &= rsrc_gaddr( R_FRSTR, A_NO_MEMORY, &a_init);
   ok &= rsrc_gaddr( R_FRSTR, A_NO_WINDOW, &a_no_window);
   ok &= rsrc_gaddr( R_FRSTR, S_INFOZEILE, &s_infozeile);
   ok &= rsrc_gaddr( R_FRSTR, S_DATEI_OEFFNEN, &s_d_oeffnen);
   ok &= rsrc_gaddr( R_FRSTR, S_SICHERN_UNTER, &s_d_si_unter);
   ok &= rsrc_gaddr( R_FRSTR, S_TEXT_LADEN, &s_t_laden);
   ok &= rsrc_gaddr( R_FRSTR, S_TEXT_SICHERN, &s_t_sichern);
   ok &= rsrc_gaddr( R_FRSTR, S_TEXT_LOESCHEN, &s_t_loeschen);
   ok &= rsrc_gaddr( R_FRSTR, S_NICHT_GEFUNDEN, &s_n_gefunden);
   ok &= rsrc_gaddr( R_FRSTR, S_WO_LADEN, &s_wo_laden);
   ok &= rsrc_gaddr( R_FRSTR, S_ERLAUBT, &s_erlaubt);

   return (ok);
   /* wenn bei rsrc_gaddr ein Fehler auftritt ist der Return-Wert 0, durch
      die Undierung bleibt ok bis zum Prozedurende 0 */
}