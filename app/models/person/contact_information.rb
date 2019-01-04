class Person::ContactInformation

  attr_accessor :email, :campus_address, :phone, :office_address

  def initialize(args = {})
    campus_address(args)
    email(args)
    phone(args)
  end

  def campus_address(args = {})
    if (args[:ldap_person])
      @campus_address = args[:ldap_person].postaladdress.first.gsub(/\$/, '&#10;') if args[:ldap_person].respond_to?(:postaladdress)
      @campus_address = args[:ldap_person].ndofficeaddress.first.gsub(/\$/, '&#10;') if args[:ldap_person].respond_to?(:ndofficeaddress)
    end
    unless (args[:directory_person].nil?)
      @campus_address = args[:directory_person][0]["address"]
    end
  end

  def email(args = {})
    if (args[:ldap_person])
      @email = args[:ldap_person].mail.first if args[:ldap_person].respond_to?(:mail)
    end
    unless (args[:directory_person].nil?)
      @email = args[:directory_person][0]["email"]
    end
  end

  def phone(args = {})
    if (args[:ldap_person])
      @phone = args[:ldap_person].telephonenumber.first if args[:ldap_person].respond_to?(:telephonenumber)
    end
    unless (args[:directory_person].nil?)
      @phone = args[:directory_person][0]["phone"]
    end
  end

end
