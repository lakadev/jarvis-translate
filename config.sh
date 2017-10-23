#!/bin/bash
# 
# Before launching, put your Microsoft Translator API Key in this variable
# Avant de lancer, mettez votre clé API Microsoft Translator dans cette variable
jv_pg_tr_ms_translator_api_key="Your Microsoft Translator API Key"

# List of languages we can translate to with their codes from file 'spokenLanguages'
declare -A jv_pg_tr_spoken_languages
while IFS=\= read name add
do
    jv_pg_tr_spoken_languages[$name]=$add
done < ./plugins_installed/jarvis-translate/${language:0:2}/spokenLanguages

# Repeat speech 2 times
jv_pg_tr_repeat_speech=true

