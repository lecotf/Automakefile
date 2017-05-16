# Automakefile
Générateur de Makefile configurable

Ce script Shell génère un Makefile à l'aide d'un fichier de config. Le deuxième argument est le chemin du répertoire où le Makefile doit-être créé (répertoire courant s'il n'est pas précisé). Le fichier de config doit être passé en argument et respecter la syntaxe suivante :  
    • NAME : Nom de l'exécutable  
    • COMPILEFLAGS : Liste des flags de compilations  
    • INCLUDES : Sous-répertoire où se trouvent les headers  
    • LDFLAGS : Liste des flags de linkage  
    • SRCPATH : Sous-répertoire où se trouvent les fichiers sources  
    • DEBUG : Valeur de la condition de deboggage (Absence de condition si vide)  
    • D_CC : Compilateur du mode de deboggage (Absent si "DEBUG" vide)  
    • D_CFLAGS : Flags de compilation du mode de deboggage (Absent "DEBUG" si vide)  
    • D_LDFLAGS : Flags de linkage du mode de deboggage (Absent "DEBUG" si vide)  
    • ARCHIVE : sous-répertoire où sera stocker l'archive  
Vous avez la possibilité d'ajouter des fichiers dans le fichier de config (un par ligne). Si le fichier existe dans le dossier courant du script, il sera copié. Sinon, le fichier sera juste créer dans le répertoire du projet (pas de dossier et de règle d'archive si le champs est vide).  
NB : Ce script créé le dossier racine du projet s'il est inexistant. Si un Makefile existe déjà dans le dossier, vous avez la possibilité d'écraser l'ancien Makefile. L'ordre des arguments du makefileconfig n'a pas d'importance pour le script.
