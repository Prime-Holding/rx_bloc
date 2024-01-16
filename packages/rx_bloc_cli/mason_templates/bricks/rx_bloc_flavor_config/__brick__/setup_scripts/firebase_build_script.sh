if [ \"${CONFIGURATION}\" == \"Debug-production\" ] || [ \"${CONFIGURATION}\" == \"Release-production\" ] || [ \"${CONFIGURATION}\" == \"Release\" ]; then
cp -r \"${PROJECT_DIR}/environments/production/firebase/GoogleService-Info.plist\" \"${PROJECT_DIR}/Runner/GoogleService-Info.plist\"

echo \"Production plist copied\"
elif [ \"${CONFIGURATION}\" == \"Debug-sit\" ] || [ \"${CONFIGURATION}\" == \"Release-sit\" ]; then

cp -r \"${PROJECT_DIR}/environments/sit/firebase/GoogleService-Info.plist\" \"${PROJECT_DIR}/Runner/GoogleService-Info.plist\"

echo \"SIT plist copied\"

elif [ \"${CONFIGURATION}\" == \"Debug-uat\" ] || [ \"${CONFIGURATION}\" == \"Release-uat\" ]; then

cp -r \"${PROJECT_DIR}/environments/uat/firebase/GoogleService-Info.plist\" \"${PROJECT_DIR}/Runner/GoogleService-Info.plist\"

echo \"UAT plist copied\"

elif [ \"${CONFIGURATION}\" == \"Debug-development\" ] || [ \"${CONFIGURATION}\" == \"Release-development\" ] || [ \"${CONFIGURATION}\" == \"Debug\" ]; then

cp -r \"${PROJECT_DIR}/environments/development/firebase/GoogleService-Info.plist\" \"${PROJECT_DIR}/Runner/GoogleService-Info.plist\"

echo \"Development plist copied\"
fi
