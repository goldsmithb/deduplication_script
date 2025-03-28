require 'spec_helper'

RSpec.describe SomeNamespace::AnotherExampleClass do
  let(:instance) { described_class.new }

  describe ".example_instance_method" do
    it "prints the expected text to stdout" do
      expect { SomeNamespace::AnotherExampleClass.example_instance_method }.to output("Hello!\n").to_stdout
    end
  end
end
