/* Einstellungen laden */

#define UCE_LD_EINSTELL  1

#include <stdio.h>
#include <osbind.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

void ld_einstell()
{
   ei_warnton = selected( w_einstell, EI_WARNTON);
   ei_cursor_blinkt = selected( w_einstell, EI_CURSOR_BLINKT);
   ei_bytegrenze = selected( w_einstell, EI_BYTEGRENZE);
   ei_growshrink = selected( w_einstell, EI_GROWSHRINK);
   ed_einfuegen = selected( w_editmodi, ED_EINFUEGEN);
   ed_z_einfuegen = selected( w_editmodi, ED_Z_EINFUEGEN);
   ed_zeilenrest = selected( w_editmodi, ED_ZEILENREST);
   ed_einruecken = selected( w_editmodi, ED_EINRUECKEN);
   ed_zeilenumbruch = selected( w_editmodi, ED_ZEILENUMBRUCH);
   ed_umbruchbreite = ZEILENBREITE;
   wo_resident = selected( w_woerter, WO_RESIDENT);
   gemklemmbrett = 0;
}