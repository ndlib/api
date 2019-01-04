class Org::OrgContactInformation

  attr_accessor :email, :campus_address, :phone, :office_address

  def initialize(args = {})
    campus_address(args)
    email(args)
    phone(args)
  end

  def campus_address(args = {})
    unless (args[:directory_org].nil?)
      @campus_address = args[:directory_org]["address"]
    end
  end

  def email(args = {})
    unless (args[:directory_org].nil?)
      @email = args[:directory_org]["email"]
    end
  end

  def phone(args = {})
    unless (args[:directory_org].nil?)
      @phone = args[:directory_org]["phone"]
    end
  end

end
