# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Build the Pollster user, and make a relatively complex poll.
pollster = User.create(first_name: "Pollster", last_name: "", email: "pollster@pollster.com", password: "pollster")
poll = pollster.user_polls.new(title: "Welcome to Pollster!", description: "At Pollster, we take survey feedback seriously, so please take a moment to let us know what you think about Pollster!")
question1 = poll.poll_questions.new(text: "Overall, how do you like Pollster?")
question1_answer1 = question1.answers.new(text: "Love it")
question1_answer2 = question1.answers.new(text: "It's OK")
question1_answer3 = question1.answers.new(text: "Could be better")
question1_answer1.results.new(votes: 214)
question1_answer2.results.new(votes: 92)
question1_answer3.results.new(votes: 13)

question2 = poll.poll_questions.new(text: "Is it easy to make polls?")
question2_answer1 = question2.answers.new(text: "Very easy")
question2_answer2 = question2.answers.new(text: "Easy")
question2_answer3 = question2.answers.new(text: "Moderate")
question2_answer4 = question2.answers.new(text: "Hard")
question2_answer5 = question2.answers.new(text: "Very hard")
question2_answer1.results.new(votes: 122)
question2_answer2.results.new(votes: 98)
question2_answer3.results.new(votes: 42)
question2_answer4.results.new(votes: 51)
question2_answer5.results.new(votes: 194)

poll.save

# Build John Smith, who likes to make a lot of stupid polls.
john_smith = User.create(first_name: "John", last_name: "Smith", email: "johnsmith@gmail.com", password: "johnsmith")

12.times do |num|
  poll = john_smith.user_polls.new(title: "John Smith's Poll #{num+1}", description: "Take my poll!")
  question = poll.poll_questions.new(text: "Yes?")
  question_answer1 = question.answers.new(text: "Yes")
  question_answer2 = question.answers.new(text: "No")

  question_answer1.results.new(votes: num)
  question_answer2.results.new(votes: num*10)

  poll.save
end

if ENV["loadtest_seed"]
	2000.times do |num|
	  new_user = User.create(first_name: "Seed", last_name: "User#{num+1}", email: "seeduser#{num+1}@pollster.com", password: "pollster")
	  poll = new_user.user_polls.new(title: "Seed User#{num+1}'s Poll #{num+1}", description: "Take my poll!")
	  question = poll.poll_questions.new(text: "Yes?")
	  question_answer1 = question.answers.new(text: "Yes")
	  question_answer2 = question.answers.new(text: "No")

	  question_answer1.results.new(votes: num)
	  question_answer2.results.new(votes: num*2)

	  comment = poll.comments.new(commenter: "seeduser#{num+1}", body: "Commenting is so awesome!")

	  poll.save
	end
end
