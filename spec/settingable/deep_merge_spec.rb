# encoding: utf-8

RSpec.describe Settingable::DeepMerge do
  let(:destination) { { foo: { bar: "baz" }, hello: "world" } }
  let(:source) { { foo: { bar: "ham" } } }

  describe "#deep_merge" do
    subject { Settingable::DeepMerge.deep_merge(destination, source) }

    it "merges without modification" do
      expect(subject).to eq foo: { bar: "ham" }, hello: "world"
      expect(destination).to eq foo: { bar: "baz" }, hello: "world"
      expect(source).to eq foo: { bar: "ham" }
    end
  end

  describe "#deep_merge!" do
    subject { Settingable::DeepMerge.deep_merge!(destination, source) }

    it "merges with modification" do
      expect(subject).to eq foo: { bar: "ham" }, hello: "world"
      expect(destination).to eq foo: { bar: "ham" }, hello: "world"
      expect(source).to eq foo: { bar: "ham" }
    end

    it "yields" do
      expect do |y|
        Settingable::DeepMerge.deep_merge!(destination, source, &y)
      end.to yield_control
    end
  end
end
