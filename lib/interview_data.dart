// A simple class to hold the structure of a question
class InterviewQuestion {
  final int id;
  final String question;
  final List<String> options;

  InterviewQuestion({
    required this.id,
    required this.question,
    required this.options,
  });
}

// A list holding all the questions for the interview
final List<InterviewQuestion> interviewQuestions = [
  InterviewQuestion(id: 1, question: "What is your overall body build?", options: ["Slim", "Medium", "Large"]),
  InterviewQuestion(id: 2, question: "How is your body weight tendency?", options: ["Difficult to gain/lose", "Moderate", "Easily gains weight"]),
  InterviewQuestion(id: 3, question: "What is your height category?", options: ["Short", "Average", "Tall"]),
  InterviewQuestion(id: 4, question: "How would you describe your bone structure?", options: ["Light & small", "Medium", "Large & heavy"]),
  InterviewQuestion(id: 5, question: "What best describes your skin complexion?", options: ["Fair", "Dark", "Tans easily"]),
  InterviewQuestion(id: 6, question: "How does your skin feel to touch?", options: ["Dry & cool", "Smooth & warm", "Soft & oily"]),
  InterviewQuestion(id: 7, question: "What is the texture of your skin?", options: ["Dry", "Oily", "Mixed"]),
  InterviewQuestion(id: 8, question: "What is your natural hair color?", options: ["Black", "Brown", "Blonde/Red"]),
  InterviewQuestion(id: 9, question: "How does your hair look?", options: ["Dry & Wavy/Curly", "Straight & Oily", "Thick & Lustrous"]),
  InterviewQuestion(id: 10, question: "What is the shape of your face?", options: ["Long", "Angular", "Round/Square"]),
  InterviewQuestion(id: 11, question: "What best describes your eyes?", options: ["Small", "Medium", "Large"]),
  InterviewQuestion(id: 12, question: "How are your eyelashes?", options: ["Sparse", "Moderate", "Thick"]),
  InterviewQuestion(id: 13, question: "How frequently do you blink your eyes?", options: ["Frequent", "Moderate", "Rare"]),
  InterviewQuestion(id: 14, question: "Describe your cheeks.", options: ["Flat", "Moderate", "Full"]),
  InterviewQuestion(id: 15, question: "Describe your nose.", options: ["Thin", "Medium", "Broad"]),
  InterviewQuestion(id: 16, question: "Describe your teeth and gums.", options: ["Small, irregular", "Medium, healthy", "Large, white"]),
  InterviewQuestion(id: 17, question: "Describe your lips.", options: ["Thin & Dry", "Medium & Moist", "Thick & Oily"]),
  InterviewQuestion(id: 18, question: "Describe your nails.", options: ["Brittle", "Smooth", "Strong"]),
  InterviewQuestion(id: 19, question: "How is your appetite?", options: ["Low", "Moderate", "High"]),
  InterviewQuestion(id: 20, question: "Which tastes do you prefer?", options: ["Sweet/Salty/Sour", "Spicy/Pungent", "Bitter/Astringent"]),
  InterviewQuestion(id: 21, question: "How would you describe your metabolism?", options: ["Slow", "Moderate", "Fast"]),
  InterviewQuestion(id: 22, question: "In which climate do you feel most comfortable?", options: ["Warm", "Cool", "Moderate"]),
  InterviewQuestion(id: 23, question: "How often do you feel stressed?", options: ["Often & Anxious", "Irritable under pressure", "Calm, but slow to act"]),
  InterviewQuestion(id: 24, question: "How is your sleep pattern?", options: ["Short & Disturbed", "Moderate & Deep", "Long & Heavy"]),
  InterviewQuestion(id: 25, question: "What is your dietary habit?", options: ["Vegan", "Vegetarian", "Omnivorous"]),
  InterviewQuestion(id: 26, question: "How physically active are you?", options: ["Sedentary", "Moderate", "Active"]),
  InterviewQuestion(id: 27, question: "How much water do you drink daily?", options: ["Low", "Moderate", "High"]),
  InterviewQuestion(id: 28, question: "How would you rate your digestion?", options: ["Weak", "Moderate", "Strong"]),
  InterviewQuestion(id: 29, question: "How sensitive is your skin?", options: ["Sensitive", "Normal", "Not sensitive"]),
];
