id_filename = "IDs.txt"
id_dict_filename = "result.txt"

try:
    with open(id_filename, "r") as id_file:
        ids = id_file.read().replace(' ', '').replace('\n', '')

        id_list = ids.split(",")

        result = str()
        num = 1
        for race_id in id_list:
            if num >= 5:
                id_line = f"[{race_id}] = true,\n"
                num = 0
            else:
                id_line = f"[{race_id}] = true, "
            result += id_line
            num += 1

        with open(id_dict_filename, "w") as dict_file:
            dict_file.write(result)
except FileNotFoundError:
    print('File is missing. Create IDs.txt')
