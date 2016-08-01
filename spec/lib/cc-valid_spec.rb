require "../spec_helper"
require "../../lib/cc-valid"

describe CreditCard do

  # Good lets - types and numbers
  let(:cc_nums_visa) { [4929002337726224,
                        4556917678875258,
                        4539532967126123,
                        4485301013786965,
                        4916026237203351] }

  let(:cc_nums_mastercard) { [5437136111397364,
                              5517120807061248,
                              5196041970229503,
                              5555552518950561,
                              5438724511345304] }

  let(:cc_nums_discover) { [6011920176257494,
                            6011424609636028,
                            6011995553193785,
                            6011856509113626,
                            6011030714993160] }

  let(:cc_nums_amex) { [347312694905705,
                        379155109162722,
                        340204115832575,
                        342602615588399,
                        374977498465423] }

  # Test valid types
  context "card is able to accept if" do
    it "is VISA" do
      cc_nums_visa.each do |cc_num|
        expect(CreditCard.card_type(cc_num)).to eq 'Visa'
      end
    end

    it "is MasterCard" do
      cc_nums_mastercard.each do |cc_num|
        expect(CreditCard.card_type(cc_num)).to eq 'MasterCard'
      end
    end

    it "is Discover" do
      cc_nums_discover.each do |cc_num|
        expect(CreditCard.card_type(cc_num)).to eq 'Discover'
      end
    end

    it "is AMEX" do
      cc_nums_amex.each do |cc_num|
        expect(CreditCard.card_type(cc_num)).to eq 'AMEX'
      end
    end

  end

  # Accepted types validation
  context "when accepted card is valid" do

    let(:accepted_types) { cc_nums_visa |
                           cc_nums_mastercard |
                           cc_nums_discover |
                           cc_nums_amex }

    it "is truthey" do
      accepted_types.each do |cc_num|
        expect(CreditCard.valid?(cc_num)).to be_truthy
      end
    end

  end

  # Invalid cards
  context "when card number is invalid" do

    let(:bad_card_numbers) { [3832663221831, 601111111111117,
                              123547812341234, 1234567890123456,
                              32222222222000, 1111111111111111,
                              00010000, 4608443133434] }

    it "is falsey" do
      bad_card_numbers.each do |cc_num|
        expect(CreditCard.valid?(cc_num)).to be_falsey
      end
    end

  end

  # One digit mistake case
  context "when card holder mistaken a bit" do

    let(:accepted_types_bad_numbers) { [5517120806061248,
                                        6011995552193785,
                                        342602615578399,
                                        4914026237203351] }

    it "is truthy - issuing network" do
      accepted_types_bad_numbers do |cc_num|
        expect(CreditCard.valid?(cc_num)).to be_truthy
      end
    end

    it "is falsey by number" do
      accepted_types_bad_numbers do |cc_num|
        expect(CreditCard.valid?(cc_num)).to be_falsey
      end
    end

  end

  # Wront input - zero, negative, string
  context "when input is zero, negative or a string" do
    zero = 0
    neg = -4435556654534
    str = "Inpr3r34r9934534"

    it "is falsey" do
      expect(CreditCard.valid?(zero)).to be_falsey
      expect(CreditCard.valid?(neg)).to be_falsey
      expect(CreditCard.valid?(str)).to be_falsey
    end

  end

  # Unknow type test
  context "when card type is not of issuing network" do

    let(:unknown_network_numbers) { [1237120806061248,
                                     5011995552193785,
                                     322602615578399,
                                     421402623720335134343] }

    it "is unknown" do
      unknown_network_numbers do |cc_num|
        expect(CreditCard.card_type(cc_num)).to eq 'Unknown'
      end
    end

  end
end
