%{
 int nb_ligne=1, Col=1;
 int sauvConst; 
 char sauvOpr[50];
 char sauvType[50];
 char sauvType2[50];
 float sauvVal;
 char sauvNomTab[50];
 int verifier=0;
 char sauveIdf[10];
 char sauvesigne[5];
 char motconst[10];
 char sauvPhrase[100];
 char signedisp[5];
%}

%union{
    int entier;
    float reel; 
    char* str;
} 

%token mc_idf mc_div mc_prgm mc_data mc_work mc_section mc_proc mc_stop mc_run <str>mc_integer <str>mc_float 
<str>mc_char <str>mc_string mc_const mc_accept mc_display mc_if mc_else mc_end mc_line mc_size mc_move mc_to
 mc_not mc_and mc_or mc_ge mc_g mc_l mc_le mc_eq mc_di <entier>type_integer <reel>type_float <str>idf egal pvg
vrg <str>plus <str>moins <str>multiple <str>division p_ouvre p_ferme point guillemets apostrophes 
deuxp type_char type_string separateur arob <str>phrase_dol <str>phrase_dz <str>phrase_pourc <str>phrase_et <str>sign mc_compute

%left mc_or
%left mc_and
%right mc_not
%left plus moins
%left multiple division


%start S

%%
S: mc_idf mc_div mc_prgm idf point mc_data mc_div mc_work mc_section LIST_DEC mc_proc mc_div LIST_INST mc_stop mc_run
      {     printf("________________________________________________________________________________________\n");
        printf("\n================= {PROGRAMME~~~~~~~~~~SYNTAXIQUEMENT~~~~~~~~~~CORRECT} =================\n");
             printf("________________________________________________________________________________________\n\n\n\n");YYACCEPT; }
;


/*=====================================================================================================
                                                         PARTIE 1
  =====================================================================================================
*/ 


LIST_DEC: DEC  LIST_DEC 
         |
;

DEC:LIST_IDF
   |DEC_TAB
   |DEC_CONST
;

//constants---------------------------
DEC_CONST: mc_const LIST_CONST point{strcpy(motconst,"CONST");}
         | mc_const idf TYPE point{
            strcpy(motconst,"CONST");
    if(Declaration($2)==0){ 
        if(strcmp(sauvType,"INTEGER")==0) insererTYPEConst($2, "INTEGER", "non"); 
          else if(strcmp(sauvType,"FLOAT")==0) insererTYPEConst($2, "FLOAT", "non"); 
              else if(strcmp(sauvType,"CHAR")==0) insererTYPEConst($2, "CHAR", "non"); 
                  else if(strcmp(sauvType,"STRING")==0) insererTYPEConst($2, "STRING", "non"); 
  }else{
              printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");  
          printf("ERREUR SEMANTIQUE: double declaration de --<%s>-- a la ligne [%d] la colonne [%d]\n",$2,nb_ligne,Col); 
              printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
          }
}
;


LIST_CONST: CONSTT separateur LIST_CONST
          | CONSTT
          |
;

CONSTT: idf egal TYPE_CONST {
    if(Declaration($1)==0)
        insererTYPEConst($1,sauvType2,"oui");
        else{
              printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");  
          printf("ERREUR SEMANTIQUE: double declaration de %s a la ligne [%d] la colonne [%d]\n",$1,nb_ligne,Col); 
              printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
          }
}
; 

TYPE_CONST: type_integer{ sauvConst=$1;  strcpy(sauvType2,"INTEGER");} 
          | type_float  { sauvConst=$1;  strcpy(sauvType2,"FLOAT");}  
          | type_char   {strcpy(sauvType2,"CHAR");} 
          | type_string {strcpy(sauvType2,"STRING");}
;

//les tableau-----------------------------
DEC_TAB: LIST_TAB TYPE point
;

LIST_TAB: TAB separateur LIST_TAB
        | TAB 
;

TAB: idf mc_line type_integer vrg mc_size type_integer {
    if(Declaration($1)==0) 
        insererTYPE($1,sauvType); 
        else{ 
             printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
         printf("ERREUR SEMANTIQUE: double declaration de %s a la ligne [%d] la colonne [%d]\n",$1,nb_ligne,Col); 
             printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
         }

 if(($3<0) || ($6<0)){ 
        printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
    printf("ERREUR SEMANTIQUE: (taille | borne_inf) du tableau doit etre positive : a la ligne [%d] la colonne [%d]\n",nb_ligne,Col);
        printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
 }

 if($3>$6){
        printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
    printf("ERREUR SEMANTIQUE: la taille du tableau doit etre superieur a sa borne inferieur : a la ligne [%d] la colonne [%d]\n",nb_ligne,Col);
        printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
 }
 strcpy(sauvNomTab,$1);
} 
;


