%{ 
#include "syntaxique.tab.h"
#include "TableSymbole.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
extern nb_ligne;
extern Col;
extern YYSTYPE yylval;
char cst[20];
%}



lettreM [A-Z]
lettre [a-zA-Z]
chiffre [0-9]
IDF {lettreM}({lettre}|{chiffre})*
Nomprgm {IDF}\.
typeinteger [+-]?\(([0-9]|[0-9][0-9]|[0-9][0-9][0-9]|[0-9][0-9][0-9][0-9]|[1-2][0-9][0-9][0-9]|3[0-1][0-9][0-9][0-9]|32[0-6][0-9][0-9]|327[0-5][0-9]|3276[0-7])\)|"(-"32768\)|([0-9]|[0-9][0-9]|[0-9][0-9][0-9]|[0-9][0-9][0-9][0-9]|[1-2][0-9][0-9][0-9]|3[0-1][0-9][0-9][0-9]|32[0-6][0-9][0-9]|327[0-5][0-9]|3276[0-7])|\(([+]|-)([1-9]{chiffre}*|0)\)
typefloat \([+-]?[0-9]+\,[0-9]+\)|[0-9]+\,[0-9]+
typechar \'.\'
typestring  \"[^"]+\"
phrase_dol  \".*$\"
phrase_pourc  \".*%\"
phrase_dz  \".*#\"
phrase_et  \".*&\"
Sign         \"(#|$|&|%)\"
commentaire #([^!]+)!     
guillemets  "\""



%%
IDENTIFICATEUR    {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext);  printf("\n*******L\'entite reconnue est: (-- %s --) <==> mot cle\n\n",yytext);  return mc_idf; }
DIVISION.         {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext);  printf("\n*******L\'entite reconnue est: (-- %s --) <==> mot cle\n\n",yytext);  return mc_div;}
"PROGRAM-ID."     {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext);  printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext);  return mc_prgm;}
DATA              {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext);  printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_data;}
WORKING-STORAGE   {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext);  printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext);  return mc_work; }
SECTION.          {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext);  printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_section; }
PROCEDURE         {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext);  printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_proc; }
STOP              {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext);  printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext);  return mc_stop; }
RUN               {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext);  printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_run;}
COMPUTE           {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext);  printf("\n*******L\'entite reconnue est: (-- %s --) <==> mot cle\n\n",yytext);  return mc_compute; }


INTEGER           {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); yylval.str=strdup(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext);    return mc_integer;}
FLOAT             {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); yylval.str=strdup(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext);     return mc_float;}
CHAR              {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); yylval.str=strdup(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext);    return mc_char;}
STRING            {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); yylval.str=strdup(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext);    return mc_string;}
CONST             {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext);      return mc_const;}


ACCEPT  {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_accept; }
DISPLAY {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_display; }


IF   {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext);  return mc_if;}
ELSE {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_else;}
END  {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_end;}


LINE {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_line; }
SIZE {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_size; }


MOVE {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_move;}
TO   {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_to;}


NOT     {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_not;}
".AND." {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_and;}
".OR."  {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext);  return mc_or;}
".GE."  {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_ge;}
".G."   {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_g;}
".L."   {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_l;}
".LE."  {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_le;}
".EQ."  {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_eq;}
".DI."  {rechercher(yytext,"Mot cle",0,0, 1); Col= Col + strlen(yytext); printf("\n*******L\'entite reconnue est: (-- %s --)<==> mot cle \n\n",yytext); return mc_di;}




{IDF} { 
	    rechercher(yytext,"IDF","",0, 0);
        if(yyleng>7) printf("\n*******Erreur lexical: IDF trop long: (-- %s --), la ligne %d, la colonne %d\n\n",yytext,nb_ligne,Col);
          else printf("\n*******L\'entite reconnue est: (-- %s --) <==> identificateur \n\n",yytext);
		yylval.str=strdup(yytext);
		Col= Col + strlen(yytext);
		printf("IDF reconnu %s\n",yytext);
		return idf;
      }
	  
