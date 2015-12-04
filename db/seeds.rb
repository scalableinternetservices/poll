# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Build the Pollster user.
pollster = User.create(first_name: "Pollster", last_name: "", email: "pollster@pollster.com", password: "pollster")
large_poll = pollster.user_polls.new(title: "Large poll", description: "Description for a large poll")

10.times do |num|
  question = large_poll.poll_questions.new(text: "Question #{num}")
  10.times do |num2|
    answer = question.answers.new(text: "Opt #{num2}", votes: 0)
  end
end

large_poll.save

# Build the large poll used for load-testing.

# Build the Pollster user, and make a relatively complex poll.

poll = pollster.user_polls.new(title: "Welcome to Pollster!", description: "At Pollster, we take survey feedback seriously, so please take a moment to let us know what you think about Pollster!")
question1 = poll.poll_questions.new(text: "Overall, how do you like Pollster?")
question1_answer1 = question1.answers.new(text: "Love it", votes: 24)
question1_answer2 = question1.answers.new(text: "It's OK", votes: 92)
question1_answer3 = question1.answers.new(text: "Could be better", votes: 13)

question2 = poll.poll_questions.new(text: "Is it easy to make polls?")
question2_answer1 = question2.answers.new(text: "Very easy", votes: 12)
question2_answer2 = question2.answers.new(text: "Easy", votes: 98)
question2_answer3 = question2.answers.new(text: "Moderate", votes: 42)
question2_answer4 = question2.answers.new(text: "Hard", votes: 5)
question2_answer5 = question2.answers.new(text: "Very hard", votes: 4)

poll.save

# Build John Smith, who likes to make a lot of stupid polls.
john_smith = User.create(first_name: "John", last_name: "Smith", email: "johnsmith@gmail.com", password: "johnsmith")

12.times do |num|
  poll = john_smith.user_polls.new(title: "John Smith's Poll #{num+1}", description: "Take my poll!")
  question = poll.poll_questions.new(text: "Yes?")
  question_answer1 = question.answers.new(text: "Yes", votes: num)
  question_answer2 = question.answers.new(text: "No", votes: num*10)

  poll.save
end

# Build Jane Smith, who we will use to make friend requests to John
jane_smith = User.create(first_name: "Jane", last_name: "Smith", email: "janesmith@gmail.com", password: "janesmith")
poll = jane_smith.user_polls.new(title: "My very popular poll!", description: "Lot's of people like to take it!")
question = poll.poll_questions.new(text: "What's your favorite primary color?")
question.answers.new(text: "Red", votes: 10552)
question.answers.new(text: "Blue", votes: 10321)
question.answers.new(text: "Green", votes: 2324)

question = poll.poll_questions.new(text: "Are you having fun?")
question.answers.new(text: "Yes", votes: 16312)
question.answers.new(text: "No", votes: 11423)

poll.save

ActiveRecord::Base.transaction do
  200.times do |num|
    new_user = User.create(first_name: "Seed", last_name: "User#{num+1}", email: "seeduser#{num+1}@pollster.com", password: "pollster")

    vote = UserVote.create(user_id: new_user.id, user_poll_id: poll.id)
    vote.created_at -= num * num
    vote.save
  end
end

if ENV["loadtest_seed"]
  ActiveRecord::Base.transaction do
    2000.times do |num|
      new_user = User.create(first_name: "Seed", last_name: "User#{num+1}", email: "seeduser#{num+1}@pollster.com", password: "pollster")
      poll = new_user.user_polls.new(title: "Seed User#{num+1}'s Poll #{num+1}", description: "Take my poll!")
      question = poll.poll_questions.new(text: "Yes?")
      question_answer1 = question.answers.new(text: "Yes", votes: num)
      question_answer2 = question.answers.new(text: "No", votes: num*2)

      comment = poll.comments.new(commenter: "seeduser#{num+1}", body: "Commenting is so awesome!")

      poll.save
    end
  end
end

if ENV["vote_time_plot_seed"]
  poll_owner = User.create(first_name: "Poll", last_name: "Creator", email: "pollcreator@pollster.com", password: "pollcreator")
  poll = poll_owner.user_polls.new(title: "Timeplot Test", description: "")
  question = poll.poll_questions.new(text: "The question")
  answer1 = question.answers.new(text: "The first answer", votes: 100)
  answer2 = question.answers.new(text: "The second answer", votes: 100)

  poll.save

  ActiveRecord::Base.transaction do
    200.times do |num|
      new_user = User.create(first_name: "Seed", last_name: "User#{num+1}", email: "seeduser#{num+1}@pollster.com", password: "pollster")

      vote = UserVote.create(user_id: new_user.id, user_poll_id: poll.id)
      vote.created_at -= num * num
      vote.save
    end
  end
end
