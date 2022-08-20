require './spec/spec_helper.rb'
require './models.rb'

RSpec.describe "How does RSpec Work?" do

  describe "Make sure the phone works first" do

    it 'lets me make a call without a mock' do
      telephone = Telephone.new(true)
      result = telephone.make_a_call('5551212')
      expect(result).to eq :connected
    end

    it 'wont connect if you dont pay the bill' do
      telephone = Telephone.new(false)
      result = telephone.make_a_call('5551212')
      expect(result).to eq :pay_your_bill
    end
  end

  describe "Test out Stubs, no Crockett" do

    #==> This test will fail
    it 'wont stub a method that doesnt exist on the object' do
      telephone = Telephone.new(false)
      # This line fails on purpose
      allow(telephone).to receive(:emergency_call).and_return(:nine_one_one)

      result = telephone.make_a_call('5551212')
      expect(result).to eq :pay_your_bill

      result = telephone.emergency_call
      expect(result).to eq :nine_one_one
    end

    #==> This one works however
    it 'can stub a method that it DOES have' do
      telephone = Telephone.new(false)
      allow(telephone).to receive(:make_a_call).and_return(:hack_the_system)

      result = telephone.make_a_call('5551212')
      expect(result).to_not eq :pay_your_bill
      expect(result).to eq :hack_the_system
    end

    #==> Testing again to make sure it works by paying the bill
    # This test should not wait or act like its dialing the phone
    it 'can stub a method that it DOES have' do
      telephone = Telephone.new(true)
      allow(telephone).to receive(:make_a_call).and_return(:the_phone_is_broken)

      result = telephone.make_a_call('5551212')
      expect(result).to_not eq :connected
      expect(result).to eq :the_phone_is_broken
    end

  end

  describe "If you Mock me up. If you Mock me up I'll never stop" do
    #==> This does NOT work. Finger gets dialed, but this double has nothing to do with
    #==> The real Finger.dial method. Finger means nothing here.
    it 'should know if Finger.dial gets called' do
      finger = double(Finger)
      expect(finger).to receive(:dial)
      telephone = Telephone.new(true)
      result = telephone.make_a_call('5551212')
      expect(result).to eq :connected
    end

    #==> This looks to be the way
    it 'should know if Finger.dial gets called' do
      allow(Finger).to receive(:dial) { puts "fake dialing" }
      expect(Finger).to receive(:dial)
      telephone = Telephone.new(true)
      result = telephone.make_a_call('5551212')
      expect(result).to eq :connected
    end

    #==> You can alter what expect returns too, but it only gets called once
    it 'should know if Finger.dial gets called' do
      allow(Finger).to receive(:dial)
      expect(Finger).to receive(:dial) { puts "fake dialing" }
      telephone = Telephone.new(true)
      result = telephone.make_a_call('5551212')
      expect(result).to eq :connected
    end

    #==> But, what if we dont allow?
    # Expect by itself gets hit for every time Finger.dial gets called
    # Note the exactly(7).times
    it 'should know if Finger.dial gets called' do
      expect(Finger).to receive(:dial).exactly(7).times { puts "fake dialing" }
      telephone = Telephone.new(true)
      result = telephone.make_a_call('5551212')
      expect(result).to eq :connected
    end
  end

  describe "Spies Like Us" do

    #==> I don't really understand the significance of spies.
    # Thoughtbought says they are just sugar:
    # https://thoughtbot.com/blog/a-closer-look-at-test-spies#spies-without-duplication
    # I guess its just a way to express a double without specifying any of the methods on it
    # but I can't get it to work?
    it 'should know if Finger.dial gets called' do
      finger = spy("Finger")
      expect(finger).to receive(:dial).exactly(7).times
      telephone = Telephone.new(true)
      result = telephone.make_a_call('5551212')
      expect(result).to eq :connected
    end
  end


end