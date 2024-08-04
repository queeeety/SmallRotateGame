import json
import random

# Define constants and configurations
MAP_MIN_SIZE = (2, 1)  # Minimum map size
MAP_MAX_SIZE = (8, 10) # Maximum map size
LEVELS_COUNT = 100     # Number of levels to generate

# Connections for different element types
CONNECTIONS = {
    1: ['up', 'down', 'left', 'right'],
    2: [['up', 'down'], ['left', 'right']],
    3: [['up', 'right'], ['right', 'down'], ['down', 'left'], ['left', 'up']],
    4: [['up', 'right', 'down'], ['right', 'down', 'left'], ['down', 'left', 'up'], ['left', 'up', 'right']],
    5: ['up', 'down', 'left', 'right']
}

# Directions to offsets for neighbor checking
DIRECTION_OFFSETS = {
    'up': (-1, 0),
    'down': (1, 0),
    'left': (0, -1),
    'right': (0, 1)
}

def initialize_map(height, width):
    return [[None for _ in range(width)] for _ in range(height)]

def is_valid_position(x, y, height, width):
    return 0 <= x < height and 0 <= y < width

def place_element(map_data, x, y, element, connections):
    map_data[x][y] = (element, connections)

def generate_valid_level(height, width):
    level_map = initialize_map(height, width)
    visited = set()

    # Ensure the starting point is valid for the given map size
    x, y = random.randint(0, height - 1), random.randint(0, width - 1)
    visited.add((x, y))

    while True:
        element = random.choice([1, 2, 3, 4, 5])
        connections = random.choice(CONNECTIONS[element])

        # Ensure connections is a list of strings
        if isinstance(connections, str):
            connections = [connections]

        place_element(level_map, x, y, element, connections)

        # Move to the next position based on connections
        moved = False
        for connection in connections:
            if connection in DIRECTION_OFFSETS:
                dx, dy = DIRECTION_OFFSETS[connection]
                new_x, new_y = x + dx, y + dy
                if is_valid_position(new_x, new_y, height, width) and (new_x, new_y) not in visited:
                    visited.add((new_x, new_y))
                    x, y = new_x, new_y
                    moved = True
                    break
        if not moved:
            # If no valid move, fill remaining with 0
            for i in range(height):
                for j in range(width):
                    if level_map[i][j] is None:
                        level_map[i][j] = 0
            break

    # Simplify the map to contain only element numbers for output
    simple_map = [[element if isinstance(cell, tuple) else cell for cell in row] for row in level_map]
    return simple_map

def generate_levels(count):
    levels = []
    for _ in range(count):
        height = random.randint(MAP_MIN_SIZE[0], MAP_MAX_SIZE[0])
        width = random.randint(MAP_MIN_SIZE[1], MAP_MAX_SIZE[1])
        level_map = generate_valid_level(height, width)
        levels.append({"map": level_map, "isSolved": False})
    return levels

levels = generate_levels(LEVELS_COUNT)

# Save the levels to a JSON file
json_levels = json.dumps(levels, separators=(',', ':'))
file_path = "valid_levels.json"
with open(file_path, "w") as file:
    file.write(json_levels)

print("Levels generated and saved to valid_levels.json")