//les varibales------------------------------------ 
LIST_IDF: idf separateur LIST_IDF{
 if(Declaration($1)==0) 
    insererTYPE($1,sauvType); 
    else { printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
     printf("ERREUR SEMANTIQUE: double declaration de --<%s>-- a la ligne [%d] la colonne [%d]\n",$1,nb_ligne,Col); 
         printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
     }
}
        | idf TYPE point { 
           if(Declaration($1)==0)  
            insererTYPE($1,sauvType);
            else{ printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
             printf("ERREUR SEMANTIQUE: double declaration de --<%s>-- a la ligne [%d] la colonne [%d]\n",$1,nb_ligne,Col);
                 printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
                 }
}
;        



TYPE : mc_integer {strcpy(sauvType,"INTEGER");}
     | mc_float   {strcpy(sauvType,"FLOAT");}
     | mc_char    {strcpy(sauvType,"CHAR");}
     | mc_string  {strcpy(sauvType,"STRING");}
; 








/*=====================================================================================================
                                                     PARTIE 2
  =====================================================================================================
*/









//=========================================================
// ********************LES INSTRUCTIONS********************
//=======================================================

LIST_INST: INST  
;

INST: INST_OPR_LOG_COMP INST
    | mc_compute AFFECTATION point INST
    | ENTREE INST
    | SORTIE INST
    | IF INST
    | BOUCLE INST
    | 
;

INST_OPR_LOG_COMP: p_ouvre EXPRESSION OPERATEUR_LOGIQUE_COMP EXPRESSION p_ferme 
                 | p_ouvre mc_not EXPRESSION p_ferme 
;


OPERATEUR_LOGIQUE_COMP: mc_and
                      | mc_or
                      | mc_di
                      | mc_ge
                      | mc_l
                      | mc_le
                      | mc_eq
                      | mc_g 
;




EXPRESSION: p_ouvre E OPERATEUR E p_ferme 
          | TYPE_CONST    
          | AUTRE
          | idf
;

E: p_ouvre EXPRESSION p_ferme
 | TYPE_CONST 
;

AUTRE:  TYPE_CONST OPERATEUR AUTRE2    
;                            

AUTRE2: AUTRE
      | TYPE_CONST
;      
 

//affectation-----------------------------------------------------------
AFFECTATION: idf egal EXPRESSION_AFF   {
                    if(Declaration($1)==0) {
                          printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");       
                        printf("\nERREUR SEMANTIQUE: Non declaration de --<%s>-- a la ligne [%d] la colonne [%d]\n",$1,nb_ligne,Col);
                          printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
                    }
                    //Dans le cas de la 1ere declaration CONST nom_const = valeur.
                    if(DeclarationConst($1)==0){
                        printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");       
                        printf("\nERREUR SEMANTIQUE: --<%s>-- de type constant : pas de possibilite d'affectation a la ligne [%d] la colonne [%d]\n",$1,nb_ligne,Col);
                          printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
                    }
                    //Dans le cas de la 2eme declaration CONST nom_const TYPE.
                    if(DeclarationConst2($1)==0){
                        if(strcmp(motconst,"CONST")==0) {inserer_const($1); strcpy(motconst,"");} 
                       }

                    if(verifier==0)
                    {
                    char *val1=(char*)TypeDe($1);
                    if (strcmp(val1,sauvType2)!=0){
                          printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                        printf("\nERREUR SEMANTIQUE: Incompatible type de --<%s>-- n'est pas de type --<%s>-- a la ligne [%d] la colonne [%d]\n",$1,sauvType2,nb_ligne,Col);
                          printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
                      }
                    }
                    else{
                        verifier=0;
                        char *val1=(char*)TypeDe($1);
                        char *val2=(char*)TypeDe(sauveIdf);
                        if (strcmp(val1,val2)!=0){
                          printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                        printf("\nERREUR SEMANTIQUE: Incompatible type de --<%s>-- avec --<%s>-- a la ligne [%d] la colonne [%d]\n",$1,sauveIdf,nb_ligne,Col);
                          printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
                      }
                    }
                }     
           | idf egal OPERANDE   
                {
                    if(Declaration($1)==0) {
                          printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");       
                        printf("\nERREUR SEMANTIQUE: Non declaration de --<%s>-- a la ligne [%d] la colonne [%d]\n",$1,nb_ligne,Col);
                          printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
                    }
                    //Dans le cas de la 1ere declaration CONST nom_const = valeur.
                    if(DeclarationConst($1)==0){
                        printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");       
                        printf("\nERREUR SEMANTIQUE: --<%s>-- de type constant : pas de possibilite d'affectation a la ligne [%d] la colonne [%d]\n",$1,nb_ligne,Col);
                          printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
                    }
                    //Dans le cas de la 2eme declaration CONST nom_const TYPE.
                    
                    if(DeclarationConst2($1)==0){
                        if(strcmp(motconst,"CONST")==0) {inserer_const($1);  strcpy(motconst,"");}
                   }

                    if(verifier==0)
                    {
                    char *val1=(char*)TypeDe($1);
                    if (strcmp(val1,sauvType2)!=0){
                          printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                        printf("\nERREUR SEMANTIQUE: Incompatible type de --<%s>-- n'est pas de type --<%s>-- a la ligne [%d] la colonne [%d]\n",$1,sauvType2,nb_ligne,Col);
                          printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
                      }
                    }
                    else{
                        verifier=0;
                        char *val1=(char*)TypeDe($1);
                        char *val2=(char*)TypeDe(sauveIdf);
                        if (strcmp(val1,val2)!=0){
                          printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                        printf("\nERREUR SEMANTIQUE: Incompatible type de --<%s>-- avec --<%s>-- a la ligne [%d] la colonne [%d]\n",$1,sauveIdf,nb_ligne,Col);
                          printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
                      }
                    }
                }                  
