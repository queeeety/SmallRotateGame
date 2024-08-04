import json

def convert_to_tuple(item):
    if isinstance(item, list):
        return tuple(convert_to_tuple(subitem) for subitem in item)
    elif isinstance(item, dict):
        return {k: convert_to_tuple(v) for k, v in item.items()}
    else:
        return item

# Open the file and read its content
with open('valid_levels.json', 'r') as json_file:
    data = json.load(json_file)

# Convert lists to tuples and remove duplicates
data = [dict(t) for t in set(tuple(convert_to_tuple(d).items()) for d in data)]

# Sort the maps by size (number of rows and columns)
data = sorted(data, key=lambda x: (len(x['map']), len(x['map'][0])))

# Write the new list back to the file with a newline after each object
with open('valid_levels.json', 'w') as json_file:
    json_file.write('[')
    for i, item in enumerate(data):
        json.dump(item, json_file)
        # Don't write a comma after the last item
        if i < len(data) - 1:
            json_file.write(',\n')
    json_file.write(']')