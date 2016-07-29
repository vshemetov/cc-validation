
class CreditCard

  # CC type
  def self.card_type card_number

    sequence = card_number.to_s
    num_length = sequence.size
    if num_length == 15 && sequence =~ /^(34|37)/
      "AMEX"
    elsif num_length == 16 && sequence =~ /^6011/
      "Discover"
    elsif num_length == 16 && sequence =~ /^5[1-5]/
      "MasterCard"
    elsif (num_length == 13 || num_length == 16) && sequence =~ /^4/
      "Visa"
    else
      "Unknown"
    end

  end

  # Luhn validation
  def self.valid? card_number
    sum = 0
    d = 0

    sequence = card_number.to_s
    if sequence.size.even?
      s = 0
    else
      s = 1
      sum += sequence[0].to_i
    end

    (s..sequence.size - 1).step(2) {|i|
      sum += sequence[i + 1].to_i
      d = sequence[i].to_i * 2
      d -= 9 if d > 9
      sum += d
    }

    sum % 10 == 0
  end

end

#[4992739871643, 4432730022160370, 1234567812345670, 5321300240023940].each {|num|
#  puts CreditCard.card_type(num) + " " + num.to_s + " is " + (CreditCard.valid?(num) ? "valid": "invalid")
#}

num = ARGV[0]
puts CreditCard.card_type(num) + " " + num.to_s + " is " + (CreditCard.valid?(num) ? "valid": "invalid")
