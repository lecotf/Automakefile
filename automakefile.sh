#!/bin/bash
## Made by Florian Lécot
## Email : <contact.florianlecot@gmail.com>
## 
## Started on  Wed Jan 18 17:11:47 2017 
## Last update Tue May 16 15:28:10 2017 
##

###############
# Automakefile.sh est un script de création de makefile et
# plus largement de répertoire pour mes projets de C / C++.
# Il peut bien entendu être utilisé dans d'autres situations, il suffit de modifier le makefileconfig.
###############


############### Fonction question-réponse

need_answer()
{
    printf "$1"
    read answer
    case $answer in
	o|O|y|Y) printf "$2"
		 return 0;;
	*) printf "$3"
	   return 1;;
    esac
}

############### Fonction de création de fichier de config

make_config_file()
{
    if [ -d "makefileconfig" ]; then
	printf "Erreur : il existe un dossier nommé \"makefileconfig\" dans le dossier courant.\n"
	exit 1;
    elif [ -e "makefileconfig" ]; then
	if need_answer "Souhaitez-vous écraser l'ancien fichier de config ? (y/n) : " "Suppression de l'ancien fichier de config.\n" "L'ancien fichier de config n'a pas été supprimé.\n=== Fin du script ===\n"; then
	    rm -f "makefileconfig"
	else
	    exit 0
	fi
    fi
    printf "REP:\n" >> "makefileconfig"
    printf "NAME:example\n" >> "makefileconfig"
    printf "COMPILEFLAGS:-W -Wall -Wextra\n" >> "makefileconfig"
    printf "INCLUDES:includes\n" >> "makefileconfig"
    printf "LDFLAGS:-lm\n" >> "makefileconfig"
    printf "SRCPATH:src\n" >> "makefileconfig"
    printf "DEBUG:yes\n" >> "makefileconfig"
    printf "D_CC:clang\n" >> "makefileconfig"
    printf "D_CFLAGS:-Weverything\n" >> "makefileconfig"
    printf "D_LDFLAGS:-g\n" >> "makefileconfig"
    printf "ARCHIVE:svg\n" >> "makefileconfig"
    printf "file1.c\n" >> "makefileconfig"
    printf "file2.c\n" >> "makefileconfig"
    printf "header1.h\n" >> "makefileconfig"
    printf "/*END*/" >> "makefileconfig"
    printf "Fichier de config créé avec succès.\n"
}

############### Notice s'il n'y a pas d'argument

