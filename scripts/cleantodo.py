import os
import sys
from pathlib import Path

DEBUG = False

HOME = Path(os.environ['HOME'])
TODO_FILE = HOME / 'main.todo'

try:
    f = open(TODO_FILE)
    lines = f.readlines()
    f.close()
except FileNotFoundError:
    print(f"File {TODO_FILE} not found")
    exit(1)

normalSection = []
completedSection = []

lineCount = len(lines)
completedTaskStart = -1
taskStart = -1
hasCompletedSection = False

FORCE_WRITE = True if '-f' in sys.argv else False

for i in range(lineCount):
    if lines[i].startswith('\t') and lines[i].strip().startswith('['):
        if DEBUG:
            print('\\t[')
        continue

    if completedTaskStart > -1:
        completedSection += lines[completedTaskStart:i]
        completedTaskStart = -1
    if taskStart > -1:
        normalSection += lines[taskStart:i]
        taskStart = -1

    if lines[i].startswith('[x]') or lines[i].startswith('[>]'):
        if DEBUG:
            print('[x] or [>]')
        completedTaskStart = i
    elif lines[i].startswith('[ ]'):
        if DEBUG:
            print('[ ]')
        taskStart = i
    elif lines[i].strip().startswith('# COMPLETED'):
        if DEBUG:
            print('# COMPLETED')
        completedSection = lines[i:] + completedSection
        hasCompletedSection = True
        break
    else:
        if DEBUG:
            print('else')
        if taskStart == -1 and completedTaskStart == -1:
            normalSection += lines[i]

if not hasCompletedSection:
    completedSection = ["\n\n# COMPLETED\n"] + completedSection

if FORCE_WRITE or os.system('pgrep nvim') != 0:
    f = open(TODO_FILE, 'w')
    f.writelines(normalSection + completedSection)
    f.close()
else:
    print("nvim is running, use -f to force write without checking")
    doIt = True if input("Are you sure you want to overwrite the file? (y/\033[1;37mn\033[0m) ") in ['y', 'yes', 'Y', 'Yes' ] else False
    if doIt:
        f = open(TODO_FILE, 'w')
        f.writelines(normalSection + completedSection)
        f.close()
    else:
        print("Exiting without writing")
        exit(1)

