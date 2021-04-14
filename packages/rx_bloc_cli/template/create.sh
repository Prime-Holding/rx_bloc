#!/bin/bash
PARAMS=$@
while (( "$#" )); do
  case "$1" in
    --project-name)
      PROJECT_NAME=$2
      shift
      shift
      ;;
    *) # preserve positional arguments
      shift
      ;;
  esac
done

flutter create $PARAMS -t app .
sed -i '' -e "s/flutter_rx_bloc_scaffold/$PROJECT_NAME/g" $(find . -name "*.dart") pubspec.yaml
#git add .
#git commit -m 'Initial commit'
