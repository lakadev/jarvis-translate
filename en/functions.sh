#!/bin/bash

pg_translator_lang () {
   case "$1" in
		tr_order_regex) echo "translat[^ ]* (.*) in (.*)";;
		tr_not_understood) echo "I did not understand what to translate.";;
		tr_missing_key) echo "ERROR: missing Microsoft Translator api key";;
		tr_missing_key_hint) echo "HELP: set the Microsoft Translator Key in the plugin configuration";;
		tr_unknown_language) echo "I can't translate in this language.";;
	    tr_thinking_phrase) echo "So, if I remember correctly...";;
	    tr_textual_response) echo "the $3 for \"$2\" is:";;
		tr_known_languages) echo "I can translate in $2 languages like : $3 ...";;
   esac
} 

# Spoken Language Names
jv_pg_tr_spoken_languages_names[0]="Arabic"
jv_pg_tr_spoken_languages_names[1]="Egyptian"
jv_pg_tr_spoken_languages_names[2]="Catalan"
jv_pg_tr_spoken_languages_names[3]="Danish"
jv_pg_tr_spoken_languages_names[4]="German"
jv_pg_tr_spoken_languages_names[5]="English"
jv_pg_tr_spoken_languages_names[6]="Spanish"
jv_pg_tr_spoken_languages_names[7]="Mexican"
jv_pg_tr_spoken_languages_names[8]="Finnish"
jv_pg_tr_spoken_languages_names[9]="French"
jv_pg_tr_spoken_languages_names[10]="Canadian"
jv_pg_tr_spoken_languages_names[11]="Hindi"
jv_pg_tr_spoken_languages_names[12]="Italian"
jv_pg_tr_spoken_languages_names[13]="Japanese"
jv_pg_tr_spoken_languages_names[14]="Koreen"
jv_pg_tr_spoken_languages_names[15]="Dutch"
jv_pg_tr_spoken_languages_names[16]="Norwegian"
jv_pg_tr_spoken_languages_names[17]="Polish"
jv_pg_tr_spoken_languages_names[18]="Portuguese"
jv_pg_tr_spoken_languages_names[19]="Brazilian"
jv_pg_tr_spoken_languages_names[20]="Russian"
jv_pg_tr_spoken_languages_names[21]="Swedish"
jv_pg_tr_spoken_languages_names[22]="Cantonese"
jv_pg_tr_spoken_languages_names[23]="Chinese"
# "zh-hk" Not supported
jv_pg_tr_spoken_languages_names[25]="Taiwanese"
