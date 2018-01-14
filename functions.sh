#!/bin/bash
# Here you can create functions which will be available from the commands file
# You can also use here user variables defined in your config file
# To avoid conflicts, name your function like this
# pg_XX_myfunction () { }
# pg for PluGin
# XX is a short code for your plugin, ex: ww for Weather Wunderground
# You can use translations provided in the language folders functions.sh

# Temporary speech file location - do not change except if you know why
jv_pg_tr_temp_speech_file="/tmp/jarvis_translate_temp_speech.mp3"

# Translation preparation
#
jv_pg_tr_translate()
{
    local textToTranslate=""
    local destinationLanguage=""

    local regex="$(pg_translator_lang tr_order_regex)"
    if [[ $order =~ $regex ]]
    then
        #jv_debug "OK : 1=${BASH_REMATCH[1]} / 2=${BASH_REMATCH[2]}"
        textToTranslate=${BASH_REMATCH[1]}
        destinationLanguage=$(jv_sanitize ${BASH_REMATCH[2]})
        #jv_debug "=> OK : $textToTranslate / $destinationLanguage"
    else
        # Invalid sentence format
        say "$(pg_translator_lang tr_not_understood)"
        return
    fi

	#jv_debug "texte= $textToTranslate / langue= $destinationLanguage"
	#jv_debug "key = $jv_pg_tr_ms_translator_api_key"
    if [[ -z "$jv_pg_tr_ms_translator_api_key" ]] || [[ "$jv_pg_tr_ms_translator_api_key" == "Your Microsoft Translator API Key" ]] ; then
        echo "" # new line
        jv_error "$(pg_translator_lang tr_missing_key)"
        jv_warning "$(pg_translator_lang tr_missing_key_hint)"
        return # TODO doesn't really exit because launched with & forjv_spinner
	fi

	# Get source language from jarvis config
	local sourceLanguageCode="$(tr '[:upper:]' '[:lower:]' <<< ${language:0:2})" # en_GB => en => EN
	
    # Get destination language code from plugin configuration
	local destinationLanguageCode="$(jv_pg_tr_get_language_code "$destinationLanguage")"
	
    #jv_debug "DEBUG: destinationLanguageCode= $destinationLanguageCode"

	# Check if destination is supported
	reflexionPid=""
	if [ -z "$destinationLanguageCode" ]; then
        say "$(pg_translator_lang tr_unknown_language)"
        return
    else
        say "$(pg_translator_lang tr_thinking_phrase)" > /dev/tty &
    	reflexionPid="$!"
	fi

	local translatedText=$(jv_pg_tr_sendTextTranslateRequest "$textToTranslate" "$sourceLanguageCode" "$destinationLanguageCode") 
    
    wait "$reflexionPid"
    say "$(pg_translator_lang tr_textual_response "$textToTranslate" "$destinationLanguage" )" > /dev/tty &
    reflexionPid="$!"
    
    #jv_debug "translatedText = $translatedText"
	local translatedSpeechUrl=$(jv_pg_tr_sendSpeakRequest "$translatedText" "$destinationLanguageCode")
    #jv_debug "DEBUG: result : $translatedText / $reflexionPid / $translatedSpeechUrl"

    wait "$reflexionPid"
    echo "$translatedText" > /dev/tty

    if [ -s $jv_pg_tr_temp_speech_file ]
    then
        play -q $jv_pg_tr_temp_speech_file 
        if [ "$jv_pg_tr_repeat_speech" = true ] ; then
            play -q $jv_pg_tr_temp_speech_file 
        fi
    fi
}

# Send Text Translation request
# No echo or Debug allowed !
# $1 = "text to translate"
# $2 = "code of language to translate from"
# $3 = "code of language to translate to"
jv_pg_tr_sendTextTranslateRequest()
{
    #jv_debug "jv_pg_tr_sendTextTranslateRequest : $1 / $2 / $3"
	local textToTranslate=$1
	local sourceLanguageCode=$2
	local destinationLanguageCode=$3

    #jv_debug "texte= $textToTranslate / langue S= $sourceLanguageCode / langue D= $destinationLanguageCode"

	# Prepare request to Microsoft Translator Api
    local request="https://api.microsofttranslator.com/V2/Http.svc/Translate"
    request+="?appid="
    request+="&text=$(uriencode "$textToTranslate")"
    request+="&from=$sourceLanguageCode"
    request+="&to=$destinationLanguageCode"

    #jv_debug "DEBUG: curl $request"
    #local xml="TEMP DEBUG!"
    local xml=`curl "$request" \
        -H "Host: api.microsofttranslator.com" \
        -H "Content-Type: text/plain" \
        -H "Ocp-Apim-Subscription-Key: $jv_pg_tr_ms_translator_api_key" \
        --silent --fail`

    if (( $? )); then
        jv_error "ERROR: translation curl failed"
        jv_debug "DEBUG: $?"
        return
    fi

    #jv_debug "DEBUG: xml=$xml"
    #jv_debug "DEBUG: read dom..."
    local translatedText="??"
    while jv_read_dom; do
	  [[ $ENTITY = string* ]] && translatedText=$CONTENT
	done <<<"$xml"

    #jv_debug "DEBUG: result : $translatedText"
    echo "$translatedText"
}

