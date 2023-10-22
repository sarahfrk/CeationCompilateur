/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~CREATION DE LA TABLE DES SYMBOLES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
//===============================Step 1: Definition des structures de donnees===============================
#include <stdio.h>
#include <stdlib.h>


typedef struct
{
   int state;
   char name[50];
   char code[50];
   char type[50];
   char utilise[50];
   float val;
   
 } element;

typedef struct
{
   int state;
   char name[50];
   char type[50];
} elt;

element tab[1000];
elt tabs[70],tabm[70];
extern char sav[50];
char chaine [] = "";
char chaine2 [] = "--";

//===============================Step 2: initialisation de l'etat des cases des tables des symbloles===============================
/*
0: la case est libre    
1: la case est occupée
*/

/*
--: l'entite n'est pas const
oui: l'entite est une const a une valeur
non: l'entite est une const n'a pas une valeur
*/
void initialisation()
{
  int i;
  for (i=0;i<1000;i++)
  {
    tab[i].state=0;
    strcpy(tab[i].type,chaine);
    strcpy(tab[i].utilise,chaine2);
  }
  for (i=0;i<70;i++)
    {tabs[i].state=0;
    tabm[i].state=0;}
}

//===============================Step 3: insertion des entitites lexicales dans Ts===============================
void inserer (char entite[], char code[],char type[],float val,int i,int y)
{
  switch (y)
 {
   case 0:/*insertion dans la table des IDF et CONST*/
       tab[i].state=1;
       strcpy(tab[i].name,entite);
       strcpy(tab[i].code,code);
     strcpy(tab[i].type,type);
     tab[i].val=val;
     
     break;

   case 1:/*insertion dans la table des mots clees*/
       tabm[i].state=1;
       strcpy(tabm[i].name,entite);
       strcpy(tabm[i].type,code);
       break;

   case 2:/*insertion dans la table des separateurs*/
      tabs[i].state=1;
      strcpy(tabs[i].name,entite);
      strcpy(tabs[i].type,code);
      break;
 }

}

//===============================Step 4: La fonction Rechercher permet de verifier si l'entitee existe d eja dans la Ts===============================
void rechercher (char entite[], char code[],char type[],float val,int y)
{

int j,i;

switch(y)
  {
   case 0:/*verifier si la case dans la tables des IDF et CONST est libre*/
        for (i=0; ((i<1000)&&(tab[i].state==1))&&(strcmp(entite,tab[i].name)!=0);i++);
        if((i<1000)&&(strcmp(entite,tab[i].name)!=0))
        {
      inserer(entite,code,type,val,i,0);
         }
        break;

   case 1:/*verifier si la case dans la tables des mots clés est libre*/

       for (i=0;((i<70)&&(tabm[i].state==1))&&(strcmp(entite,tabm[i].name)!=0);i++);
        if(i<70 &&(strcmp(entite,tabm[i].name)!=0))
          inserer(entite,code,type,val,i,1);
        break;

   case 2:/*verifier si la case dans la tables des séparateurs est libre*/
         for (i=0;((i<70)&&(tabs[i].state==1))&&(strcmp(entite,tabs[i].name)!=0);i++);
        if(i<70&&(strcmp(entite,tabs[i].name)!=0))
         inserer(entite,code,type,val,i,2);
        break;

    case 3:/*verifier si la case dans la tables des IDF et CONST est libre*/
        for (i=0;((i<1000)&&(tab[i].state==1))&&(strcmp(entite,tab[i].name)!=0);i++);

        if (i<1000)
        { inserer(entite,code,type,val,i,0); }
        else
          printf("entité existe déjà\n");
        break;
  }

}


//===============================Step 5 L'affichage du contenue de la Ts