if [ $# -le '0' ]; then
    printf "_____________________________________________\n\t\tAutomakefile\n"
    printf "_____________________________________________\n\n"
    printf "Ce script Shell génère un Makefile à l'aide d'un fichier de config.\n"
    printf "Le deuxième argument est le chemin du répertoire où le Makefile doit-être créé "
    printf "(répertoire courant s'il n'est pas précisé)\n"
    printf "Le fichier de config doit être passé en argument et respecter la syntaxe suivante :\n"
    printf "• NAME:Nom de l'exécutable\n"
    printf "• COMPILEFLAGS:Liste des flags de compilations\n"
    printf "• INCLUDES:Sous-répertoire où se trouvent les headers\n"
    printf "• LDFLAGS:Liste des flags de linkage\n"
    printf "• SRCPATH:sous-répertoire où se trouvent les fichiers sources\n"
    printf "• DEBUG:Valeur de la condition de deboggage (Absence de condition si vide)\n"
    printf "• D_CC:Compilateur du mode de deboggage (Absent si \"DEBUG\" vide)\n"
    printf "• D_CFLAGS:Flags de compilation du mode de deboggage (Absent \"DEBUG\" si vide)\n"
    printf "• D_LDFLAGS:Flags de linkage du mode de deboggage (Absent \"DEBUG\" si vide)\n"
    printf "• ARCHIVE:sous-répertoire où sera stocker l'archive "
    printf "Vous avez la possibilité d'ajouter des fichiers .c et .h dans le fichier de config "
    printf "(un par ligne).\n"
    printf "Si le fichier existe dans le dossier courant du script, il sera copié.\n"
    printf "Sinon, le fichier sera juste créer dans le répertoire du projet.\n"
    printf "(pas de dossier et de règle d'archive si le champs est vide.\n"
    printf "NB : Ce script créé le dossier racine du projet s'il est inexistant.\n"
    printf "Si un Makefile existe déjà dans le dossier, "
    printf "vous avez la possibilité d'écraser l'ancien Makefile.\n"
    printf "L'ordre n'a pas d'importance pour le script.\n\n"
    if need_answer "Souhaitez-vous générer un exemple de fichier de config ? (y/n) : " "Le fichier de config va être générer...\n" ""; then
	make_config_file
    fi
    exit 1
fi

############### Set variable "nom_dépôt"

SCRIPT_DIRECTORY=`dirname $0`
REP=$(cat $1 | grep ^"REP:" | cut -d':' -f 2)


############### check existence dossier

if [ -z $REP ]; then
    REP=".";
    printf "Le nom du dossier racine du projet n'est pas précisé.\n"
    printf "Le Makefile sera créé dans le dossier actuel.\n"
elif [ ! -d "$REP" ]; then
    printf "Le dossier \"$REP\" n'existe pas.\n"
    printf "Création du dossier \"$REP\"."
    printf "\n"
    mkdir -p $REP
fi

############### Check Makefile existe

if [ -f "$REP/Makefile" ]; then
    printf "Un fichier nommé \"Makefile\" existe déjà dans le dossier racine du projet.\n"
    printf "Remplacer l'ancien Makefile ? (y/n) : "
    read answer
    case $answer in
	o|O|y|Y) printf "Suppression de l'ancien Makefile.\n"
		 rm $REP/Makefile;;
	*) printf "=== Fin du script ===\n"
	   exit 0;;
    esac 
elif [ -d "$REP/Makefile" ]; then
    printf "Un dossier nommé \"Makefile\" existe dans le dossier racine du projet.\n"
    exit 1
fi

############### Check arg existe

if [ ! -e $1 ]; then
    printf "Erreur : l'argument passé en paramètre n'existe pas.\n";
    exit 1;
elif [ -d $1 ]; then
    printf "Erreur : l'argument passé en paramètre est un dossier.\n";
    exit 1;
fi

############### Récupération valeurs variables

NAME=$(cat $1 | grep ^"NAME:" | cut -d':' -f 2)
COMPILEFLAGS=$(cat $1 | grep ^"COMPILEFLAGS:" | cut -d':' -f 2)
INCLUDES=$(cat $1 | grep ^"INCLUDES:" | cut -d':' -f 2)
LDFLAGS=$(cat $1 | grep ^"LDFLAGS:" | cut -d':' -f 2)
SRCPATH=$(cat $1 | grep ^"SRCPATH:" | cut -d':' -f 2)
DEBUG=$(cat $1 | grep ^"DEBUG:" | cut -d':' -f 2)
D_CC=$(cat $1 | grep ^"D_CC:" | cut -d':' -f 2)
D_CFLAGS=$(cat $1 | grep ^"D_CFLAGS:" | cut -d':' -f 2)
D_LDFLAGS=$(cat $1 | grep ^"D_LDFLAGS:" | cut -d':' -f 2)
ARCHIVE=$(cat $1 | grep ^"ARCHIVE:" | cut -d':' -f 2)

################## Création des dossiers

mkdir -p $REP/$SRCPATH
mkdir -p $REP/$INCLUDES
mkdir -p $REP/$ARCHIVE

############## Création du Makefile, déclaration variables
printf "Création du Makefile en cours...\n";
printf "NAME\t\t=\t$NAME\n\n" >> $REP/Makefile
printf "CC\t\t=\tgcc\n\n">> $REP/Makefile
printf "RM\t\t=\trm -f\n\n" >> $REP/Makefile
printf "COMPILEFLAGS\t=\t$COMPILEFLAGS\n\n" >> $REP/Makefile
printf "INCLUDES\t=\t$INCLUDES\n\n" >> $REP/Makefile
printf "LDFLAGS\t\t=\t$LDFLAGS\n\n" >> $REP/Makefile
printf "CFLAGS\t\t=\t\$(COMPILEFLAGS) -I ./\$(INCLUDES)\n\n" >> $REP/Makefile
printf "SRCPATH\t\t=\t$SRCPATH\n\n" >> $REP/Makefile

