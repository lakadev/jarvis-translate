#!/bin/bash
# Here you can define translations to be used in the plugin functions file
# the below code is an sample to be reused:
# 1) uncomment to function below
# 2) replace XXX by your plugin name (short)
# 3) remove and add your own translations
# 4) you can the arguments $2, $3 passed to this function
# 5) in your plugin functions.sh file, use it like this:
#      say "$(pv_myplugin_lang the_answer_is "oui")"
#      => Jarvis: La réponse est oui

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