void afficher()
{int i;
printf("\n\n\n/~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {LES TABLES DES SYMBOLES} ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~/\n\n");
printf("\n/================================Table des symboles IDF et VARIBLA================================/\n");
printf("__________________________________________________________________________________________________\n");
printf("\t|      Nom_Entite       |   Code_Entite  |  Type_Entite  |   Val_Entite  |    Const_Test|\n");
printf("__________________________________________________________________________________________________\n");

for(i=0;i<70;i++)
{
    if(tab[i].state==1)
      {
        printf("\t|%22s |%15s | %12s  | %12f  |  %10s  | \n",tab[i].name,tab[i].code,tab[i].type,tab[i].val,tab[i].utilise);
      }
}
printf("__________________________________________________________________________________________________\n");

printf("\n\n/================================Table des symboles des mots cles================================\n");
printf("_________________________________________\n");
printf("\t| NomEntite       |  CodeEntite | \n");
printf("_________________________________________\n");

for(i=0;i<70;i++)
    if(tabm[i].state==1)
      {
        printf("\t|%16s |%12s | \n",tabm[i].name, tabm[i].type);
      }
printf("_________________________________________\n");      

printf("\n\n/================================Table des symboles separateurs================================\n");
printf("___________________________________\n");
printf("\t| NomEntite |  CodeEntite | \n");
printf("___________________________________\n");

for(i=0;i<1000;i++)
    if(tabs[i].state==1)
      {
        printf("\t|%10s |%12s | \n",tabs[i].name,tabs[i].type );
      }
	  printf("___________________________________\n");
}


//***********************************************LA_DECLARATION_DES_FONCTIONS***********************************************


char* TypeDe(char entite[])
{
  int pos=rechercherEntite(entite);
  return tab[pos].type;
}


int rechercherEntite(char entite[])
{
  int i=0;
  while(i<1000)
  {
  if (strcmp(entite,tab[i].name)==0) return i;
  i++;
  }
  return -1;
}


void insererTYPE(char entite[], char type[])
{
  int pos;
  pos=rechercherEntite(entite);
  if(pos!=-1)  { strcpy(tab[pos].type,type); }
}


void insererTYPEConst(char entite[], char type[], char utilise[])
{
  int pos;
  pos=rechercherEntite(entite);
  if(pos!=-1)  { strcpy(tab[pos].type,type);  
                 strcpy(tab[pos].utilise,utilise);
			   }
}


int Declaration(char entite[])
{
  int pos;
  pos=rechercherEntite(entite);
  if(strcmp(tab[pos].type,"")==0) return 0;
  else return -1;
}


int DeclarationConst(char entite[])
{
  int pos;
  pos=rechercherEntite(entite);
  if(strcmp(tab[pos].utilise,"oui")==0) return 0;
  else return -1;
}


int DeclarationConst2(char entite[])
{
  int pos;
  pos=rechercherEntite(entite);
  if(strcmp(tab[pos].utilise,"non")==0) 
    return 0;
  else  
    return -1; 
}


inserer_const(char entite[]){
  int pos;
  pos=rechercherEntite(entite);
  strcpy(tab[pos].utilise,"oui");	
}
/*
char Getsing(char phrase[]){
	int x = strlen(phrase);
	char car = phrase[x-1];
	return car;
}
*/


int Accepter(char a [],char b [])
{
  int i=rechercherEntite(b);
  if(i!=-1)
    {
    if(a[0]=='$')
       {
         if(strcmp(tab[i].type,"INTEGER")!=0)
         {
           return -1;
         }
         else
         {
          return 0;
         }
          
       }  
  
  if(a[0]=='%')
       {
         if(strcmp(tab[i].type,"REAL")!=0)
         {
           return -1;
         }
         else
         {return 0;}
          
       }
     
  if(a[0]=='#')
       {
         if(strcmp(tab[i].type,"STRING")!=0)
         {
          return -1;
         }
         else
         {return 0;}
         
       }
  
  if(a[0]=='&')
       {
         if(strcmp(tab[i].type,"CHAR")!=0)
         {
           return -1;
         }
         else
         {return 0;}
     }
      
}
  else
{
return -1;}

}
