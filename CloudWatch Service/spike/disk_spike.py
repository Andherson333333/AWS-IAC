import time
import os
import psutil

def simulate_disk_spike(duration=30, disk_percent=80, file_path="temp_file"):
    print(f"Simulating disk spike at {disk_percent}%...")
    start_time = time.time()

    # Get total disk space and calculate the target usage
    disk_info = psutil.disk_usage('/')
    target_disk = disk_info.total * (disk_percent / 100)

    # Write a large file to disk to reach the target usage
    with open(file_path, 'wb') as f:
        f.write(os.urandom(int(target_disk)))  # Write random bytes

    # Wait for the specified duration
    time.sleep(duration)

    # Delete the file to clean up
    os.remove(file_path)
    elapsed_time = time.time() - start_time

    print("Disk spike simulation completed. Elapsed time:", elapsed_time, "seconds")

if __name__ == '__main__':
    # Simulate a disk spike for 30 seconds with 80% disk usage
    simulate_disk_spike(duration=30, disk_percent=80)
