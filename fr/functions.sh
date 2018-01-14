#!/bin/bash

pg_translator_lang () {
   case "$1" in
     tr_order_regex) echo "tradu[^ ]* (.*) en (.*)";;
     tr_not_understood) echo "Je n'ai pas compris ce qu'il faut traduire.";;
     tr_missing_key) echo "ERREUR: Clef Microsoft Translator manquante";;
     tr_missing_key_hint) echo "INFO: définissez la Clef Microsoft Translator dans la configuration du plugin";;
     tr_unknown_language) echo "Je ne connais pas cette langue.";;
	   tr_thinking_phrase) echo "Alors, si je me souviens bien...";;
	   tr_textual_response) echo "\"$2\" se dit en $3 :";;
	   tr_known_languages) echo "Je peux traduire en $2 langues comme par exemple : $3...";;
   esac
}

# Spoken Language Names
jv_pg_tr_spoken_languages_names[0]="Arabe"
jv_pg_tr_spoken_languages_names[1]="Egyptien"
jv_pg_tr_spoken_languages_names[2]="Catalan"
jv_pg_tr_spoken_languages_names[3]="Danois"
jv_pg_tr_spoken_languages_names[4]="Allemand"
jv_pg_tr_spoken_languages_names[5]="Anglais"
jv_pg_tr_spoken_languages_names[6]="Espagnol"
jv_pg_tr_spoken_languages_names[7]="Méxicain"
jv_pg_tr_spoken_languages_names[8]="Finnois"
jv_pg_tr_spoken_languages_names[9]="Français"
jv_pg_tr_spoken_languages_names[10]="Canadien"
jv_pg_tr_spoken_languages_names[11]="Hindi"
jv_pg_tr_spoken_languages_names[12]="Italien"
jv_pg_tr_spoken_languages_names[13]="Japonais"
jv_pg_tr_spoken_languages_names[14]="Koréen"
jv_pg_tr_spoken_languages_names[15]="Néerlandais"
jv_pg_tr_spoken_languages_names[16]="Norvégien"
jv_pg_tr_spoken_languages_names[17]="Polonais"
jv_pg_tr_spoken_languages_names[18]="Portugais"
jv_pg_tr_spoken_languages_names[19]="Brésilien"
jv_pg_tr_spoken_languages_names[20]="Russe"
jv_pg_tr_spoken_languages_names[21]="Suédois"
jv_pg_tr_spoken_languages_names[22]="Cantonnais"
jv_pg_tr_spoken_languages_names[23]="Chinois"
jv_pg_tr_spoken_languages_names[24]="Hong-kongais"
jv_pg_tr_spoken_languages_names[25]="Taïwanais"
