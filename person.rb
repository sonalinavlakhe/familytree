class Person
	attr_accessor :name, :gender, :generations, :parents

	def initialize(name, gender, generations, parents)
		@name = name
		@gender = gender
		@generations = generations
		@parents = parents
	end

	def add_parents(home)
		self.parents.map! do |parent|
			home.family.find { |member| member.name == parent}
		end
	end

	def find_relatives(relation, home)
		relatives  = nil
		case relation
		when 'Son'
			relatives = home.find_son(self)
		when 'Daughter'
			relatives = home.find_daughter(self)
		when 'Siblings'
			relatives = home.find_siblings(self)
		when 'Paternal-Uncle'
			relatives = home.find_paternal_uncle(self)
		when 'Maternal-Uncle'
			relatives = home.find_maternal_uncle(self)
		when 'Paternal-Aunt'
			relatives = home.find_paternal_aunt(self)
		when 'Maternal-Aunt'
			relatives = home.find_maternal_aunt(self)
		when 'Sister-In-Law'
			relatives = home.find_sister_in_law(self)
		when 'Brother-In-Law'
			relatives = home.find_brother_in_law(self)
		else
			relatives = []
    end
  	relatives
	end

	def add_child(home, sorted_inputs)
		parents = home.find_parents(self)
		if self.gender == 'Female' && !parents.empty? #Add Child to Female having patner
      child_generations = self.generations.to_i + 1
      child = Person.new(sorted_inputs[1], sorted_inputs[2], child_generations, parents)
      unless child.nil?
        home.family << child
        puts "CHILD_ADDITION_SUCCEEDED"
      end
    else
      puts "CHILD_ADDITION_FAILED"
    end
	end
end

