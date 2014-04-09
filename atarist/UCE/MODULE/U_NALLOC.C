/* Routinen zur Speicherverwaltung */

#define UCE_NALLOC  1

#include <stdio.h>
#include <malloc.h>
#include <osbind.h>
#include <gemfast.h>
#include <window.h>
#include <uceinc.h>

#define BLKSIZE  32000L /* Grîûe eines allozierten Speicherblocks */

typedef struct {
  char *mem_start; /* Start des Speicherbereichs */
  char *mem_end;   /* Ende des Speicherbereichs */
  } MEMBLOCK;

/* globale Variablen */
static MEMBLOCK *usedmem = NULL;
static MEMBLOCK *freemem = NULL;
static WORD anz_free = 0;
static WORD max_free = 0;
static WORD anz_used = 0;
static WORD max_used = 0;
static WORD anz_alloc = 0; /* Anzahl allozierter Speicherblîcke */
static char **alloc = NULL; /* Liste von Betriebssystem-Speicherblîcken */

static MEMBLOCK *new_free() /* neuen free-Eintrag erzeugen */
{
   char *temp;
   register MEMBLOCK *free;

   if (anz_free == max_free)
   {
      if (max_free >= 32747) return NULL; /* sonst öberlauf */
      temp = realloc( freemem, sizeof(MEMBLOCK)*(max_free+20));
      if (temp == NULL) return NULL; /* kein freier Speicher mehr */
      freemem = (MEMBLOCK *) temp;
      max_free += 20;
   }

   /* Feld mit allozierten Speicherblîcken vergrîûern */
   temp = realloc( alloc, sizeof(char *)*(anz_alloc+1));
   if (temp == NULL) return NULL;
   alloc = (char **) temp;

   /* neuen Speicherblock vom Betriebssystem allozieren */
   free = &freemem[anz_free];
   free->mem_start = (char *) Malloc( BLKSIZE);
   if (free->mem_start == 0) return NULL; /* Speicher alle */
   free->mem_end = free->mem_start+BLKSIZE;
   alloc[anz_alloc++] = free->mem_start;
   anz_free++;

   return free;
}

static WORD make_free( mem_start, mem_end)
register char *mem_start, *mem_end;
{
   char *temp;
   register MEMBLOCK *free;

   if (anz_free == max_free) /* free-Feld vergrîûern */
   {
      if (max_free >= 32747) return -1; /* sonst öberlauf */
      temp = realloc( freemem, sizeof(MEMBLOCK)*(max_free+25));
      if (temp == NULL) return -1; /* kein freier Speicher mehr */
      freemem = (MEMBLOCK *) temp;
      max_free += 25;
   }

   free = &freemem[anz_free];
   free->mem_start = mem_start;
   free->mem_end = mem_end;

   return anz_free++;
}

static char *make_used( mem_start, mem_end)
register char *mem_start, *mem_end;
{
   char *temp;
   register MEMBLOCK *used;

   if (anz_used == max_used) /* used-Feld vergrîûern */
   {
      if (max_used >= 32747) return NULL; /* sonst öberlauf */
      temp = realloc( usedmem, sizeof(MEMBLOCK)*(max_used+25));
      if (temp == NULL) return NULL; /* kein freier Speicher mehr */
      usedmem = (MEMBLOCK *) temp;
      max_used += 25;
   }

   used = &usedmem[anz_used++];
   used->mem_start = mem_start;
   used->mem_end = mem_end;

   return mem_start;
}

static void del_free( nr) /* free-Eintrag aus der Liste lîschen */
register WORD nr;
{
   lmemmove( &freemem[nr], &freemem[nr+1], (LONG) sizeof(MEMBLOCK)*
            (--anz_free-nr));
}

static void del_used( nr) /* used-Eintrag aus der Liste lîschen */
register WORD nr;
{
   lmemmove( &usedmem[nr], &usedmem[nr+1], (LONG) sizeof(MEMBLOCK)*
            (--anz_used-nr));
}

static void del_alloc( nr) /* used-Eintrag aus der Liste lîschen */
register WORD nr;
{
   lmemmove( &alloc[nr], &alloc[nr+1], (LONG) sizeof(char *)*
             (--anz_alloc-nr));
}

