extends Node
class_name DraftGenerator

var adjectives = []
var nouns = []
var is_wordbank_loaded = false

# Constructor
func _init():
	load_wordbank("res://word_bank.txt")

# Function to load and parse the wordbank
func load_wordbank(file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var wordbank_text = file.get_as_text()
	parse_wordbank(wordbank_text)
	file.close()
	is_wordbank_loaded = true


# Function to unescape quoted values
func unescape_value(value: String) -> String:
	if value.begins_with('"') and value.ends_with('"'):
		value = value.substr(1, value.length() - 2) # Remove surrounding quotes
	return value.replace('""', '"') # Replace double quotes with a single quote

# Function to split a line into adjective and noun, considering escaped commas and quotes
func split_line(line: String) -> Array:
	var parts = []
	var current = ""
	var in_quotes = false

	for i in range(line.length()):
		var charx = line[i]
		
		if charx == '"' and (i == 0 or line[i - 1] != '"'):
			in_quotes = !in_quotes
		elif charx == ',' and !in_quotes:
			parts.append(current)
			current = ""
		else:
			current += charx

	parts.append(current)
	return parts.map(unescape_value)

# Main function to parse the wordbank
func parse_wordbank(wordbank: String) -> void:
	for i in range(1, wordbank.split('\n').size()): # Skip the first line (header)
		var line = wordbank.split('\n')[i].strip_edges()
		if line == "":
			continue

		var parts = split_line(line)
		if parts.size() == 2:
			adjectives.append(parts[0])
			nouns.append(parts[1])

# Method to check if wordbank is loaded
func is_wordbank_ready() -> bool:
	return is_wordbank_loaded

# Method to get a random adjective
func get_random_adjective() -> String:
	if adjectives.size() == 0:
		return ""
	return adjectives[randi() % adjectives.size()]

# Method to get a random noun
func get_random_noun() -> String:
	if nouns.size() == 0:
		return ""
	return nouns[randi() % nouns.size()]
