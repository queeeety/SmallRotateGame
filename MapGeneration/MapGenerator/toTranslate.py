import random
import queue
import json

CONNECTIONS = {
    1: [["up"], ["down"], ["left"], ["right"]],
    2: [["up", "down"], ["left", "right"]],
    3: [["up", "right"], ["right", "down"], ["down", "left"], ["left", "up"]],
    4: [["up", "right", "down"], ["right", "down", "left"], ["down", "left", "up"], ["left", "up", "right"]],
    5: [["up", "down", "left", "right"]]
}
SIZES = [[3, 10], [3, 10]]
# Directions to offsets for neighbor checking
DIRECTION_OFFSETS = {
    'up': (-1, 0),
    'down': (1, 0),
    'left': (0, -1),
    'right': (0, 1)
}
DIRECTIONS_CONNECTIONS = {
    'up': 'down',
    'down': 'up',
    'left': 'right',
    'right': 'left'
}

level_map_int = [[]]
level_map_connections = [[]]

ConnectionsQueue = queue.Queue()  # [position, previous_connection]


def generate_map():

    # Initialize the map
    global level_map_int
    global level_map_connections
    global ConnectionsQueue
    deadEnds = []
    horisontalSize = random.randint(SIZES[1][0], SIZES[1][1] - 1)
    verticalSize = random.randint(SIZES[0][0], SIZES[0][1] - 1)
    level_map_int = [[0 for _ in range(horisontalSize)] for _ in range(verticalSize)]
    level_map_connections = [[[""] for _ in range(horisontalSize)] for _ in range(verticalSize)]
    # first point
    ConnectionsQueue = queue.Queue()
    first_Point_horizontal_Position = int(horisontalSize / 2)
    first_Point_Vertical_Position = random.randint(1,verticalSize-2)
    first_element_pos = [first_Point_Vertical_Position, first_Point_horizontal_Position]
    count_zeros = sum(element == 0 for row in level_map_int for element in row)
    while count_zeros > len(level_map_int) * len(level_map_int[0]) / 3 * 2:
        while level_map_int[first_element_pos[0]][first_element_pos[1]] != 0 or first_element_pos in deadEnds:
            # згенерували позицію першого елемента
            first_Point_horizontal_Position = random.randint(0, horisontalSize - 1)
            first_Point_Vertical_Position = random.randint(0, verticalSize - 1)
            first_element_pos = [first_Point_Vertical_Position, first_Point_horizontal_Position]

        # зазначили перший елемент на карті
        possibleDictionary = required_connections(first_element_pos)
        if possibleDictionary == {0: ['']}:  # Check if possibleConnections is empty
            deadEnds.append(first_element_pos)
            continue
        level_map_int[first_element_pos[0]][first_element_pos[1]] = random.choice(list(possibleDictionary.keys()))
        current_Connection = random.choice(possibleDictionary[level_map_int[first_element_pos[0]][first_element_pos[1]]])
        level_map_connections[first_element_pos[0]][first_element_pos[1]] = current_Connection

        # add to the queue
        for i in current_Connection:
            if current_Connection in ['up', 'down', 'left', 'right']:
                i = current_Connection
            ConnectionsQueue.put([first_element_pos[0] + DIRECTION_OFFSETS[i][0], first_element_pos[1] + DIRECTION_OFFSETS[i][1]])
        # next part
        addConnections()

        # перевірка на нулі
        count_zeros = sum(element == 0 for row in level_map_int for element in row)

    return 0


def addConnections():
    global level_map_int
    global level_map_connections
    global ConnectionsQueue
    while ConnectionsQueue.qsize() > 0:
        # забираємо з черги
        current_Point = ConnectionsQueue.get()
        if level_map_int[current_Point[0]][current_Point[1]] != 0:
            continue

        # визначаємо можливі з'єднання
        possibleConnections = required_connections(current_Point)
        if not possibleConnections:  # Check if possibleConnections is empty
            continue  # Skip this iteration if it is
        # вибираємо випадкове з'єднання
        randomElement = random.choice(list(possibleConnections.keys()))
        randomConnection = random.choice(possibleConnections[randomElement])

        # зберігаємо інформацію
        level_map_int[current_Point[0]][current_Point[1]] = randomElement
        level_map_connections[current_Point[0]][current_Point[1]] = randomConnection
        for i in randomConnection:
            if randomConnection in ['up', 'down', 'left', 'right']:
                i = randomConnection
            if level_map_int[current_Point[0] + DIRECTION_OFFSETS[i][0]][current_Point[1] + DIRECTION_OFFSETS[i][1]] == 0:
                ConnectionsQueue.put([current_Point[0] + DIRECTION_OFFSETS[i][0], current_Point[1] + DIRECTION_OFFSETS[i][1]])


