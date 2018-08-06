# Require external gems
require 'docx_replace'
require 'roman-numerals'

# NumberSense Test Generator Program
class NumberSense
  # The types of problems
  TYPES = {
    0 => '3-digit or 4-digit addition',
    1 => 'Reverse digit subtraction',
    2 => 'Multiplying by 11',
    3 => 'Remainder by 3, 9, 11',
    4 => 'Squaring 13-34 (not mul. 5)',
    5 => 'Cubing 4-9',
    6 => 'Roman Numeral => Arabic',
    7 => 'Arabic => Roman Numeral',
    8 => '11-99 x 25,50,75',
    9 => '2-3 digit numbers x 12-19',
    10 => '#10 problem, lotta + or -'
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
    # Let the user know the file is generating...
    puts 'The document file is generating...'
    # Do the file generate dance
    generatefile
  end

  # Generate all the problems
  def generateproblems
    # First problem is unique
    # rand(0..1) picks a random problem from type 0 or 1
    # , 0) is the first problem
    types(rand(0..1), 0)
    (1..8).each do |i|
      types(rand(1..9), i)
    end
    types(10, 9)
    (10..18).each do |i|
      types(rand(1..9), i)
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
        num2 = 3
      when 1
        num2 = 9
      when 2
        num2 = 11
      end
      @problems[arr] = "#{num1} / #{num2}"
      @answers[arr] = num1 / num2
    when 4
      # Start with a multiple to start the loop.
      num1 = 5
      # Generate a number between 13-34, no multiple of 5.
      num1 = rand(13..34) until num1 % 5 != 0
      @problems[arr] = "#{num1}^2"
      @answers[arr] = num1**2
    when 5
      num1 = rand(4..9)
      @problems[arr] = "#{num1}^3"
      @answers[arr] = num1**3
    when 6
      @answers[arr] = rand(0..3000)
      @problems[arr] = RomanNumerals.to_roman(@answers[arr])
    when 7
      @problems[arr] = rand(0..3000)
      @answers[arr] = RomanNumerals.to_roman(@problems[arr])
    when 8
      num1 = rand(11..99)
      num2 = rand(1..3) * 25
      @problems[arr] = "#{num1} x #{num2}"
      @answers[arr] = num1 * num2
    when 9
      num1 = rand(10..999)
      num2 = rand(12..19)
      @problems[arr] = "#{num1} x #{num2}"
      @answers[arr] = num1 * num2
    when 10
      num1 = rand(1..9999)
      num2 = rand(1..9999)
      num3 = rand(1..9999)
      sign1 = ['+', '-'].sample
      sign2 = ['+', '-'].sample
      @problems[arr] = "#{num1} #{sign1} #{num2} #{sign2} #{num3}"
      ans1 = if sign1 == '+'
               num1 + num2
             else
               num1 - num2
             end
      answer = if sign2 == '+'
                 ans1 + num3
               else
                 ans1 - num3
               end
      @answers[arr] = fivepercent(answer)
    end
    @types[arr] = typenum
  end

  def fivepercent(correct)
    "#{(correct * 0.95).round(0)} -- #{(correct * 1.05).round(0)}"
  end

  def generatefile
    loc = `gem env`.split("\n")
    dir = loc[3].split(': ')[1] + "/gems/numbersense-0.1.0/template.docx"
    # Initialize DocxReplace with your template
    doc = DocxReplace::Doc.new(dir)
    ansdoc = DocxReplace::Doc.new(dir)

    @problems.length.times do |problem|
      doc.replace("{problem.#{problem + 1}}", @problems[problem])
    end
    @answers.length.times do |problem|
      ansdoc.replace("{problem.#{problem + 1}}", @answers[problem])
    end
    id = Time.now.to_i
    name = "problems_#{id}.docx"
    answername = "answers_#{id}.docx"
    `cp #{dir} #{name}`
    `cp #{dir} #{answername}`
    doc.commit(name)
    ansdoc.commit(answername)
    puts 'Problems saved as: ' + name
    puts 'Answers saved as: ' + answername
  end
end
