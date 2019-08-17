class Home
	attr_accessor :family

	def initialize
		@family =[]
	end

	def find_parents(person)
	  parents=[]
	  if person.parents.length == 2 && patner_exists?(person)
	    patner = find_patner(person)
	    parents = [person, patner]
	  elsif person.parents.length == 1
	    parents = [person.parents.first, person]
 	  end
 	  parents
  end

  def patner_exists?(person)
    if find_patner(person) == nil
      return false
    else
      return true
    end
  end

  def find_patner(person)
    self.family.find{ |member| !member.parents.empty? && member.parents.all? { |x| x == person } }
  end


	def find_son(person)
		sons= []
		self.family.each do |member|
			sons << member if ( member.parents.length > 1 && member.gender == 'Male' && member.parents.include?(person))
		end
		sons
	end

	def find_daughter(person)
		daughters = []
		self.family.each do |member|
			daughters << member if ( member.parents.length > 1 && member.gender == 'Female' && member.parents.include?(person))
		end
		daughters
  end

  def find_siblings(person)
  	siblings = []
  	self.family.each do |member|
			siblings << member if ( member.parents == person.parents && member != person)
		end
		siblings
  end

  def find_sisters(person)
    sisters = []
    return sisters if person.nil?
    self.family.each do |member|
      sisters << member if ( member.gender == "Female" && member.parents === person.parents && member != person )
    end
    sisters
  end

  def find_brothers(person)
    brothers = []
    return brothers if person.nil?
    self.family.each do |member|
      brothers << member if ( member.gender == "Male" && member.parents === person.parents && member != person )
    end
    brothers
  end

  def find_maternal_uncle(person)
		find_brothers(person.parents.find{ |parent| parent.parents.length > 1 && parent.gender == 'Female'})
  end

  def find_paternal_uncle(person)
		find_brothers(person.parents.find{ |parent| (parent.parents.length > 1 && parent.gender =='Male')})
  end

  def find_maternal_aunt(person)
    find_sisters(person.parents.find{ |parent| parent.parents.length > 1 && parent.gender == 'Female'})
  end

  def find_paternal_aunt(person)
    find_sisters(person.parents.find{ |parent| parent.parents.length > 1 && parent.gender == 'Male'})
  end

  def find_brother_in_law(person)
    if person.parents.length == 1 # Spouse’s brothers
      find_brothers(person.parents.first)
    elsif person.parents.length == 2 # Husbands of siblings
    	find_husbands_of_siblings(person)
    else
    	return []
    end
  end

  def find_sister_in_law(person)
    if person.parents.length == 1 # Spouse's sisters
      find_sisters(person.parents.first)
    elsif person.parents.length == 2 # wives of siblings
      find_wives_of_siblings(person)
    else
      return []
    end
  end

  def find_husbands_of_siblings(person)
  	husbands_of_siblings =[]
  	sisters = find_sisters(person)
  	return [] if sisters.empty?
  	self.family.each do |member|
  		husbands_of_siblings << member if member.parents.length == 1 && member.gender == 'Male' && sisters.any?{ |x| member.parents.include?(x) }
  	end
  	husbands_of_siblings
  end

  def find_wives_of_siblings(person)
  	wives_of_siblings =[]
  	brothers = find_brothers(person)
  	return [] if brothers.empty?
  	self.family.each do |member|
  		wives_of_siblings << member if member.parents.length == 1 && member.gender == 'Female' && brothers.any?{ |x| member.parents.include?(x) }
  	end
  	wives_of_siblings
  end
end