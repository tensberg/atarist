/* Prozeduren zur Dauer-Dialog-Darstellung */

#define UCE_DIALOG  1

#include <types.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

/* globale Variablen */
static WORD da_x, da_y, da_w, da_h; /* Dialogkoordinaten */
static char **da_info;
static char **da_dateiname;
static OBJECT *da_frame;
static OBJECT *da_interior;

void in_dauer() /* Dialog initialisieren */
{
   da_info = (char **) &((USERBLK *) i_dauer[DA_INFO].ob_spec)->ub_parm;
   da_dateiname = &((TEDINFO *) i_dauer[DA_DATEINAME].ob_spec)->te_ptext;
   da_frame = &i_dauer[DA_FRAME];
   da_interior = &i_dauer[DA_INTERIOR];
   form_center( i_dauer, &da_x, &da_y, &da_w, &da_h);
}

void op_dauer( info, name) /* Dauer-Dialog ”ffnen */
char *info; /* Infozeile */
char *name; /* Dateiname */
{
   da_interior->ob_width = 2;
   *da_info = info;
   *da_dateiname = name;
   wind_update( BEG_UPDATE);
   form_dial( FMD_START, da_x, da_y, da_w, da_h, da_x, da_y, da_w, da_h);
   graf_mouse( M_OFF);
   objc_draw( i_dauer, 0, MAX_DEPTH, da_x, da_y, da_w, da_h);
   graf_mouse( M_ON);
}

void up_dauer( teil, gesamt) /* Dauer-Dialog aktualisieren */
register ULONG teil, gesamt;
{
   da_interior->ob_width = da_frame->ob_width*teil/gesamt;
   graf_mouse( M_OFF);
   objc_draw( i_dauer, DA_INTERIOR, MAX_DEPTH, da_x, da_y, da_w, da_h);
   graf_mouse( M_ON);
}

void cl_dauer() /* Dauer-Dialog schliežen */
{
   form_dial( FMD_FINISH, da_x, da_y, da_w, da_h, da_x, da_y, da_w, da_h);
   wind_update( END_UPDATE);
}