check_and_cpy()
{
    ftc=$1 #file_to_copy
    dir_ftc=$2
    if test -f $SCRIPT_DIRECTORY/$ftc; then
	if [ -f "$REP/$dir_ftc/$ftc" ]; then
	printf "\nUn fichier nommé \"$ftc\" existe déjà dans le dossier \"$dir_ftc\".\n"
	printf "Remplacer l'ancien fichier ? (y/n) : "
	read ans
	case $ans in
	    o|O|y|Y) printf "Le fichier \"$ftc\" a été remplacé.\n"
		     cp -rf $SCRIPT_DIRECTORY/$ftc $REP/$dir_ftc/;;
	    *) printf "Le fichier \"$ftc\" n'a pas été copié.\n";;
	esac
	elif [ -d "$REP/$dir_ftc/$ftc" ]; then
	    printf "\nUn dossier nommé \"$ftc\" existe dans le dossier \"$dir_fct\".\n"
	else
	    cp -rf $SCRIPT_DIRECTORY/$ftc $REP/$dir_ftc
	fi
    else
	touch $REP/$dir_ftc/$ftc
    fi
}

################## Déclaration srcs et ojbs

a=0
while read line <&9
do
#    if (src=$(echo $line | cut -d";" -f 1 | grep ".c")); then
    #	srcs=$(echo -e $line | cut -d";" -f 1)
    if (file=$(echo $line | grep "\.c")); then
	if [ "$a" == "0" ]; then
	    printf "SRCS\t\t=" >> $REP/Makefile
	else
	    printf "\t\t" >> $REP/Makefile
	fi
	printf "\t\$(SRCPATH)/$line\t\\" >> $REP/Makefile
	printf "\n" >> $REP/Makefile
	a=(a + 1)
	### Créer les sources et les includes ###
	check_and_cpy $line $SRCPATH
    elif (file=$(echo $line | grep "\.h")); then
	check_and_cpy $line $INCLUDES
    fi
done 9< $1

if [ "$a" == "0" ]; then
    printf "SRC\t\t=\n\n" >> $REP/Makefile
fi

printf "\nOBJS\t\t=\t\$(SRCS:.c=.o)\n\n" >> $REP/Makefile

################ Set var des zips

if ! [ -z $ARCHIVE ]; then
    printf "REP_SVG\t\t=\t$ARCHIVE/\n\n" >> $REP/Makefile
    printf "ZIP\t\t=\ttar\n\n" >> $REP/Makefile
    printf "ZIPFLAGS\t=\t-cvvf\n\n" >> $REP/Makefile
    printf "UNZIP\t\t=\ttar\n\n" >> $REP/Makefile
    printf "UNZIPFLAGS\t=\t-xvf\n\n" >> $REP/Makefile
fi

################ Debug règle

if ! [ -z $DEBUG ] && ! [ "$DEBUG" == "no" ]; then
    printf "DEBUG\t\t=\tno\n\n" >> $REP/Makefile
    printf "ifeq (\$(DEBUG), $DEBUG)\n" >> $REP/Makefile
    printf "CC\t\t=\t$D_CC\n" >> $REP/Makefile
    printf "CFLAGS\t\t+=\t$D_CFLAGS\n" >> $REP/Makefile
    printf "LDFLAGS\t\t+=\t$D_LDFLAGS\n" >> $REP/Makefile
    printf "endif\n\n" >> $REP/Makefile
fi

################ Règles et commandes de $REP/Makefile

#Règle all (appelle la règle $(NAME))
printf "all: \$(NAME)\n\n" >> $REP/Makefile

