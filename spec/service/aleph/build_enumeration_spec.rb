require "spec_helper"

describe Aleph::BuildEnumeration do
  describe "#parse" do
    # rubocop:disable Lint/Eval
    let(:item_request) { eval(File.open(Rails.root.join("spec", "fixtures", "aleph_data", "item_record.rb")).read).to_ostruct }

    it "parses the correct enum string" do
      expect(described_class.call(item_request.item_serv.item)).to eq "3 22 1978"
    end
  end
end