def required_connections(position: [int, int]):
    global level_map_int
    global level_map_connections
    mandatoryConnections = []
    impossibleConnections = []
    possibleConnections = {}

    if position[0] != len(level_map_int) - 1:
        if 'up' in level_map_connections[position[0] + 1][position[1]]:
            mandatoryConnections.append('down')
        elif level_map_int[position[0] + 1][position[1]] != 0:
            impossibleConnections.append('down')
    else:
        impossibleConnections.append('down')

    if position[0] != 0:
        if 'down' in level_map_connections[position[0] - 1][position[1]]:
            mandatoryConnections.append('up')
        elif level_map_int[position[0] - 1][position[1]] != 0:
            impossibleConnections.append('up')
    else:
        impossibleConnections.append('up')

    if position[1] != len(level_map_int[0]) - 1:
        if 'left' in level_map_connections[position[0]][position[1] + 1]:
            mandatoryConnections.append('right')
        elif level_map_int[position[0]][position[1] + 1] != 0:
            impossibleConnections.append('right')
    else:
        impossibleConnections.append('right')

    if position[1] != 0:
        if 'right' in level_map_connections[position[0]][position[1] - 1]:
            mandatoryConnections.append('left')
        elif level_map_int[position[0]][position[1] - 1] != 0:
            impossibleConnections.append('left')
    else:
        impossibleConnections.append('left')

    if position[0] == 0 and position[1] == 0:  # Top left corner
        impossibleConnections.extend(['up', 'left'])
    elif position[0] == 0 and position[1] == len(level_map_int[0]) - 1:  # Top right corner
        impossibleConnections.extend(['up', 'right'])
    elif position[0] == len(level_map_int) - 1 and position[1] == 0:  # Bottom left corner
        impossibleConnections.extend(['down', 'left'])
    elif position[0] == len(level_map_int) - 1 and position[1] == len(level_map_int[0]) - 1:  # Bottom right corner
        impossibleConnections.extend(['down', 'right'])

    for key, value in CONNECTIONS.items():
        for connection in value:
            if set(mandatoryConnections).issubset(set(connection)) and not set(impossibleConnections).intersection(set(connection)):
                if key in possibleConnections:
                    possibleConnections[key].append(connection)
                else:
                    possibleConnections[key] = [connection]
    if not possibleConnections:
        return {0: ['']}
    return possibleConnections

def fact_checking():
    global level_map_int
    global level_map_connections
    for i in range(len(level_map_int)):
        for j in range(len(level_map_int[i])):
            for connection in level_map_connections[i][j]:
                if connection == '':
                    continue
                if isinstance(connection, list):
                    connection = connection[0]
                if i == len(level_map_int) - 1:
                    if 'down' in connection:
                        return False
                elif i == 0:
                    if 'up' in connection:
                        return False
                elif j == len(level_map_int[i]) - 1:
                    if 'right' in connection:
                        return False
                elif j == 0:
                    if 'left' in connection:
                        return False
                else:
                    new_i = i + DIRECTION_OFFSETS[connection][0]
                    new_j = j + DIRECTION_OFFSETS[connection][1]
                    if new_i < 0 or new_i >= len(level_map_int) or new_j < 0 or new_j >= len(level_map_int[0]):
                        continue
                    if DIRECTIONS_CONNECTIONS[connection] not in level_map_connections[new_i][new_j]:
                        return False

    print("All is good")
    return True


def main():
    global SIZES
    maps = []
    SIZES = [[3, 5], [3, 5]]
    while True:
        generate_map()
        if fact_checking():
            print("Map is valid")
            break
        else:
            print("Map is invalid")
    print("Map number: ", i)