;

EXPRESSION_AFF: EXP_P
;


EXP: OPERANDE OPERATEUR EXP
   | OPERANDE OPERATEUR EXP_P
   | OPERANDE
     {if(strcmp(sauvOpr,"/")==0)
            {
                if (sauvVal==0){
                     printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                    printf("\nERREUR SEMANTIQUE: division par 0 a la ligne [%d], la colonne [%d]\n",nb_ligne,Col); 
                     printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
                 }
            }
     }
;


EXP_P: p_ouvre EXP p_ferme OPERATEUR EXPRESSION_AFF 
     | p_ouvre EXP p_ferme  
     | p_ouvre EXP_P p_ferme 
     | p_ouvre EXP_P p_ferme OPERATEUR EXPRESSION_AFF 
     | p_ouvre EXP p_ferme OPERATEUR EXP
     | OPERANDE OPERATEUR EXP
;

OPERANDE: type_integer   {sauvVal=$1;   strcpy(sauvType2,"INTEGER");}
        | type_float     {sauvVal=$1;   strcpy(sauvType2,"FLOAT");  }
        | type_char      {              strcpy(sauvType2,"CHAR");   }
        | type_string    {              strcpy(sauvType2,"STRING"); }
        | idf            {verifier=1;   strcpy(sauveIdf,$1);        }
;       

OPERATEUR: plus     {strcpy(sauvOpr,"+");}
         | division {strcpy(sauvOpr,"/");}
         | moins    {strcpy(sauvOpr,"-");}
         | multiple {strcpy(sauvOpr,"*");}
;

//ENTREE---------------------------------------------------
ENTREE: mc_accept p_ouvre sign deuxp arob idf p_ferme point {
    if(Accepter($3,$6)==-1){
            printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
        printf("ERREUR SEMANTIQUE:Incompatible signe de formatage pour ACCEPT a la ligne [%d] la colonne [%d]\n",nb_ligne,Col);
            printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n "); 
            }  
    } 
;


//DISPLAY ("c’est un entire $": idf_entier ).
//SORTIE----------------------------------------

SORTIE: mc_display p_ouvre PHRASE deuxp idf p_ferme point   
;

PHRASE: phrase_dz
      | phrase_et
      | phrase_dol
      | phrase_pourc                                                                                      
;


//IF------------------------------------------
IF: mc_if INST_OPR_LOG_COMP deuxp INST mc_end
  | mc_if INST_OPR_LOG_COMP deuxp INST mc_else deuxp INST mc_end 
;

//BOUCLE => MOVE
/*
MOVE i to n
 ACCEPT ("%": A).
END
*/
//**

//BOUCLE-------------------------------
BOUCLE: mc_move VAL mc_to VAL INST mc_end
;

VAL: idf
   | TYPE_CONST
;






/*=====================================================================================================
                                                     PARTIE 3
  =====================================================================================================
*/


%%
main()
{
initialisation(); 
yyparse();
afficher();

}
yywrap()
{}
int yyerror ( char*  msg )  
 {
    printf ("\n\n================================Erreur Syntaxique a ligne %d a colonne %d ================================\n\n", nb_ligne,Col);
 }