# Get the language code by the language name
jv_pg_tr_get_language_code() {
  value=$(jv_sanitize $1)
  for i in "${!jv_pg_tr_spoken_languages_names[@]}"; do
      tempLang=$(jv_sanitize ${jv_pg_tr_spoken_languages_names[$i]})
      if [[ "$tempLang" = "${value}" ]]; then
         echo "${jv_pg_tr_spoken_languages_codes[$i]}"
         break
      fi
  done
} 

# Send Text Translation request
# No echo or Debug allowed !
# $1 = "text to speak"
# $2 = "code of language to speak into"
jv_pg_tr_sendSpeakRequest()
{
    #jv_debug "jv_pg_tr_sendSpeakRequest : $1 / $2" 
	local textToSpeak=$1
	local destinationLanguageCode=$2

	# Prepare request to Microsoft Translator Api
    local requestSpeach="https://api.microsofttranslator.com/V2/Http.svc/Speak"
    requestSpeach+="?appid="
    requestSpeach+="&text=$(uriencode "$textToSpeak")"
    requestSpeach+="&language=$destinationLanguageCode"
    requestSpeach+="&format=audio/mp3"
    requestSpeach+="&options=Female"

    #jv_debug "DEBUG: curl $requestSpeach"

    [ -f $jv_pg_tr_temp_speech_file ] && rm -f "$jv_pg_tr_temp_speech_file"

    #local xmlSpeech="TEMP DEBUG!"
    local xmlSpeech=`curl "$requestSpeach" \
        -H "Host: api.microsofttranslator.com" \
        -H "Ocp-Apim-Subscription-Key: $jv_pg_tr_ms_translator_api_key" \
        --output $jv_pg_tr_temp_speech_file \
        --silent --fail`
        
}

jv_pg_tr_getAllSpokenLanguages()
{
    # List all languages 
    languagesList=""
    for i in "${!jv_pg_tr_spoken_languages_names[@]}"
    do
        languagesList="${jv_pg_tr_spoken_languages_names[$i]}, $languagesList"
    done

    echo ${languagesList::-2}
}

jv_pg_tr_getExampleSpokenLanguages()
{

    # Select 3 random index
    nbLanguage=${#jv_pg_tr_spoken_languages_names[@]}
    
    index1=$((RANDOM%$nbLanguage))
    index2=-1
    index3=-1

    while [ $index2 == -1 ] || [ $index3 == -1 ]
    do
        if (( $index2 == -1 || $index2 == $index1 || $index2 == $index3 ))
        then
            index2=$((RANDOM%$nbLanguage))
        fi

        if (( $index3 == -1 || $index3 == $index1 || $index3 == $index2 ))
        then
            index3=$((RANDOM%$nbLanguage))
        fi
    done

    exampleLanguages=""
    for i in "${!jv_pg_tr_spoken_languages_names[@]}"
    do
        if (( $i == $index1 || $i == $index2 || $i == $index3 ))
        then
            exampleLanguages="${jv_pg_tr_spoken_languages_names[$i]}, $exampleLanguages"
        fi
    done

    echo "$(pg_translator_lang tr_known_languages $nbLanguage "${exampleLanguages::-2}" )"
}

uriencode() {
  s="${1//'%'/'%25'}"
  s="${s//' '/'%20'}"
  s="${s//'"'/'%22'}"
  s="${s//'#'/'%23'}"
  s="${s//'$'/'%24'}"
  s="${s//'&'/'%26'}"
  s="${s//'+'/'%2B'}"
  s="${s//','/'%2C'}"
  s="${s//'/'/'%2F'}"
  s="${s//':'/'%3A'}"
  s="${s//';'/'%3B'}"
  s="${s//'='/'%3D'}"
  s="${s//'?'/'%3F'}"
  s="${s//'@'/'%40'}"
  s="${s//'['/'%5B'}"
  s="${s//']'/'%5D'}"
  printf %s "$s"
}