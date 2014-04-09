/* sichtbare Zeilen an einer bestimmten Position finden */

#include <stdio.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

#define U_GET_LINES  1

WORD get_top( qt, ty, by, zeile) /* oberste sichtbare Zeile */
register QUELLTEXT *qt;
register WORD ty, by;
register LONG *zeile;
{
   register LONG dif;

   dif = qt->w.ry+ty-qt->w.iy; /* Abstand in Pixeln zw. Textanfang und ty */
   *zeile = dif/phchar;
   if (*zeile >= qt->zeilenzahl)
   {
      *zeile = qt->zeilenzahl;
      return 1;
   }
   if (dif%phchar==0 && by-ty>=phchar)
     return 1; /* Zeile komplett sichtbar */
   else
     return 0; /* Zeile nur teilweise sichtbar */
}

WORD get_bottom( qt, ty, by, zeile) /* unterste sichtbare Zeile */
register QUELLTEXT *qt;
register WORD ty, by;
register LONG *zeile;
{
   register LONG dif;

   dif = qt->w.ry+by-qt->w.iy-1; /* Abstand in Pixeln zw. Textanfang und by */
   *zeile = dif/phchar;
   if (*zeile >= qt->zeilenzahl)
   {
      *zeile = qt->zeilenzahl-1;
      return 1;
   }
   if (dif%phchar==phchar-1 && by-ty>=phchar)
     return 1; /* Zeile komplett sichtbar */
   else
     return 0; /* Zeile nur teilweise sichtbar */
}

WORD get_left( qt, lx, rx, spalte) /* erste sichtbare Spalte */
register QUELLTEXT *qt;
register WORD lx, rx;
register WORD *spalte;
{
   register LONG dif;

   dif = qt->w.rx+lx-qt->w.ix; /* Abstand zw. Zeilenanfang und lx */
   *spalte = dif/pwchar;
   if (*spalte >= ZEILENBREITE)
   {
      *spalte = ZEILENBREITE;
      return 1;
   }
   if (dif%pwchar==0 && rx-lx>=pwchar)
     return 1; /* Spalte komplett sichtbar */
   else
     return 0;
}

WORD get_right( qt, lx, rx, spalte) /* letzte sichtbare Spalte */
register QUELLTEXT *qt;
register WORD lx, rx;
register WORD *spalte;
{
   register LONG dif;

   dif = qt->w.rx+rx-qt->w.ix-1; /* Abstand zw. Zeilenanfang und rx */
   *spalte = dif/pwchar;
   if (*spalte >= ZEILENBREITE)
   {
      *spalte = ZEILENBREITE-1;
      return 1;
   }
   if (dif%pwchar==pwchar-1 && rx-lx>=pwchar)
     return 1; /* Spalte komplett sichtbar */
   else
     return 0;
}