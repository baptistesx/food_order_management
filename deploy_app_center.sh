#!/bin/bash

# if [ $# -eq 0 ]
#   then
#     echo "Please provide the Fastlane lane name. You can find it in the Fastfiles: deploy_to_appcenter, deploy_to_appcenter_test, deploy_to_playstore, deploy_to_testflight"
#     exit 1
# fi

# declare -a StringArray=("deploy_to_appcenter" "deploy_to_appcenter_test" "deploy_to_playstore" "deploy_to_testflight")

# for val in ${StringArray[@]}; do
#    if [ $val == $1 ]
#         then
            fvm install && flutter clean && flutter pub get && \
            cd android/ && bundle install && bundle exec fastlane android build && bundle exec fastlane android deploy_to_playstore
            #  && \
            # cd ../ios/ && pod install --repo-update && bundle install && bundle exec fastlane ios build &&  bundle exec fastlane ios deploy_to_testflight

            exit 0
#    fi
# done

# echo "Bad lane name"
# exit 1
