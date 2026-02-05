#!/usr/bin/env python3
import shutil
import sys
import psutil
import argparse

def check_disk_space(path):
    total, usage, free = shutil.disk_usage(path)
    used_percent = (usage / total) * 100
    return round(used_percent,2)

def check_memory():
    mem = psutil.virtual_memory()
    used_percent = mem.percent
    return round(used_percent,2)

def cpu_check():
    cpu_usage = psutil.cpu_percent(interval=1)
    return cpu_usage

def status_eval(value, warn, crit):
    if value >= crit:
        return 'CRITICAL',2
    elif value >= warn:
        return 'WARNING',1
    else:
        return 'OK',0
    
def main():
    parser = argparse.ArgumentParser(description='System Health Check')
    parser.add_argument('--path', nargs='+', default=['/'], help='Paths to check disk space')
    parser.add_argument('--disk-warn', type=int, default=75, help='Disk usage warning threshold percentage')
    parser.add_argument('--disk-crit', type=int, default=90)
    parser.add_argument('--mem-warn', type=int, default=75)
    parser.add_argument('--mem-crit', type=int, default=90)
    parser.add_argument('--cpu-warn', type=int, default=75)
    parser.add_argument('--cpu-crit', type=int, default=90)

    args = parser.parse_args()

    exit_code = 0

    for path in args.path:
        try:
            disk_space = check_disk_space(path)
            status, code = status_eval(disk_space, args.disk_warn, args.disk_crit)
            print(f'DISK {path} USAGE: {disk_space}% - STATUS: {status}')
            exit_code = max(exit_code, code)
        except Exception as e:
            print(f'Error checking disk space for {path}: {e}')
            exit_code = max(exit_code, 2)

    mem_usage = check_memory()
    status, code = status_eval(mem_usage, args.mem_warn, args.mem_crit)
    print(f'MEMORY USAGE: {mem_usage}% - STATUS: {status}')
    exit_code = max(exit_code, code)

    cpu_usage = cpu_check()
    status, code = status_eval(cpu_usage, args.cpu_warn, args.cpu_crit)
    print(f'CPU USAGE: {cpu_usage}% - STATUS: {status}')    
    exit_code = max(exit_code, code)

    sys.exit(exit_code)

if __name__ == '__main__':
    main()