require 'nokogiri'
require 'net/http'
require 'uri'
require 'csv'

aleph_xservices_reserves_course_url = "http://alephprod.library.nd.edu:8991/X?op=find&code=CNO&request=###course_id###&base=NDU30"
aleph_xservices_reserves_item_url = "http://alephprod.library.nd.edu:8991/X?op=present&set_entry=###item_number###&set_number=###set_id###&base=NDU30"

CSV.open('/Users/rfox2/Development/api/aleph_data/z108_data.csv', {:quote_char => "}", :col_sep => "\t", :row_sep => "\n"}).each do |course_record|
  course_identifier = fix_formatting_errors(course_record[0])
  course_xservices_url = aleph_xservices_reserves_course_url.sub('###course_id###', course_identifier)
  uri = URI.parse(course_xservices_url)
  response = Net::HTTP.get_response(uri)
  puts course_identifier
  course_data_xml = Nokogiri::XML(response.body)
  number_of_entries = course_data_xml.xpath("//no_entries").first

  set_number = course_data_xml.xpath("//set_number").first

  unless number_of_entries.nil?
    puts number_of_entries.content
    for item_number in 1 .. number_of_entries.content.to_i
      aleph_item_url = aleph_xservices_reserves_item_url.sub('###set_id###', set_number)
      aleph_item_url = aleph_item_url.sub('###item_number###', item_number.to_s)
      item_uri = URI.parse(aleph_item_url)
      item_response = Net::HTTP.get_response(item_uri)
      item_data_xml = Nokogiri::XML(item_response.body)
      oai_marc = item_data_xml.xpath("//present/record/metadata/oai_marc").first
      sid_id = item_data_xml.xpath("//present/record/metadata/oai_marc/varfield[@id=\'SID\']/subfield[@label=\'a\']").first
      puts "SID: " + sid_id.content
      puts "BIB ID: " + /NDU\d+-(?<bib_id>\d+)-/.match(sid_id.content)[:bib_id]
      puts "Title: " + get_title(item_data_xml)
      doc_id = item_data_xml.xpath("//present/record/doc_number").first
      puts "DOC NUMBER: " + doc_id.content
      # puts "MARC: " + oai_marc.to_xml
    end
  end

end

BEGIN {
  def fix_formatting_errors(course_record_id)
    course_record_id.gsub!(/\s/, '-')
    course_record_id.gsub!(/\s/, '')
    course_record_id
  end

  def get_title(item_data_xml)
    title_a_node = item_data_xml.xpath("//present/record/metadata/oai_marc/varfield[@id=\'245\']/subfield[@label=\'a\']").first
    title = ''
    unless title_a_node.nil?
      title = title_a_node.content
    end
    title_b_node = item_data_xml.xpath("//present/record/metadata/oai_marc/varfield[@id=\'245\']/subfield[@label=\'b\']").first
    unless title_b_node.nil?
      title = title + title_b_node.content
    end
    title.gsub!(/\/$/, '')
    title.gsub!(/\.$/, '')
    title
  end
}

