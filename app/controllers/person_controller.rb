class PersonController < ApiController

  before_filter :person_build, :only => [:person, :courses]

  public

  def person
    respond_to do |format|
      format.xml { render :xml => people_hash(Array.new.push(@p)).to_xml(:root => 'api', :skip_types => true, :skip_instruct => true) }
      format.json { render :json => people_hash(Array.new.push(@p)).to_json }
    end
  end

  def courses
    c = Resource::Course::Course.enrolled_courses(params[:term], @p["netid"])
    i = Resource::Course::Course.instructed_courses(params[:term], @p["netid"])
    @p["enrolled_courses"] = c
    @p["instructed_courses"] = i
    respond_to do |format|
      format.xml { render :xml => people_hash(Array.new.push(@p)).to_xml(:root => 'api', :skip_types => true, :skip_instruct => true) }
      format.json { render :json => people_hash(Array.new.push(@p)).to_json }
    end
  end


  def all_by_population_context
    people_list = Person::Base.all_people_by_context(params[:population_context])

    respond_to do |format|
      format.xml { render :xml => people_hash(people_list).to_xml(:root => 'api', :skip_types => true, :skip_instruct => true) }
      format.json { render :json => people_hash(people_list).to_json }
    end
  end

  def search
    p = Person::Base.new('by_netid', params[:value])
    @people = p.person_search
    respond_to do |format|
      format.xml { render :xml => people_hash(@people).to_xml(:root => 'api', :skip_types => true, :skip_instruct => true) }
      format.json { render :json => people_hash(@people).to_json }
    end
  end

  private

  def id
    unless params.has_key?(:id)
      'all'
    end
    params[:id]
  end


  def prep_person(p)
    p.build_person
    JSON.parse(p.to_json)
  end


  def people_hash(a)
    ha = Hash.new
    ha['people'] = a
    ha
  end


  def person_build
    p = Person::Base.new(params[:identifier], id)
    @p = prep_person(p)
  end

end
