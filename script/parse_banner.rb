require 'csv'

courses = Hash.new()
CSV.open('/Users/rfox2/Development/api/tmp/sample_banner_data/enrollment.tsv', :col_sep => "\t", :row_sep => "\n").each do |fields|
  (term_prefix, alpha_prefix, course_num, section) = fields[0..3] 
  if fields[7] == 'Student'
    crn = fields[9]
  else
    crn = fields[8]
  end
  courses[term_prefix + ' ' + alpha_prefix + ' ' + course_num + ' ' + section + ' ' + crn] = 1 
end

courses.keys.each do |course|
  puts course
end
