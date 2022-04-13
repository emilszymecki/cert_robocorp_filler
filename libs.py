def get_quizz_data(str,data):
    return [el for el in data if el["question"] == str][0]
    
