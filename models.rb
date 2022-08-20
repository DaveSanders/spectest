class Telephone
  attr_accessor :dialtone

  def initialize(bill_paid)
    @dialtone = bill_paid
  end

  def make_a_call(number)
    unless @dialtone
      puts 'Pay your bill!'
      return :pay_your_bill
    end

    puts "Calling #{number}"
    number.each_char do |n|
      Finger.dial(n)
    end

    (1..3).each do
      puts "Ring..."
      sleep 2
    end

    return :connected
  end

end

class Finger
  def self.dial(number)
    puts "#{number}...whirrrr"
    # Its a rotary phone, it takes a second
    sleep 1
  end
end