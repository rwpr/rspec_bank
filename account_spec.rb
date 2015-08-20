require "rspec"

require_relative "account"

describe Account do

  let(:acc_num) { "0123456789" }
  let(:transaction) { 5000 }
  let(:test_account) { Account.new(acc_num, 5000) }


  describe "#initialize" do
    #context is like case
    context "with valid input" do 
      it "must have valid account number" do
        expect { Account.new("asdfsafasdf") }.to raise_error(InvalidAccountNumberError)
        expect { Account.new("0123456789", 5000)}.not_to raise_error
        expect { Account.new("")}.to raise_error(InvalidAccountNumberError)
        expect { Account.new("012345678")}.to raise_error(InvalidAccountNumberError)
        expect { Account.new("01234567890")}.to raise_error(InvalidAccountNumberError)
      end
    end
  end

  describe "#transactions" do
    context "must be an array" do
      it "returns transaction in array" do
        expect(transaction).to eq(5000)
      end

      it "must be in order of entry" do
        test_account.deposit!(2000)
        test_account.withdraw!(500)
        test_account.deposit!(2000)
        expect(test_account.transactions).to eq([5000, 2000, -500, 2000])
      end
    end
  end

  describe "#balance" do
    context "with valid result" do
      it "returns output" do
        test_account.deposit!(2000)
        test_account.withdraw!(500)
        test_account.deposit!(2000)
        expect(test_account.balance).to eq(8500)
      end
    end
  end

  describe "#account_number" do
    it "should output sliced acc number" do
      expect(test_account.acct_number).to eq "******6789"
    end

    it "should not return full acc number" do
      expect(test_account.acct_number).not_to eq"0123456789"
    end
  end

  describe "deposit!" do
    context "should update transactions" do
      it "should increase/decrease based on additional/loss of incoming transaction" do
        expect{test_account.deposit!(100)}.to change{test_account.balance}.by 100
      end

      it "should not decrease balance" do
        expect{test_account.deposit!(-10)}.to raise_error(NegativeDepositError)
      end  
    end

    context "valid input" do
      it "raise error when invalid argument is provided" do
        expect{test_account.deposit!()}.to raise_error(ArgumentError)
      end

      it "accepts positive amount" do
        expect{test_account.deposit!(100)}.not_to raise_error
      end
    end
  end

  describe "#withdraw!" do
    context "should decrease balance by amount withdrawn" do
      it "should not decrease balance by amount withdrawn" do
        expect{test_account.withdraw!(10)}.to change{test_account.balance}.by -10
      end
    end

    context "valid input" do
      it "raise error when input is a string" do
        expect{test_account.withdraw!("10")}.to raise_error(ArgumentError)
      end
    end

    context "should disallow withdrawals more than balance" do
      it "disallow withdrawals more than balance" do
        expect{(test_account.withdraw!(100000))}.to raise_error(OverdraftError)
      end
    end
  end
end