import shutil
import sys

CRITICAL_THRESHOLD = 90
WARN_THRESHOLD = 75

def disk_usage_check(path="/"):
    total, usage, free = shutil.disk_usage(path)
    usage_percent = (usage/total)*100
    return round(usage_percent, 2)

def main():
    usage_percent = disk_usage_check("/")
    if usage_percent >= CRITICAL_THRESHOLD:
        print(f"CRITICAL: Disk usage is at {usage_percent}%")
        sys.exit(2)
    elif usage_percent >= WARN_THRESHOLD:
        print(f"WARNING: Disk usage is at {usage_percent}%")
        sys.exit(1)
    else:
        print(f"OK: Disk usage is at {usage_percent}%")
        sys.exit(0)

if __name__ == "__main__":
    main()