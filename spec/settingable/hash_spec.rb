# encoding: utf-8

RSpec.describe Settingable::Hash do
  let(:body) { { foo: { bar: "baz" }, hello: "world" } }
  subject { Settingable::Hash.new(body) }

  describe "#initialize" do
    it "converts hash values" do
      expect(subject[:foo]).to be_a Settingable::Hash
    end
  end

  describe "#[]" do
    it "raises on an invalid key" do
      expect { subject[:bar] }.to raise_error(KeyError)
    end

    it "allows access by other objects" do
      expect(subject[:hello]).to eq "world"
      expect(subject["hello"]).to eq "world"
    end
  end

  describe "#to_h" do
    it "gives a regular hash" do
      expect(subject.to_h).to be_a ::Hash
    end

    it "has regular hash values" do
      expect(subject.to_h[:foo]).to be_a ::Hash
    end
  end

  describe "#[]=" do
    it "converts hash values" do
      subject[:hello] = { foo: { bar: "baz" } }
      expect(subject[:hello]).to be_a(Settingable::Hash)
      expect(subject[:hello][:foo]).to be_a(Settingable::Hash)
    end

    it "sets the symbol" do
      subject["bar"] = "baz"
      expect(subject[:bar]).to eq "baz"
    end
  end

  describe "#key?" do
    it "returns true for other objects" do
      expect(subject.key?(:hello)).to be true
      expect(subject.key?("hello")).to be true
    end
  end

  describe "#fetch" do
    let(:fake) { double("fake") }
    it "returns the double on a bad key" do
      expect(subject.fetch(:bar, fake)).to be fake
    end

    it "yields on a bad key" do
      expect { |y| subject.fetch(:bar, &y) }.to yield_control
    end

    it "yields first on a bad key" do
      expect { |y| subject.fetch(:bar, :baz, &y) }.to yield_control
    end

    it "raises on a bad key with no default" do
      expect { subject.fetch(:bar) }.to raise_error(KeyError)
    end
  end
end
