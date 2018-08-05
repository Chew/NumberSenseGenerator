# NumberSense Test Generator Program
class NumberSense
  # The types of problems
  TYPES = {
    0 => '3-digit or 4-digit addition',
    1 => 'Reverse digit subtraction',
    2 => 'Multiplying by 11',
    3 => 'Remainder by 3, 9, 11',
    4 => 'Fraction => Percent/Decimal',
    5 => 'Decimal => Fraction/Percent',
    6 => 'Percent => Decimal/Fraction',
    7 => 'Squaring 13-34 (not mul. 5)',
    8 => 'Cubing 4-9',
    9 => 'Roman Numeral => Arabic'
  }.freeze

  # Initialize the program
  def initialize
    # Make the problems array
    @problems = []
    # Make the answers array
    @answers = []
    # Make the question types array
    @types = []
    # Notify the user we're generating
    puts 'Generating problems'
    # Run the generateproblems method
    generateproblems
    # Scott Rogowsky was here
    puts 'Lets get down to the nitty gritty here at cumero numero uno'
    # Do the ask dance
    askproblems
  end

  # Generate all the problems
  def generateproblems
    # First problem is unique
    # rand(0..1) picks a random problem from type 0 or 1
    # , 0) is the first problem
    types(rand(0..1), 0)
    (2..10).each do |i|
      types(rand(1..8), i)
    end
  end

  # Generate a problem based on type
  # @param typenum [Integer] what type of problem to generate.
  # @param arr [Integer] what spot in the array are we setting
  def types(typenum, arr)
    case typenum
    when 0
      # Generate random numbers
      num1 = rand(0..9999)
      num2 = rand(0..9999)
      # Decide + or -
      which = rand(0..1)
      case which
      when 0
        # Store problem and answer to array
        @problems[arr] = "#{num1} + #{num2}"
        @answers[arr] = num1 + num2
        typenum = typenum.to_s + 'a'
      when 1
        # Store problem and answer to array
        @problems[arr] = "#{num1} - #{num2}"
        @answers[arr] = num1 - num2
        typenum = typenum.to_s + 'b'
      end
    when 1
      num1 = rand(0..9999)
      num2 = num1.to_s.reverse.to_i
      # Store problem and answer to array
      @problems[arr] = "#{num1} - #{num2}"
      @answers[arr] = num1 - num2
    when 2
      num1 = rand(0..999)
      # Store problem and answer to array
      @problems[arr] = "#{num1} x 11"
      @answers[arr] = num1 * 11
    when 3
      # Generate random number
      num1 = rand(0..999)
      # Decide 3, 9, 11
      which = rand(0..2)
      case which
      when 0
        @problems[arr] = "#{num1} / 3"
        @answers[arr] = num1 / 3
      when 1
        @problems[arr] = "#{num1} / 9"
        @answers[arr] = num1 / 9
      when 2
        @problems[arr] = "#{num1} / 11"
        @answers[arr] = num1 / 11
      end
    when 4
      # Generate Fraction
    when 5
    when 6
    when 7
      # Start with a multiple to start the loop.
      num1 = 5
      # Generate a number between 13-34, no multiple of 5.
      num1 = rand(13..34) until num1 % 5 != 0
      @problems[arr] = "#{num1}^2"
      @answers[arr] = num1**2
    when 8
      num1 = rand(4..9)
      @problems[arr] = "#{num1}^3"
      @answers[arr] = num1**3
    end
    @types[arr] = typenum
  end

  def askproblems
    problem = 0
    correctprobs = 0
    incorrectprobs = 0
    @problems.length.times do |askme|
      puts "Problem #{problem + 1}: #{@problems[problem]}"
      print 'Answer > '
      answer = gets.chomp
      correct = @answers[askme]
      answer = if answer == ''
                 34_572_358_659_083_589_365_943_625_934_650_983_653_597_394_053
               else
                 answer.to_i
               end
      if answer == correct
        puts 'YOU GOT IT RIGHT!!! MONEY FLIPPING MATT RICHARDS IS HAPPY!'
        correctprobs += 1
      else
        puts "WRONG WRONG SO WRONG! Correct answer was #{correct}"
        incorrectprobs += 1
      end
      problem += 1
    end
    puts "Final count: #{correctprobs} / #{@problems.length}"
  end
end

NumberSense.new
