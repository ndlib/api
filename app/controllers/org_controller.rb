class OrgController < ApiController

  public

  def org
    o = Org::Organization.new(params[:population_context], id)
    o = prep_org(o)

    respond_to do |format|
      format.xml { render :xml => orgs_hash(Array.new.push(o)).to_xml }
      format.json { render :json => orgs_hash(Array.new.push(o)).to_json }
    end
  end

  def all_by_population_context

    org_list = Org::Organization.all_orgs_by_context(params[:population_context])

    respond_to do |format|
      format.xml { render :xml => orgs_hash(org_list).to_xml }
      format.json { render :json => orgs_hash(org_list).to_json }
    end
  end

  private

  def id
    unless params.has_key?(:id)
      'all'
    end
    params[:id]
  end

  def prep_org(o)
    o.build_org
    JSON.parse(o.to_json)
  end

  def orgs_hash(a)
    ha = Hash.new
    ha['orgs'] = a
    ha
  end

end
