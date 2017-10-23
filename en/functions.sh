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
