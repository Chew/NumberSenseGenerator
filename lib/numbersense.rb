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
    7 => 'Arabic => Roman Numeral'
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
      types(rand(1..7), i)
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
      @answers[arr] = RomanNumerals.to_decimal(@problems[arr])
    end
    @types[arr] = typenum
  end

  def generatefile
    # Initialize DocxReplace with your template
    doc = DocxReplace::Doc.new('template.docx')
    ansdoc = DocxReplace::Doc.new('template.docx')

    @problems.length.times do |problem|
      doc.replace("{problem.#{problem + 1}}", @problems[problem])
    end
    @answers.length.times do |problem|
      ansdoc.replace("{problem.#{problem + 1}}", @answers[problem])
    end
    id = Time.now.to_i
    name = "problems_#{id}.docx"
    answername = "answers_#{id}.docx"
    `cp template.docx #{name}`
    `cp template.docx #{answername}`
    doc.commit(name)
    ansdoc.commit(answername)
    puts 'Problems saved as: ' + name
    puts 'Answers saved as: ' + answername
  end
end
