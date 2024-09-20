import matplotlib.pyplot as plt
import re
import sys

def parse_sym_file(sym_file_path):
    used_ids = set()

    # Regular expression for matching ID lines
    id_pattern = re.compile(r'ID=(\w+)h', re.IGNORECASE)

    with open(sym_file_path, 'r') as file:
        for line in file:
            id_match = id_pattern.search(line)
            if id_match:
                can_id = int(id_match.group(1), 16)  # Convert hex to int
                # Only add IDs within the 11-bit CAN ID range (0x000 to 0x7FF)
                if 0x000 <= can_id <= 0x7FF:
                    used_ids.add(can_id)

    return used_ids

def plot_can_id_space(used_ids):
    # Define the full 11-bit CAN ID range (0x000 to 0x7FF)
    all_ids = set(range(0x000, 0x800))  
    available_ids = all_ids - used_ids

    plt.figure(figsize=(15, 6))
    
    # Plotting available and used CAN IDs
    plt.scatter(sorted(available_ids), [1] * len(available_ids), color='green', label='Available', s=10)
    plt.scatter(sorted(used_ids), [1] * len(used_ids), color='red', label='Used', s=10)
    
    plt.xlabel('CAN ID')
    plt.ylabel('Availability')
    plt.yticks([])  # No need for y-axis ticks
    plt.title('CAN ID Space (0x000 to 0x7FF) Availability')
    plt.grid(axis='x', linestyle='--', linewidth=0.5)
    plt.legend()
    plt.tight_layout()
    plt.show()
if __name__ == "__main__":
    sym_file_path = sys.argv[1]  # Replace with your actual .sym file path
    used_ids = parse_sym_file(sym_file_path)
    plot_can_id_space(used_ids)
