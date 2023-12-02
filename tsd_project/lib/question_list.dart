class QuestionModel {
  //String is declared to store the question
  String question;
  //Map is declared to store the answers
  Map<String, double> answers;

  //Creating the constructor
  QuestionModel(this.question, this.answers);
}

//Here, we must create a list and store the questions according to the model
//Later, this list of questions will be requested from the backend and stored here
//In the question model, we have a string to store question and a map to store answers
List<QuestionModel> questionList = [
  //Each question is stored here using the Question Model
  QuestionModel('Have you had little interest or pleasure in doing things ?', {
    'Not at all': 0.0,
    'Several days': 40.0,
    'Over half of the days': 70.0,
    'Nearly every day': 100.0,
  }),
  QuestionModel('Do you feel bad about yourself ? ', {
    'Not at all': 0.0,
    'Several days': 40.0,
    'Over half of the days': 70.0,
    'Nearly every day': 100.0,
  }),
  QuestionModel('Are you having any trouble of sleeping ? ', {
    'Not at all, I sleep normaly everyday': 0.0,
    'Most of the days, I sleep too much': 80.0,
    'Most of the days,I have trouble of staying asleep': 80.0,
    'Some days, I sleep too much': 50.0,
    'Some days, have trouble of staying asleep': 50.0,
  }),
  QuestionModel('Did you had any suicidal thoughts ? ', {
    'Not at all, I never had any': 0.0,
    'I had many, but i never tried': 90.0,
    'I had several, but i never tried': 60.0,
    'I had many, I also tried to': 100.0,
    'I had several, I also tried to': 100.0,
  })
];
