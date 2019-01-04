require 'spec_helper'

describe Resources::AlephController, :type => :controller do
  before(:each) do
    allow(subject).to receive(:authenticate_api!).and_return(true)
  end

  describe '#deaccession_item' do
    let(:aleph_item) { instance_double(Aleph::Item) }
    let(:action) { post :deaccession_item, barcode: '1234' }

    before(:each) do
      allow(Aleph::Item).to receive(:new).and_return(aleph_item)
    end

    it 'uses Aleph::Item.update_process_status to update the status code' do
      allow(aleph_item).to receive(:exists?).and_return(true)
      expect(aleph_item).to receive(:update_process_status).with("AR").and_return({})
      action
    end

    it 'renders a 404 if the item does not exist in datamart' do
      allow(aleph_item).to receive(:exists?).and_return(false)
      action
      expect(response.status).to eq(404)
    end

    it 'renders a 422 if the call to the Aleph API fails' do
      allow(aleph_item).to receive(:exists?).and_return(true)
      allow(aleph_item).to receive(:update_process_status).and_return({ status: "error" })
      action
      expect(response.status).to eq(422)
    end

    it 'renders a 200 if the item was successfully changed' do
      allow(aleph_item).to receive(:exists?).and_return(true)
      allow(aleph_item).to receive(:update_process_status).and_return({ status: "ok" })
      action
      expect(response.status).to eq(200)
    end
  end
end