/* -------- nach auûen sichtbare Prozeduren -------- */
char *nalloc( size)
register WORD size;
{
   register WORD i = 0; /* ZÑhlvariable */
   register char *speicher; /* Adresse des freien Speichers */
   register char *sp_end; /* Ende des freichen Speichers */
   register MEMBLOCK *free, *used;
   register MEMBLOCK *loblk, *hiblk;
   register WORD loind = -1, hiind = -1; /* an Speicherblock grenzende used-
                                            blîcke */

   /* Freien Speicher suchen */
   while (i<anz_free && freemem[i].mem_end-freemem[i].mem_start<size)
     i++;

   if (i == anz_free) /* kein freier Speicher gefunden */
   {
      free = new_free(); /* neuen free-Block erzeugen */
      if (free == NULL) return NULL;
   }
   else
     free = &freemem[i];

   speicher = free->mem_start;
   free->mem_start += size;
   if (free->mem_start == free->mem_end-1)
     del_free( i); /* free-Eintrag lîschen */

   /* an Speicherblock angrenzende used-EintrÑge finden */
   i = 0;
   while (i<anz_used && (loind==-1 || hiind==-1))
   {
      used = &usedmem[i];
      if (used->mem_end == speicher) loind = i;
      if (used->mem_start == free->mem_end) hiind = i;
      i++;
   }

   /* Speicher in angrenzende Blîcke integrieren */
   if (loind != -1)
   {
      loblk = &usedmem[loind];
      if (hiind != -1) /* Speicher liegt genau zwischen zwei used-Blîcken */
      {
         hiblk = &usedmem[hiind];
         loblk->mem_end = hiblk->mem_end;
         del_used( hiind);
      }
      else /* Speicher liegt genau hinter einem used-Block */
        loblk->mem_end += size;
   }
   else /* loind == -1 */
     if (hiind != -1) /* Speicher liegt genau vor einem used-Block */
     {
        hiblk = &usedmem[hiind];
        hiblk->mem_start = speicher;
     }
     else /* loind == hiind == -1 */
       speicher = make_used( speicher, speicher+size); /* im Fehlerfall NULL */

   return speicher;
}

void nfree( mem_start, size)
register char *mem_start;
register WORD size;
{
   register char *mem_end;
   register MEMBLOCK *used, *free;
   register WORD i = 0;
   register MEMBLOCK *loblk, *hiblk;
   register WORD loind = -1, hiind = -1;
   register WORD ind; /* Index fÅr freeblock, der mîglicherweise ans Betriebs-
                         system zurÅckgegeben werden kînnte */

   mem_end = mem_start+size;
   while (i<anz_used && (mem_start<usedmem[i].mem_start ||
          mem_end>usedmem[i].mem_end))
     i++;

   if (i == anz_used) return; /* falsche Adresse */

   used = &usedmem[i];

   if (mem_start == used->mem_start)
     if (mem_end == used->mem_end)
       del_used( i); /* Block ganz freigeben */
     else
       used->mem_start = mem_end; /* Block verkleinern */
   else
     if (mem_end == used->mem_end)
       used->mem_end = mem_start; /* Block verkleinern */
     else /* Block aufsplitten */
     {
        make_used( mem_end, used->mem_end);
        used->mem_end = mem_start;
     }

   /* an Block angrenzende free-EintrÑge finden */
   i = 0;
   while ( i<anz_free && (hiind==-1 || loind==-1))
   {
      free = &freemem[i];
      if (free->mem_end == mem_start) loind = i;
      if (free->mem_start == mem_end) hiind = i;
      i++;
   }

   /* Speicher in angrenzende Blîcke integrieren */
   if (loind != -1)
   {
      ind = loind;
      loblk = &freemem[loind];
      if (hiind != -1) /* Speicher liegt genau zwischen zwei free-Blîcken */
      {
         hiblk = &freemem[hiind];
         loblk->mem_end = hiblk->mem_end;
         del_free( hiind);
         if (hiind < ind) ind--;
      }
      else /* Speicher liegt genau hinter einem free-Block */
        loblk->mem_end = mem_end;

      mem_start = loblk->mem_start;
      mem_end = loblk->mem_end;
   }
   else /* loind == -1 */
     if (hiind != -1) /* Speicher liegt genau vor einem free-Block */
     {
        ind = hiind;
        hiblk = &freemem[hiind];
        hiblk->mem_start = mem_start;
        mem_end = hiblk->mem_end;
     }
     else /* loind == hiind == -1 ; neuen free-Block erzeugen */
     {
        ind = make_free( mem_start, mem_end);
        if (ind == -1) return NO_MEMORY;
     }

   /* Untersuchen, ob Speicherblock ans Betriebssystem zurÅckgegeben
      werden kann */
   if (mem_end-mem_start != BLKSIZE) return NO_ERROR;
   i = 0;
   while (i<anz_alloc && alloc[i]!=mem_start)
     i++;

   if (i == anz_alloc) return NO_ERROR;

   Mfree( mem_start);
   del_alloc( i);
   del_free( ind);

   return NO_ERROR;
}

void free_all()
{
   register WORD i;

   for ( i=0; i<anz_alloc; i++)
     Mfree( alloc[i]);
}