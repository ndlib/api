class Resources::CourseController < ApiController

  public

  def course
    query_type, course_criteria = parse_args(params)
    course = Resource::Course::Course.course(query_type, course_criteria)
    if course.blank?
      render_404
    else
      respond_to do |format|
        format.xml { render :xml => course.to_xml(:root => 'api', :skip_types => true, :skip_instruct => true) }
        format.json { render :json => course.to_json }
      end
    end
  end


  def course_search
    courses = Resource::Course::Course.course_section_search(params[:q], params[:term])
    respond_to do |format|
      format.xml { render :xml => courses.to_xml(:root => 'api', :skip_types => true, :skip_instruct => true) }
      format.json { render :json => courses.to_json }
    end
  end


  private

  def parse_args(params)
    request.fullpath =~ /courses\/(.+?)\//
    query_type = $1
    case query_type
    when 'by_course_id'
      course_criteria = "#{params[:term]}_#{params[:alpha]}_#{params[:number]}"
    when 'by_course_triple'
      course_criteria = "#{params[:course_triple]}"
    when 'by_section'
      course_criteria = "#{params[:term]}_#{params[:crn]}"
    when 'by_section_group'
      course_criteria = "#{params[:section_group_id]}"
    when 'by_supersection'
      course_criteria = "#{params[:supersection_id]}"
    when 'by_crosslist'
      course_criteria = "#{params[:crosslist_id]}"
    end
    [query_type, course_criteria]
  end


  def prep_person(p)
    p.build_person
    JSON.parse(p.to_json)
  end


  def person_build(id)
    p = Person::Base.new('by_netid', id)
    @p = prep_person(p)
  end

end
