#!/usr/bin/env bash

curl -s http://api.sparrowsms.com/v2/sms/ \
        -F token='o5AuQNrWNGKtL2' \
        -F from='InfoSMS ' \
        -F to='{SMSPhoneNumber}' \
        -F text='{SMSMessage}'
