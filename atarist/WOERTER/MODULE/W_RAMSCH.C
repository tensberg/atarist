/* verschiedende Prozeduren und Funktionen */

#include <stdio.h>
#include <malloc.h>
#include <osbind.h>
#include <gemfast.h>
#include <window.h>
#include <w_header.h>

/* externe Funktionen */
extern void woerter();

void sel_object( w, tree, obnr, flag) /* Objekt selektieren */
register WINDOW *w; /* Fenster, in dem das Objekt ist */
register OBJECT *tree; /* Objektbaum */
register WORD obnr; /* Objektnummer */
WORD flag; /* 0 : deselektieren, 1 : selektieren */
{
   WORD px, py; /* Redraw-Position */
   register OBJECT *obj;

   obj = &tree[obnr];
   if (flag)
     obj->ob_state |= SELECTED;
   else
     obj->ob_state &= ~SELECTED;

   if (w != NULL) /* Objekt neu zeichnen */
   {
      objc_offset( tree, obnr, &px, &py);
      nw_redraw( w, 0, (LONG) px, (LONG) py, (LONG) obj->ob_width,
                (LONG) obj->ob_height);
   }
}

WORD selected( tree, obnr) /* prft, ob Objekt selektiert ist */
register OBJECT *tree;
register WORD obnr;
{
   return (tree[obnr].ob_state & SELECTED);
}

WORD more_entries()
{
   register char *speicher;

   speicher = lalloc( (LONG) sizeof(ENTRY)*(max_entries+50));
   if (speicher == NULL) return NO_MEMORY;

   if (max_entries > 0)
   {
      lmemcpy( speicher, entry, (LONG) sizeof(ENTRY)*max_entries);
      free( entry);
   }
   entry = (ENTRY *) speicher;
   max_entries += 50;

   return NO_ERROR;
}

WORD more_liste( liste, max)
register WORD **liste;
register WORD *max;
{
   register char *speicher;

   speicher = realloc( *liste, sizeof(WORD)*(*max+50));
   if (speicher == NULL) return NO_MEMORY;

   *max += 50;
   *liste = (WORD *) speicher;

   woerter();

   return NO_ERROR;
}

void pling() /* Signalton */
{
   register WORD handle;

   handle = Fopen( "CON:", 1); /* Datei zur Ausgabe auf Bildschirm ”ffnen */
   Fwrite( handle, 1L, ""); /* Signalton */
   Fclose( handle);
}

void to_language( sprache, liste, anz, max)
register WORD sprache;
register WORD ***liste;
register WORD **anz, **max;
{
   if (sprache == ENGLISCH)
   {
      *liste = &liste_e_d;
      *anz = &anz_e_d;
      *max = &max_e_d;
   }
   else
   {
      *liste = &liste_d_e;
      *anz = &anz_d_e;
      *max = &max_d_e;
   }
}

void ins_index( liste, anz, max, pos, num)
register WORD **liste;
register WORD *anz, *max;
register WORD pos, num;
{
   if (*anz == *max) more_liste( liste, max);

   if (pos != *anz)
     lmemmove( &(*liste)[pos+1], &(*liste)[pos], (LONG) sizeof(WORD)*
               (*anz-pos));

   (*liste)[pos] = num;

   (*anz)++;
}