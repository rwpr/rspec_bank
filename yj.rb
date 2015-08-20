require "rspec"

require_relative "account"



describe Account do

  let(:acc_num) { "0123456789" }
  let(:transaction) { [1,2,3] }
  let(:test_account) { Account.new(acc_num) }

  describe "#initialize" do
    context "with valid input" do
      it "must have valid account number" do
        expect { Account.new("abcdefghij") }.to raise_error(InvalidAccountNumberError)
        expect { Account.new("") }.to raise_error(InvalidAccountNumberError)
        expect { Account.new("012345678") }.to raise_error(InvalidAccountNumberError)
        expect { Account.new("01234567890") }.to raise_error(InvalidAccountNumberError)
        expect(test_account).to be_kind_of(Account)
      end
    end
  end

  describe "#transactions" do
    context "must be an array" do
      it "must be in the form of an array" do
        account = test_account
        expect(account.transactions).to be_kind_of(Array)
      end

      it "must be in order of entry" do
        account = test_account
        account.deposit!(6)
        account.withdraw!(2)
        account.deposit!(8)
        expect(test_account.transactions).to eq [0, 6, -2, 8]
      end
    end
  end

  describe "#balance" do
    context "with valid result" do
      it "returns sum of array" do
        account = test_account
        account.deposit!(6)
        account.withdraw!(-2)
        account.deposit!(8)
        expect(account.balance).to eq 12
      end
    end
  end

  describe "#account_number" do
    it "should return sliced acc number" do
      expect(test_account.acct_number).to eq "******6789"
    end

    it "should not return full acc number" do
      expect(test_account.acct_number ).not_to eq "0123456789"
    end
  end

  describe "deposit!" do
    it "should update transactions" do
      expect{test_account.deposit!(10)}.to change{test_account.balance}.by 10
    end

    it "should not decrease balance" do
      expect{test_account.deposit!(-10)}.to raise_error(NegativeDepositError)
    end
  end

  describe "#withdraw!" do
    it "should decrease balance by amount withdrawn" do
      test_account.deposit!(10)
      expect{test_account.withdraw!(10)}.to change{test_account.balance}.by -10
    end

    context "disallow invalid withdrawal" do
      it "should disallow withdrawals more than balance" do
        expect{test_account.withdraw!(10)}.to raise_error(OverdraftError)
      end

    end
  end
end