#Règle $(NAME) (Compile, créer les fichiers .o et l'exécutable)
printf "\$(NAME): \$(OBJS)\n\t@echo -n \"\\" >> $REP/Makefile
printf "033[0;34mCompilation en cours...\\" >> $REP/Makefile
printf "033[0m\\" >> $REP/Makefile
printf "n\"\n\t\$(CC) \$(CFLAGS) \$(OBJS) -o \$(NAME) \$(LDFLAGS) && \\" >> $REP/Makefile
printf "\n\tprintf \"\\" >> $REP/Makefile
printf "033[0;32mCompilation terminée avec succès.\\" >> $REP/Makefile
printf "033[0m\\" >> $REP/Makefile
printf "n\"\n\n" >> $REP/Makefile

#Règle clean (Supprime les fichiers .o)
printf "clean:\n\t\$(RM) \$(OBJS) && \\" >> $REP/Makefile
printf "\n\tprintf \"\\" >> $REP/Makefile
printf "033[0;33mSuppression des \\" >> $REP/Makefile
printf "\".o\\" >> $REP/Makefile
printf "\"...\\" >> $REP/Makefile
printf "033[0m\\" >> $REP/Makefile
printf "n\"\n\n" >> $REP/Makefile

#Règle fclean (Appelle la règle clean et supprime l'exécutable)
printf "fclean: clean\n\t\$(RM) \$(NAME) && \\" >> $REP/Makefile
printf "\n\tprintf \"\\" >> $REP/Makefile
printf "033[0;33mSuppresion du binaire...\\" >> $REP/Makefile
printf "033[0m\\" >> $REP/Makefile
printf "n\"\n\n" >> $REP/Makefile

#Règle re (Appelle les règles fclean et all)

printf "re: fclean all\n\n" >> $REP/Makefile

################## règle des zip

if ! [ -z $ARCHIVE ]; then
   #Règle archive (Créer une archive du dépôt)
   printf "archive:\n\t\$(ZIP) \$(ZIPFLAGS) \$(REP_SVG)/\$(NAME).\$(ZIP) * && \\" >> $REP/Makefile
   printf "\n\tprintf \"\\" >> $REP/Makefile
   printf "033[0;45mFichier \$(NAME).\$(ZIP) généré.\\" >> $REP/Makefile
   printf "033[0m\\" >> $REP/Makefile
   printf "n\"\n\n" >> $REP/Makefile

   #Règle revert (Décompresse l'archive dans le dépôt)
   printf "revert:\n\t\$(UNZIP) \$(UNZIPFLAGS) \$(REP_SVG)/\$(NAME).\$(ZIP) && \\" >> $REP/Makefile
   printf "\n\tprintf \"\\" >> $REP/Makefile
   printf "033[0;45mFichier \$(NAME).\$(ZIP) décompressé.\\" >> $REP/Makefile
   printf "033[0m\\" >> $REP/Makefile
   printf "n\"\n\n" >> $REP/Makefile

   #Règle delete (Supprime l'archive)
   printf "delete:\n\t\$(RM) \$(REP_SVG)/\$(NAME).\$(ZIP) && \\" >> $REP/Makefile
   printf "\n\tprintf \"\\" >> $REP/Makefile
   printf "033[0;45mFichier \$(NAME).\$(ZIP) supprimé.\\" >> $REP/Makefile
   printf "033[0m\\" >> $REP/Makefile
   printf "n\"\n" >> $REP/Makefile
fi
   
################## End

printf "Makefile créé avec succès.\n"

################# Make Header

if ! [ -f $REP/$INCLUDES/$NAME.h ]; then
    printf "#ifndef\t\t$NAME" >> $REP/$INCLUDES/$NAME.h
    printf "_H_\n" >> $REP/$INCLUDES/$NAME.h
    printf "# define\t$NAME" >> $REP/$INCLUDES/$NAME.h
    printf "_H_\n\n" >> $REP/$INCLUDES/$NAME.h
    #ajout des prototypes, define, constantes...
    printf "\n#endif\t\t/* !$NAME" >> $REP/$INCLUDES/$NAME.h
    printf "_H_ */" >> $REP/$INCLUDES/$NAME.h
fi
