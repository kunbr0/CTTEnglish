//questions taken from https://opentdb.com
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'category.dart';
import 'question.dart';

const Map<int, dynamic> demoAnswers = {
  0: "Multi Pass",
  1: 1,
  2: "Motherboard",
  3: "Cascading Style Sheet",
  4: "Marshmallow",
  5: "140",
  6: "Python",
  7: "True",
  8: "Jakarta"
};

final questionStructure = {
  "easy": {"easy": 0.7, "medium": 0.2, "hard": 0.1},
  "medium": {"easy": 0.5, "medium": 0.3, "hard": 0.2},
  "hard": {"easy": 0.3, "medium": 0.4, "hard": 0.3},
};

final List<String> topicList = ["TOEIC", "IELTS", "BY TOPICS"];

final List<int> difficulties = [10, 15, 20, 25];

final List<Category> categories = [
  Category(9, "Test 1", icon: FontAwesomeIcons.bookOpen),
  Category(10, "Test 2", icon: FontAwesomeIcons.addressBook),
  Category(11, "Test 3", icon: FontAwesomeIcons.android),
  Category(11, "Test 4", icon: FontAwesomeIcons.certificate),
  Category(11, "Test 5", icon: FontAwesomeIcons.photoVideo),
  Category(11, "Test 6", icon: FontAwesomeIcons.adobe)
];

