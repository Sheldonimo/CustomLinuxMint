#!/usr/bin/env python3

import json
import argparse

def add_config_to_json(file_path, new_config_str):
    try:
        # Convert the configuration string into a dictionary
        new_config = json.loads(new_config_str)

        # Open and read the existing JSON file
        with open(file_path, 'r+') as file:
            config_data = json.load(file)

            # Update the file with the new configuration
            config_data.update(new_config)

            # Position at the beginning of the file to overwrite
            file.seek(0)
            file.write(json.dumps(config_data, indent=4))
            file.truncate() # Remove any remaining content

        print(f"Configuration successfully added to {file_path}")
    except json.JSONDecodeError:
        print("Error in the JSON format of the new configuration.")
    except FileNotFoundError:
        print(f"File not found: {file_path}")
    except Exception as e:
        print(f"Error updating the file: {str(e)}")

def main():
    parser = argparse.ArgumentParser(description="Adds a configuration to a VSCode JSON configuration file. This script takes two arguments: the path to the JSON file and a string containing the new configuration in JSON format. It updates or adds the new configuration to the specified file.")
    parser.add_argument("file_path", help="The file path to the JSON configuration file that needs to be modified. This should be the full path to the file, for example, '/path/to/settings.json'.")
    parser.add_argument("new_config_str", help="A JSON-formatted string representing the new configuration to be added. Ensure that this string is properly formatted as valid JSON. For example, '{\"newKey\": \"newValue\"}'.")

    args = parser.parse_args()
    add_config_to_json(args.file_path, args.new_config_str)

if __name__ == "__main__":
    main()
