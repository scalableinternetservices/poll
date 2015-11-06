# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

pollster = User.create(first_name: "Pollster", last_name: "", email: "pollster@pollster.com", password: "pollster")
poll = UserPoll.new(user_id: pollster.id, title: "Welcome to Pollster!", description: "At Pollster, we take survey feedback seriously, so please take a moment to let us know what you think about Pollster!")
question1 = poll.poll_questions.new(user_poll_id: poll.id, text: "Overall, how do you like Pollster?")
question1_answer1 = question1.answers.new(poll_question_id: question1.id, text: "Love it")
question1_answer2 = question1.answers.new(poll_question_id: question1.id, text: "It's OK")
question1_answer3 = question1.answers.new(poll_question_id: question1.id, text: "Could be better")
question1_answer1.results.new(answer_id: question1_answer1.id, votes: 3214)
question1_answer2.results.new(answer_id: question1_answer2.id, votes: 902)
question1_answer3.results.new(answer_id: question1_answer3.id, votes: 103)

question2 = poll.poll_questions.new(user_poll_id: poll.id, text: "Is it easy to make polls?")
question2_answer1 = question2.answers.new(poll_question_id: question2.id, text: "Very easy")
question2_answer2 = question2.answers.new(poll_question_id: question2.id, text: "Easy")
question2_answer3 = question2.answers.new(poll_question_id: question2.id, text: "Moderate")
question2_answer4 = question2.answers.new(poll_question_id: question2.id, text: "Hard")
question2_answer5 = question2.answers.new(poll_question_id: question2.id, text: "Very hard")
question2_answer1.results.new(answer_id: question2_answer1.id, votes: 2122)
question2_answer2.results.new(answer_id: question2_answer2.id, votes: 1098)
question2_answer3.results.new(answer_id: question2_answer3.id, votes: 402)
question2_answer4.results.new(answer_id: question2_answer4.id, votes: 501)
question2_answer5.results.new(answer_id: question2_answer5.id, votes: 1194)

poll.save