final List<Question> demoQuestions = Question.fromData(
    //test1
    [
      {
        "question":
            "When you need supplies,..........a request with the office manager.",
        "incorrect_answers": ["filling", "fell", "fallen"],
        "correct_answer": "file",
        "type": "multiple",
        "category": "test 2",
        "difficulty": "easy"
      },
      {
        "question":
            "The bell captain suggested that more porters..........hired.",
        "incorrect_answers": ["are", "have", "do"],
        "correct_answer": "be",
        "type": "multiple",
        "category": "test 2",
        "difficulty": "easy"
      },
      {
        "question": "The last train to Hamburg..........at 10:30.",
        "incorrect_answers": ["depart", "to depart", "departing"],
        "correct_answer": "departs",
        "type": "multiple",
        "category": "test 2",
        "difficulty": "easy"
      },
      {
        "question": "The vice-president will be seated .........",
        "incorrect_answers": ["as", "to", "from"],
        "correct_answer": "by",
        "type": "multiple",
        "category": "test 2",
        "difficulty": "easy"
      },
      {
        "question": "The manager got his staff .........",
        "incorrect_answers": ["was working", "workable", "worked"],
        "correct_answer": "to work",
        "type": "multiple",
        "category": "test 2",
        "difficulty": "easy"
      },
      {
        "question": "The newspaper expects circulation .........",
        "incorrect_answers": ["to ascend", "to escalate", "to raise"],
        "correct_answer": "to increase",
        "type": "multiple",
        "category": "test 2",
        "difficulty": "easy"
      },
      {
        "question": "The head of operations .........",
        "incorrect_answers": ["going", "are going", "go"],
        "correct_answer": "is going",
        "type": "multiple",
        "category": "test 2",
        "difficulty": "easy"
      },
      {
        "question": "Reductions in the budget require us .........",
        "incorrect_answers": ["limits", "limiting", "limit"],
        "correct_answer": "to limit",
        "type": "multiple",
        "category": "test 2",
        "difficulty": "easy"
      },
      {
        "question": "The ticketholders may be .........",
        "incorrect_answers": ["confusing", "confuse", "confuses"],
        "correct_answer": "confused",
        "type": "multiple",
        "category": "test 2",
        "difficulty": "easy"
      },

      //TEST2/////////////////////////////////////////////////////////////

      {
        "question":
            "Mr. Cruz needs someone to .......... him with the conference display.",
        "incorrect_answers": ["assume", "assign", "assent"],
        "correct_answer": "assist",
        "type": "multiple",
        "category": "test 1",
        "difficulty": "easy"
      },
      {
        "question": "The stapler is .......... the desk.",
        "incorrect_answers": ["through", "into", "without"],
        "correct_answer": "on",
        "type": "multiple",
        "category": "test 1",
        "difficulty": "easy"
      },
      {
        "question":
            "Each passenger's name .......... with his or her cabin number",
        "incorrect_answers": ["is list", "listing", " is listing"],
        "correct_answer": "is listed",
        "type": "multiple",
        "category": "test 1",
        "difficulty": "easy"
      },
      {
        "question":
            "If the delivery is late, we .......... the shipping charges.",
        "incorrect_answers": ["paid", "have paid", "are paying"],
        "correct_answer": "will pay",
        "type": "multiple",
        "category": "test 1",
        "difficulty": "easy"
      },
      {
        "question": "The bus will leave promptly .......... 8:30.",
        "incorrect_answers": ["until", "to", "for"],
        "correct_answer": "at",
        "type": "multiple",
        "category": "test 1",
        "difficulty": "easy"
      },
      {
        "question":
            "The ship's captain requests that all passengers .......... emergency procedures.",
        "incorrect_answers": ["reviewing", "reviews", "to review"],
        "correct_answer": "review",
        "type": "multiple",
        "category": "test 1",
        "difficulty": "easy"
      },
      {
        "question":
            "Ms. Friel .......... about her promotion before it was announced.",
        "incorrect_answers": ["known", "is knowing", "has known"],
        "correct_answer": "knew",
        "type": "multiple",
        "category": "test 1",
        "difficulty": "easy"
      },
      {
        "question":
            "All travel arrangements must be completed .......... December 5.",
        "incorrect_answers": ["with", "in", "for"],
        "correct_answer": "by",
        "type": "multiple",
        "category": "test 1",
        "difficulty": "easy"
      },
      {
        "question": "The airport was .......... Mr. Debionne had expected.",
        "incorrect_answers": ["the busiest", "busy as", "as busy"],
        "correct_answer": "busier than",
        "type": "multiple",
        "category": "test 1",
        "difficulty": "easy"
      },
      {
        "question": "A firm will not .......... if its employees are unhappy.",
        "incorrect_answers": ["prosperous", "prosperity", "prospering"],
        "correct_answer": "prosper",
        "type": "multiple",
        "category": "test 1",
        "difficulty": "easy"
      },
      //TEST3////////////////////////////////////////////////////////////////

      {
        "question":
            "At midnight, the second shift of security guards .......... . on duty.",
        "incorrect_answers": ["coming", "to come", "come"],
        "correct_answer": "comes ",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "easy"
      },
      {
        "question": "Ms. Najar wants to .......... the costs by tonight.",
        "incorrect_answers": ["final ", "finally ", "finality "],
        "correct_answer": "finalize ",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "easy"
      },
      {
        "question": "Ms. Yu has suggested ..........more reservation clerks.",
        "incorrect_answers": ["hire", "hired", "to hire"],
        "correct_answer": "hiring ",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "easy"
      },
      {
        "question":
            " A customer service representative .......... at our catalogue number.",
        "incorrect_answers": [
          "always is available ",
          "is available always ",
          "being always available"
        ],
        "correct_answer": " is always available ",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "easy"
      },
      {
        "question": "Can you meet with us .......... 11:00?",
        "incorrect_answers": ["on ", "for", "in"],
        "correct_answer": "at ",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "easy"
      },
      {
        "question": " The manager suggested .......... a research team.",
        "incorrect_answers": ["took ", "take ", "taken"],
        "correct_answer": "organizing",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "easy"
      },
      {
        "question":
            "The receptionist .......... a message if you do not answer your phone.",
        "incorrect_answers": ["includes", "is including ", "included "],
        "correct_answer": "takes",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "easy"
      },
      {
        "question":
            " A list of compatible software .......... with your new computer.",
        "incorrect_answers": ["to include", "including", "include"],
        "correct_answer": "is included",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "easy"
      },
      {
        "question":
            "The price of all cruises.......... airfare and all transfers.",
        "incorrect_answers": ["to include ", "including ", "include"],
        "correct_answer": "includes",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "easy"
      },
      {
        "question":
            ".......... we were late, we could not enter the conference hall.",
        "incorrect_answers": ["Although ", "Therefore ", "However"],
        "correct_answer": "Because",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "easy"
      },

      //MEDIUM

      {
        "question":
            "The new insurance plan is especially .......... with employees who have families.",
        "incorrect_answers": ["popularized  ", "populated ", "popularity "],
        "correct_answer": "popular ",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "medium"
      },
      {
        "question": "You should check your messages ..........",
        "incorrect_answers": ["as soon as", "seldom ", "rarely"],
        "correct_answer": "twice a day ",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "medium"
      },
      {
        "question":
            "The operator .......... Mr. Smith if she knew where to reach him",
        "incorrect_answers": ["will call", "had called", "called"],
        "correct_answer": "would call ",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "medium"
      },
      {
        "question":
            "The company .......... spouses of employees in the invitation to the banquet.",
        "incorrect_answers": [
          "are included  ",
          "have included  ",
          "has including "
        ],
        "correct_answer": "is including ",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "medium"
      },
      {
        "question":
            "We cannot process the order .......... we get a copy of the purchase order.",
        "incorrect_answers": ["because  ", "that  ", "when"],
        "correct_answer": "until",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "medium"
      },
      {
        "question": "The package should arrive .......... Tuesday.",
        "incorrect_answers": ["in", "on", "at "],
        "correct_answer": "on",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "medium"
      },
      {
        "question": "The company has quit .......... in that magazine.",
        "incorrect_answers": ["to advertise", "advertise", "advertisement"],
        "correct_answer": "advertising",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "medium"
      },
      {
        "question": "Hiring temporary workers can be very..........",
        "incorrect_answers": ["economize", "economically", "economy"],
        "correct_answer": "economical",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "medium"
      },
      {
        "question": "Mr. Ho's assistant .......... his mail while he was away.",
        "incorrect_answers": ["will answer  ", "answers  ", "answering "],
        "correct_answer": "answered",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "medium"
      },
      {
        "question": "The bookcase is .......... the door.",
        "incorrect_answers": ["among  ", "between  ", "across"],
        "correct_answer": "beside",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "medium"
      },

      //HARD

      {
        "question": " Mr. Hatori was very..........when he got a promotion.",
        "incorrect_answers": ["excite", "exciting", "excites"],
        "correct_answer": "excited ",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "hard"
      },
      {
        "question": " .......... she left the ship, the purser signed out.",
        "incorrect_answers": ["For", "That", "And"],
        "correct_answer": "Before ",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "hard"
      },
      {
        "question": "Ask the accounts receivable clerk .......... the invoice.",
        "incorrect_answers": ["sending", "will send", "sends"],
        "correct_answer": "to send ",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "hard"
      },
      {
        "question": "If the product were not safe, we .......... it.",
        "incorrect_answers": ["had sold", "don't sell", "will sell"],
        "correct_answer": "would not sell ",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "hard"
      },
      {
        "question": "The meeting will be held .......... Thursday",
        "incorrect_answers": ["of", "in", "for"],
        "correct_answer": "on",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "hard"
      },
      {
        "question": "Our company stands for quality .......... design.",
        "incorrect_answers": ["or", "but", "neither"],
        "correct_answer": "and",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "hard"
      },
      {
        "question": "This list of contributors is more .......... that one.",
        "incorrect_answers": ["current", "currently", "current as"],
        "correct_answer": "current than",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "hard"
      },
      {
        "question":
            " The ship's restaurant is located .......... the sun deck.",
        "incorrect_answers": ["under", "in", "composes"],
        "correct_answer": "on",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "hard"
      },
      {
        "question":
            "The secretary .......... a letter when the computer crashed.",
        "incorrect_answers": ["composed ", "is composing", "composes"],
        "correct_answer": "was composing",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "hard"
      },
      {
        "question": "The intern .......... a fax machine before.",
        "incorrect_answers": [
          "had used never",
          "never had used",
          "used had never"
        ],
        "correct_answer": "had never used",
        "type": "multiple",
        "category": "test 3",
        "difficulty": "hard"
      },
    ]);
