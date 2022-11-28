#!/usr/bin/env python3

import argparse
import fnmatch

def main():
    parser = argparse.ArgumentParser(
        prog='clean_coverage.py',
        description='A tool to clean up LCOV files')
    parser.add_argument('tracefile', type=argparse.FileType('r+'), help='the LCOV file')
    parser.add_argument('-o', '--output-file', type=argparse.FileType('w'), help='write data to this file')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--exclusions', nargs='+', help='exclusion patterns')
    group.add_argument('--exclusions-file', type=argparse.FileType('r'), help='a file containing the exclusion patterns')
    parser.add_argument('--version', action='version', version='%(prog)s 1.0')
    args = parser.parse_args()
    exclusions = select_exclusions(args.exclusions, args.exclusions_file)
    lines = clean_tracefile(args.tracefile, exclusions)
    output_file = args.output_file if args.output_file is not None else args.tracefile
    print(f'Writing data to {output_file.name}')
    output_file.seek(0)
    output_file.writelines(lines)
    output_file.truncate()
    output_file.close()

def select_exclusions(exclusions, exclusions_file):
    if exclusions is not None:
        return exclusions
    exclusion_lines = exclusions_file.readlines()
    return [string.strip() for string in exclusion_lines if len(string.strip()) > 0]

def clean_tracefile(tracefile, exclusions):
    trace_lines = tracefile.readlines()
    filtered_lines = []
    removed_files = []
    keep = True

    print(f'Reading tracefile {tracefile.name}')
    for line in trace_lines:
        if line.startswith('SF:'):
            filepath = line[3:].strip()

            for pattern in exclusions:
                if fnmatch.fnmatch(filepath, pattern):
                    print(f'Removing {filepath}')
                    removed_files.append(filepath)
                    keep = False
                    break
        else:
            if (keep == False and line.startswith('end_of_record')):
                keep = True
                continue
        if keep:
            filtered_lines.append(line)
    print(f'Removed {len(removed_files)} files from coverage')
    return filtered_lines

if __name__ == "__main__":
    main()