{Sign}      {
                cst[0]=yytext[1];

             yylval.str=strdup(cst); strcpy(cst,"              ");
             rechercher (yytext,"Sign","Sign",atoi(yytext), 0);  Col = Col + strlen(yytext); 
             printf ("\n*******L\'entite reconnue est: (-- %s --) \n", yytext); 
             return sign;
            }
	  


{phrase_dol}   { Col= Col + strlen(yytext); yylval.str=strdup(yytext);  return phrase_dol;}
{phrase_dz}    { Col= Col + strlen(yytext); yylval.str=strdup(yytext);  return phrase_dz;}
{phrase_et}    { Col= Col + strlen(yytext); yylval.str=strdup(yytext);  return phrase_et;}
{phrase_pourc} { Col= Col + strlen(yytext); yylval.str=strdup(yytext);  return phrase_pourc;}



{typeinteger} { yylval.entier=atoi(yytext);        rechercher(yytext,"Entier","INTEGER",atoi(yytext),0);  Col= Col + strlen(yytext);      printf("\n*******L\'entite reconnu: (-- %s --) <==> integer \n\n",yytext); return type_integer;}
{typefloat}   { yylval.reel=atof(yytext);          rechercher(yytext,"Reel","FLOAT",atoi(yytext),0);      Col= Col + strlen(yytext);      printf("\n*******L\'entite reconnu: (-- %s --) <==> float \n\n",yytext);    return type_float;}
{typechar}    { yylval.str=strdup(yytext);         rechercher(yytext,"Character","CHAR",atoi(yytext),0);  Col= Col + strlen(yytext);      printf("\n*******L\'entite reconnu: (-- %s --) <==> caractere \n\n",yytext);     return type_char;}
{typestring}  { yylval.str=strdup(yytext);         rechercher(yytext,"Chaine","STRING",atoi(yytext),0);   Col= Col + strlen(yytext);      printf("\n*******L\'entite reconnu: (-- %s --) <==> string \n\n",yytext);   return type_string;}
{commentaire} { Col= Col + strlen(yytext);
	                  int z=strlen(yytext);
                    int j=1;
                    int c=0;
                    while(j<=z)
                    {
                        if(yytext[j]=='\n')
                            c++;
                        j++;
                    } 
                     
                nb_ligne=nb_ligne+c;     c=0;    
                    
}


"="  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); printf("\n< %s > reconnu!\n\n",yytext); return egal;}
";"  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); printf("\n< %s > reconnu!\n\n",yytext); return pvg;}
","  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); printf("\n< %s > reconnu!\n\n",yytext); return vrg;}
"+"  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); yylval.str=strdup(yytext); printf("\n< %s > reconnu!\n\n",yytext); return plus;}
"-"  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); yylval.str=strdup(yytext); printf("\n< %s > reconnu!\n\n",yytext); return moins;}
"*"  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); yylval.str=strdup(yytext); printf("\n< %s > reconnu!\n\n",yytext); return multiple;}
"/"  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); yylval.str=strdup(yytext); printf("\n< %s > reconnu!\n\n",yytext); return division;}
"("  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); printf("\n< %s > reconnu!\n\n",yytext);  return p_ouvre;}
")"  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); printf("\n< %s > reconnu!\n\n",yytext);  return p_ferme;}
"."  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); printf("\n< %s > reconnu!\n\n",yytext);  return point;}
"'"  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); printf("\n< %s > reconnu!\n\n",yytext);  return apostrophes;}
":"  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); printf("\n< %s > reconnu!\n\n",yytext);  return deuxp;}
"|"  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); printf("\n< %s > reconnu!\n\n",yytext);  return separateur;}
"@"  { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); printf("\n< %s > reconnu!\n\n",yytext);  return arob;}
"{guillemets}" { rechercher(yytext,"Mot cle",0,0,2); Col= Col + strlen(yytext); printf("\n< %s > reconnu!\n\n",yytext);  return guillemets;}



[ \t] {Col = Col + strlen(yytext);}

\n { Col = 1;
 nb_ligne++;
}
. printf("\n\n================================erreur lexical a la ligne %d  la colone %d entite %s================================ \n",nb_ligne,Col, yytext);
