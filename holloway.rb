require "rspec"

require_relative "account"

describe Account do
  let(:acct_number)     { "2342352523" }
  let(:initial_balance) { 5000 }
  let(:account)         { Account.new(acct_number, initial_balance) }

  describe "#initialize" do
    context "valid input" do
      it "raise an error when no argument is provided" do
        expect { Account.new }.to raise_error
      end
      it "accepts account number without initial balance" do
        expect { Account.new("1234567890") }.not_to raise_error
      end
      it "accepts both account number and initial balance as argument" do
        expect { Account.new("1234567890", 5000) }.not_to raise_error
      end
      it "raise an error when invalid account number (more than 10) is provided" do
        expect { Account.new("12345678901") }.to raise_error(InvalidAccountNumberError)
      end
      it "raise an error when invalid account number (less than 10) is provided" do
        expect { Account.new("123456789") }.to raise_error(InvalidAccountNumberError)
      end
    end
  end

  describe "#transactions" do
    context "returns transactions array" do
      it "returns array with initial balance" do
        expect(account.transactions).to eq([5000])
      end
    end
  end

  describe "#balance" do
    context "returns balance" do
      it "returns the current balance value" do
        expect(account.balance).to eq(5000)
      end
    end
  end

  describe "#account_number" do
    it "should return sliced acc number" do
      expect(account.acct_number).to eq "******2523"
    end
 
    it "should not return full acc number" do
      expect(account.acct_number ).not_to eq "2342352523"
    end
  end

  describe "deposit!" do
    context "valid input" do
      it "raise an NegativeDepositError if amount is negative" do
        expect{ account.deposit!(-5000) }.to raise_error(NegativeDepositError)
      end

      it "raise error when string is provided as argument" do
        expect{ account.deposit!("5000") }.to raise_error
      end

      it "raise error when invalid argument is provided" do
        expect{ account.deposit!() }.to raise_error(ArgumentError)
      end

      it "accepts positive amount argument" do
        expect{ account.deposit!(5000) }.not_to raise_error
      end
    end

    context "operation process" do
      it "adds the amoung into transactions array" do
        account.deposit!(5000)
        expect(account.transactions).to eq([5000, 5000])
      end
    end

    context "valid output" do
      it "returns balance account" do
        expect(account.deposit!(5000)).to eq(10000)
      end
      it "increases the balance amount" do
        account.deposit!(5000)
        expect(account.balance).to eq(10000)
      end
    end
  end

  describe "#withdraw!" do
    context "valid input" do
      it "raise error when string is provided as argument" do
        expect{ account.withdraw!("5000") }.to raise_error
      end

      it "raise error when invalid argument is provided" do
        expect{ account.withdraw!() }.to raise_error(ArgumentError)
      end

      it "accepts positive amount argument" do
        expect{ account.withdraw!(5000) }.not_to raise_error
      end

      it "accepts negative amount argument" do
        expect{ account.withdraw!(-5000) }.not_to raise_error
      end
    end

    context "operation process" do
      it "adds the amount into transactions array using negative amount" do
        account.withdraw!(-1000)
        expect(account.transactions).to eq([5000, -1000])
      end

      it "adds the amount into transactions array using positive amount" do
        account.withdraw!(1000)
        expect(account.transactions).to eq([5000, -1000])
      end
    end

    context "valid output" do
      it "returns balance account" do
        expect(account.withdraw!(1000)).to eq(4000)
      end

      it "decreases the balance amount" do
        account.withdraw!(1000)
        expect(account.balance).to eq(4000)
      end

    end
  end
end