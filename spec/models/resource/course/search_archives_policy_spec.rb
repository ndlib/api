require 'spec_helper'

describe Resource::Course::SearchArchivesPolicy do

  [1, 2, 3, 4, 5].each do | month |
    it "determines the current terms for month number: #{month}" do
      expect(Time).to receive(:now).at_least(:once).and_return(double(month: month, year: 2015))
      expect(subject.current_terms).to eq(["201500", "201420"])
    end
  end

  [6, 7, 8].each do | month |
    it "determines the current terms for month number: #{month}" do
      expect(Time).to receive(:now).at_least(:once).and_return(double(month: month, year: 2014))
      expect(subject.current_terms).to eq(["201410", "201400"])
    end
  end


  [9, 10, 11, 12].each do | month |
    it "determines the current terms for month number: #{month}" do
      expect(Time).to receive(:now).at_least(:once).and_return(double(month: month, year: 2014))
      expect(subject.current_terms).to eq(["201420", "201410"])
    end
  end


  it "returns false when the search term is in the current terms" do
    expect(subject).to receive(:current_terms).and_return(['term'])
    expect(subject.search_archive?('term')).to be_falsey
  end


  it "returns true when the search term is in the current terms" do
    expect(subject).to receive(:current_terms).and_return(['term'])
    expect(subject.search_archive?('oldterm')).to be_truthy
  end

end
