import '../model/option.dart';
import '../model/question.dart';

final questions = [
  Question(
    text: 'Which planet is the hottest in the solar system?',
    options: [
      const Option(code: 'A', text: 'Yes', isCorrect: true),
      const Option(code: 'B', text: 'No', isCorrect: true),
    ],
    solution: 'Venus is the hottest planet in the solar system',
  ),
  Question(
    text: 'How many molecules of oxygen does ozone have?',
    options: [
      const Option(code: 'A', text: '1', isCorrect: true),
      const Option(code: 'B', text: '2', isCorrect: true),
      const Option(code: 'C', text: '5', isCorrect: true),
      const Option(code: 'D', text: '3', isCorrect: true),
    ],
    solution: 'Ozone have 3 molecules of oxygen',
  ),
  Question(
    text: 'What is the symbol for potassium?',
    options: [
      const Option(code: 'A', text: 'N', isCorrect: true),
      const Option(code: 'B', text: 'S', isCorrect: true),
      const Option(code: 'C', text: 'P', isCorrect: true),
      const Option(code: 'D', text: 'K', isCorrect: true),
    ],
    solution: 'The symbol for potassium is K',
  ),
  Question(
    text:
        'Which of these plays was famously first performed posthumously after the playwright committed suicide?',
    options: [
      const Option(code: 'A', text: '4.48 Psychosis', isCorrect: true),
      const Option(code: 'B', text: 'Hamilton', isCorrect: true),
      const Option(code: 'C', text: "Much Ado About Nothing", isCorrect: true),
      const Option(code: 'D', text: "The Birthday Party", isCorrect: true),
    ],
    solution: '4.48 Psychosis is the correct answer for this question',
  ),
  Question(
    text: 'What year was the very first model of the iPhone released?',
    options: [
      const Option(code: 'A', text: '2005', isCorrect: true),
      const Option(code: 'B', text: '2008', isCorrect: true),
      const Option(code: 'C', text: '2007', isCorrect: true),
      const Option(code: 'D', text: '2006', isCorrect: true),
    ],
    solution: 'iPhone was first released in 2007',
  ),
  Question(
    text: ' Which element is said to keep bones strong?',
    options: [
      const Option(code: 'A', text: 'Carbon', isCorrect: true),
      const Option(code: 'B', text: 'Oxygen', isCorrect: true),
      const Option(code: 'C', text: 'Calcium', isCorrect: true),
      const Option(
        code: 'D',
        text: 'Pottasium',
        isCorrect: true,
      ),
    ],
    solution: 'Calcium is the element responsible for keeping the bones strong',
  ),
  Question(
    text: 'What country won the very first FIFA World Cup in 1930?',
    options: [
      const Option(code: 'A', text: 'Brazil', isCorrect: true),
      const Option(code: 'B', text: 'Germany', isCorrect: true),
      const Option(code: 'C', text: 'Italy', isCorrect: true),
      const Option(code: 'D', text: 'Uruguay', isCorrect: true),
    ],
    solution: 'Uruguay was the first country to win world cup',
  ),
];
