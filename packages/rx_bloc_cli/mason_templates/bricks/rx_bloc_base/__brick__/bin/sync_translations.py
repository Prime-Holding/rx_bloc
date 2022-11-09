#!/usr/bin/env python3

import glob
import json
import os
import yaml
from collections import OrderedDict


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def sync(folder_path):
    print(f'{bcolors.HEADER}[synchronizing {folder_path}]{bcolors.ENDC}')
    dataToWrite = {}
    with open(os.path.join(folder_path, 'en.arb')) as json_file:
        dataToWrite = json.load(json_file)

    for filename in glob.glob(os.path.join(folder_path, '*.arb')):
        if filename == os.path.join(folder_path, 'en.arb'):
            continue
        print(f'{filename} ... ', end='')
        with open(filename, 'r+') as json_file:
            currentString = json_file.read()
            json_file.seek(0)
            currentJson = json.load(json_file, object_pairs_hook=OrderedDict)
            result = OrderedDict()
            for item in dataToWrite:
                if item not in currentJson:
                    result[item] = dataToWrite[item]
                elif item == '@@last_modified':
                    result[item] = dataToWrite[item]
                else:
                    result[item] = currentJson[item]
            jsonString = json.dumps(result, indent=2, ensure_ascii=False)
            if currentString != jsonString:
                json_file.seek(0)
                json_file.write(jsonString)
                json_file.truncate()
                print(f'{bcolors.OKGREEN}{bcolors.BOLD}done{bcolors.ENDC}')
            else:
                print(f'{bcolors.OKCYAN}no changes{bcolors.ENDC}')


def main():
    with open("pubspec.yaml", 'r') as stream:
        pubspec = yaml.safe_load(stream)
        if 'r_flutter' in pubspec:
            folder_path = os.path.dirname(pubspec['r_flutter']['intl'])
            sync(folder_path)
            if 'intl_features' in pubspec['r_flutter']:
                for feature in pubspec['r_flutter']['intl_features']:
                    sync(os.path.join(folder_path, feature['name']))


if __name__ == "__main__":
    main()
