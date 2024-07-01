import time
import psutil

def simulate_memory_spike(duration=30, memory_percent=80):
    print(f"Simulating memory spike at {memory_percent}%...")
    start_time = time.time()

    # Get total memory and calculate the target usage
    total_memory = psutil.virtual_memory().total
    target_memory = total_memory * (memory_percent / 100)
    
    # Allocate memory to reach the target usage
    memory_spike = []
    allocation_size = int(target_memory / 1024)  # Convert bytes to KB
    while len(memory_spike) * 1024 < allocation_size:
        memory_spike.append(' ' * 1024)  # Allocate memory in 1KB chunks

    # Wait for the specified duration
    time.sleep(duration)

    # Release the allocated memory
    memory_spike = None
    elapsed_time = time.time() - start_time

    print("Memory spike simulation completed. Elapsed time:", elapsed_time, "seconds")

if __name__ == '__main__':
    # Simulate a memory spike for 30 seconds with 80% memory usage
    simulate_memory_spike(duration=30, memory_percent=80)
