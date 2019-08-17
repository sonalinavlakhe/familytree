require_relative '../person'
require_relative '../home'
require 'rspec'
require 'pry'

describe 'person' do

	before do
		@new_home = Home.new
		@person1 = Person.new('King Shan', 'Male', '0', [])
		@person2 = Person.new('Queen Anga', 'Female', '0', [@person1.name])
		@person2 = Person.new('Queen Anga', 'Female', '0', [@person1.name])
		@new_home.family << @person1
		@new_home.family.last.add_parents(@new_home)
		@new_home.family << @person2
		@new_home.family.last.add_parents(@new_home)
	end

	context 'initialize' do
		it 'should create person' do
			expect(@person1.name).to eq('King Shan')
		end
	end

	context 'add parents' do
		context 'add parent to spouse' do
			it 'should add parent to spouse' do
				expect(@new_home.family.last.parents.first.name).to eq('King Shan')
				expect(@new_home.family.last.parents.length).to eq(1)
			end
		end
		context 'add parent to child' do
			it 'should add parent to child' do
				@person2.add_child(@new_home, ['Chit', 'Male'])
				expect(@new_home.family.last.parents.map(&:name)).to eq(['King Shan', 'Queen Anga'])
				expect(@new_home.family.last.parents.length).to eq(2)
			end
		end
	end

	context 'add_child to person' do
		context 'if person is female and parent(husband) exists' do
			it "should add 'chit' child to person" do
				expect{ @person2.add_child(@new_home, ['','Chit', 'Male']) }.to output("CHILD_ADDITION_SUCCEEDED\n").to_stdout
			end
		end
		context 'person is male ' do
			it "should not add child to person" do
				expect{ @person1.add_child(@new_home, ['','Chit', 'Male']) }.to output("CHILD_ADDITION_FAILED\n").to_stdout
			end
		end
		context 'person is female and parent(husband) does not exists' do
			it "should not add child to person" do
			  @person2.add_child(@new_home, ['','Chita', 'Female'])
				expect{ @new_home.family.last.add_child(@new_home, ['','Vinit', 'Male']) }.to output("CHILD_ADDITION_FAILED\n").to_stdout
			end
		end
	end

	context 'find_relatives' do
		before(:each) do
			@new_home = Home.new
			path = './db/familymemberslist.yml'
			yml = YAML::load(File.open(path))
			yml['members'].each { |member|
				@new_home.family << Person.new(member.last['name'], member.last['gender'], member.last['gen'], member.last['parents'])
				@new_home.family.last.add_parents(@new_home)
      }
		end

		context 'find the sons' do
			it 'should return all the sons of the person' do
				person = @new_home.family.find { |member| member.name == 'King Shan' }
				relatives = @new_home.find_son(person)
				expect(relatives.map!{ |relative| relative.name }.join(' ')).to eq("Ish Chit Vich Aras")
			end
		end

		context 'find the Daughters' do
			it 'should return all the daughters of the person' do
				person = @new_home.family.find { |member| member.name == 'Vich' }
				relatives = @new_home.find_daughter(person)
				expect(relatives.map!{ |relative| relative.name }.join(' ')).to eq("Vila Chika")
			end
		end

		context 'find the Siblings' do
			it 'should return all the siblings of the person' do
				person = @new_home.family.find { |member| member.name == 'Chit' }
				relatives = @new_home.find_siblings(person)
				expect(relatives.map!{ |relative| relative.name }.join(' ')).to eq("Ish Vich Satya Aras")
			end
		end

		context 'find Paternal-Uncle' do
			it 'should return Paternal-Uncle of the person' do
				person = @new_home.family.find { |member| member.name == 'Vasa' }
				relatives = @new_home.find_paternal_uncle(person)
				expect(relatives.map!{ |relative| relative.name }.join(' ')).to eq("Vyas")
			end
		end

		context 'find Maternal-Uncle' do
			it 'should return Maternal-Uncle of the person' do
				person = @new_home.family.find { |member| member.name == 'Lavnya' }
				relatives = @new_home.find_maternal_uncle(person)
				expect(relatives.map!{ |relative| relative.name }.join(' ')).to eq("Ahit")
			end
		end

		context 'find Paternal-Aunt' do
			it 'should return Paternal-Aunt of the person' do
				person = @new_home.family.find { |member| member.name == 'Vasa' }
				relatives = @new_home.find_paternal_aunt(person)
				expect(relatives.map!{ |relative| relative.name }.join(' ')).to eq("Atya")
			end
		end

		context 'find Maternal-Aunt' do
			it 'should return Maternal-Aunt of the person' do
				person = @new_home.family.find { |member| member.name == 'Yodhan' }
				relatives = @new_home.find_maternal_aunt(person)
				expect(relatives.map!{ |relative| relative.name }.join(' ')).to eq("Tritha")
			end
		end

		context 'find Sister-In-Law' do
			it 'should return Sister-In-Law of the person' do
				# Spouse’s sisters
				person = @new_home.family.find { |member| member.name == 'Jaya' }
				relatives = @new_home.find_sister_in_law(person)
				expect(relatives.map!{ |relative| relative.name }.join(' ')).to eq("Tritha")
				# Wives of siblings
				person = @new_home.family.find { |member| member.name == 'Chit' }
				relatives = @new_home.find_sister_in_law(person)
				expect(relatives.map!{ |relative| relative.name }.join(' ')).to eq("Lika Chitra")
			end
		end

		context 'find Brother-In-Law' do
			it 'should return Brother-In-Law of the person' do
				#Spouse’sbrothers
				person = @new_home.family.find { |member| member.name == 'Arit' }
				relatives = @new_home.find_brother_in_law(person)
				expect(relatives.map!{ |relative| relative.name }.join(' ')).to eq("Ahit")
				#Husbands of siblings
				person = @new_home.family.find { |member| member.name == 'Tritha' }
				relatives = @new_home.find_brother_in_law(person)
				expect(relatives.map!{ |relative| relative.name }.join(' ')).to eq("Jaya")
			end
		end
	end
end