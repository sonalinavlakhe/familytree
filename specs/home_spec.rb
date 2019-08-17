require_relative '../home'
require_relative '../person'
require 'pry'

describe 'Home' do

  context 'initialize' do
    it 'should create home instance with attribute family' do
      @new_home = Home.new
      expect(@new_home).to have_attributes(family: [])
    end
  end

  context 'find_relatives_home' do
    before(:each) do
      @new_home = Home.new
      path = './db/familymemberslist.yml'
      yml = YAML::load(File.open(path))
      yml['members'].each { |member|
        @new_home.family << Person.new(member.last['name'], member.last['gender'], member.last['gen'], member.last['parents'])
        @new_home.family.last.add_parents(@new_home)
      }
    end
    context 'find parents for a child ' do
      context 'when person is female with parents one(husband)' do
        it 'should give parents for child' do
          person = @new_home.family.find { |member| member.name == 'Satvy' }
          expect( @new_home.find_parents(person).first.name).to eq('Asva')
        end
      end
      context 'when person is female with parent two(parents)' do
        it 'it should give parents for child' do
          person = @new_home.family.find { |member| member.name == 'Jnki' }
          result = @new_home.find_parents(person).all?{ |parent| ['Arit','Jnki'].include?(parent.name) }
          expect(result).to eq(true)
        end
      end
      context 'when person is female with parent count zero(having no patner)' do
        it 'it should give blank array of parents' do
          person = @new_home.family.find { |member| member.name == 'Atya' }
          expect(@new_home.find_parents(person)).to eq([])
        end
      end
    end
    context 'patner_exists?' do
      context 'if parter exits' do
        it 'should return true'do
          person = @new_home.family.find { |member| member.name == 'Satya' }
          expect(@new_home.patner_exists?(person)).to eq(true)
        end
      end
      context 'if patner does not exists' do
        it 'should return false'do
          person = @new_home.family.find { |member| member.name == 'Atya' }
          expect(@new_home.patner_exists?(person)).to eq(false)
        end
      end
    end
    context 'find_patner' do
      context 'if parter exits' do
        it 'should return true'do
          person = @new_home.family.find { |member| member.name == 'Satya' }
          expect(@new_home.find_patner(person).name).to eq('Vyan')
        end
      end
      context 'if patner does not exists' do
        it 'should return false'do
          person = @new_home.family.find { |member| member.name == 'Atya' }
          expect(@new_home.find_patner(person)).to eq(nil)
        end
      end
    end
    context 'find_son' do
      context 'if son exits' do
        it 'should return sons'do
          person = @new_home.family.find { |member| member.name == 'Satya' }
          expect(@new_home.find_son(person).map(&:name)).to eq(["Asva", "Vyas"])
        end
      end
      context 'if son does not exists' do
        it 'should return blank array of sons'do
          person = @new_home.family.find { |member| member.name == 'Atya' }
          expect(@new_home.find_son(person)).to eq([])
        end
      end
    end

    context 'find_daughter' do
      context 'if daughter exits' do
        it 'should return daughter'do
          person = @new_home.family.find { |member| member.name == 'Chitra' }
          expect(@new_home.find_daughter(person).map(&:name)).to eq(["Jnki"])
        end
      end
      context 'if daughter does not exists' do
        it 'should return blank array of daughters'do
          person = @new_home.family.find { |member| member.name == 'Laki' }
          expect(@new_home.find_daughter(person)).to eq([])
        end
      end
    end

    context 'find_siblings' do
      context 'if siblings exit' do
        it 'should return siblings'do
          person = @new_home.family.find { |member| member.name == 'Dritha' }
          expect(@new_home.find_siblings(person).map(&:name)).to eq(["Tritha", "Vritha"])
        end
      end
      context 'if sibling does not exists' do
        it 'should return blank array of sibling'do
          person = @new_home.family.find { |member| member.name == 'Satvy' }
          expect(@new_home.find_siblings(person)).to eq([])
        end
      end
    end

    context 'find_sisters' do
      context 'if sisters exits' do
        it 'should return sisters'do
          person = @new_home.family.find { |member| member.name == 'Dritha' }
          expect(@new_home.find_sisters(person).map(&:name)).to eq(["Tritha"])
        end
      end
      context 'if sisters does not exists' do
        it 'should return blank array of sisters'do
          person = @new_home.family.find { |member| member.name == 'Vasa' }
          expect(@new_home.find_sisters(person)).to eq([])
        end
      end
    end

    context 'find_brothers' do
      context 'if brothers exits' do
        it 'should return brothers'do
          person = @new_home.family.find { |member| member.name == 'Dritha' }
          expect(@new_home.find_brothers(person).map(&:name)).to eq(["Vritha"])
        end
      end
      context 'if brothers does not exists' do
        it 'should return blank array of brothers'do
          person = @new_home.family.find { |member| member.name == 'Vila' }
          expect(@new_home.find_brothers(person)).to eq([])
        end
      end
    end

    context 'find_maternal_uncle' do
      context 'if brothers exits for parent(mother) of the person' do
        it 'should return Maternal-Uncle'do
          person = @new_home.family.find { |member| member.name == 'Lavnya' }
          expect(@new_home.find_maternal_uncle(person).map(&:name)).to eq(["Ahit"])
        end
      end
      context 'if brothers does not exists for parent(mother) of the person' do
        it 'should return blank array for Maternal-Uncle'do
          person = @new_home.family.find { |member| member.name == 'Krithi' }
          expect(@new_home.find_maternal_uncle(person)).to eq([])
        end
      end
    end

    context 'find_paternal_uncle' do
      context 'if brothers exits for parent(father) of the person' do
        it 'should return Paternal-Uncle'do
          person = @new_home.family.find { |member| member.name == 'Krithi' }
          expect(@new_home.find_paternal_uncle(person).map(&:name)).to eq(["Asva"])
        end
      end
      context 'if brothers does not exists for parent(Father) of the person' do
        it 'should return blank array for Paternal-Uncle'do
          person = @new_home.family.find { |member| member.name == 'Yodhan' }
          expect(@new_home.find_paternal_uncle(person)).to eq([])
        end
      end
    end

    context 'find_maternal_aunt' do
      context 'if brothers exits for parent(mother) of the person' do
        it 'should return Maternal-aunt'do
          person = @new_home.family.find { |member| member.name == 'Yodhan' }
          expect(@new_home.find_maternal_aunt(person).map(&:name)).to eq(["Tritha"])
        end
      end
      context 'if brothers does not exists for parent(mother) of the person' do
        it 'should return blank array for Maternal-aunt'do
          person = @new_home.family.find { |member| member.name == 'Lavnya' }
          expect(@new_home.find_maternal_aunt(person)).to eq([])
        end
      end
    end

    context 'find_paternal_aunt' do
      context 'if brothers exits for parent(father) of the person' do
        it 'should return Paternal-aunt'do
          person = @new_home.family.find { |member| member.name == 'Vasa' }
          expect(@new_home.find_paternal_aunt(person).map(&:name)).to eq(["Atya"])
        end
      end
      context 'if brothers does not exists for parent(Father) of the person' do
        it 'should return blank array for Paternal-aunt'do
          person = @new_home.family.find { |member| member.name == 'Laki' }
          expect(@new_home.find_paternal_aunt(person)).to eq([])
        end
      end
    end

    context 'find_brother_in_law' do
      context 'if brothers exits for spouse of the person' do
        it 'should return brother_in_law'do
          person = @new_home.family.find { |member| member.name == 'Jaya' }
          expect(@new_home.find_brother_in_law(person).map(&:name)).to eq(["Vritha"])
        end
      end
      context 'if husband exits for siblings of the person' do
        it 'should return brother_in_law'do
          person = @new_home.family.find { |member| member.name == 'Tritha' }
          expect(@new_home.find_brother_in_law(person).map(&:name)).to eq(["Jaya"])
        end
      end
      context 'if husband does not exists siblings of the person' do
        it 'should return blank array for brother_in_law'do
          person = @new_home.family.find { |member| member.name == 'Dritha' }
          expect(@new_home.find_brother_in_law(person)).to eq([])
        end
      end
    end

    context 'find_sister_in_law' do
      context 'if sister exits for spouse of the person' do
        it 'should return sister_in_law'do
          person = @new_home.family.find { |member| member.name == 'Jaya' }
          expect(@new_home.find_sister_in_law(person).map(&:name)).to eq(["Tritha"])
        end
      end
      context 'if sister does not exits for spouse of the person' do
        it 'should return blank array for sister_in_law'do
          person = @new_home.family.find { |member| member.name == 'Arit' }
          expect(@new_home.find_sister_in_law(person).map(&:name)).to eq([])
        end
      end
      context 'if Wife exits for siblings of the person' do
        it 'should return sister_in_law'do
          person = @new_home.family.find { |member| member.name == 'Chit' }
          expect(@new_home.find_sister_in_law(person).map(&:name)).to eq(["Lika", "Chitra"])
        end
      end
      context 'if Wife does not exists siblings of the person' do
        it 'should return blank array for sister_in_law'do
          person = @new_home.family.find { |member| member.name == 'Dritha' }
          expect(@new_home.find_sister_in_law(person)).to eq([])
        end
      end
    end

    context 'find_husbands_of_siblings' do
      context 'if husband exits for siblings of the person' do
        it 'should return husband of siblings'do
          person = @new_home.family.find { |member| member.name == 'Ahit' }
          expect(@new_home.find_husbands_of_siblings(person).map(&:name)).to eq(["Arit"])
        end
      end
      context 'if husband does not exits for siblings of the person' do
        it 'should return blank array for husband of siblings'do
          person = @new_home.family.find { |member| member.name == 'Asva' }
          expect(@new_home.find_husbands_of_siblings(person)).to eq([])
        end
      end
    end

    context 'find_wives_of_siblings' do
      context 'if wife exits for siblings of the person' do
        it 'should return wife of siblings'do
          person = @new_home.family.find { |member| member.name == 'Chit' }
          expect(@new_home.find_wives_of_siblings(person).map(&:name)).to eq(["Lika", "Chitra"])
        end
      end
      context 'if wife does not exits for siblings of the person' do
        it 'should return blank array for wife of siblings'do
          person = @new_home.family.find { |member| member.name == 'Jnki' }
          expect(@new_home.find_wives_of_siblings(person)).to eq([])
        end
      end
    end
  end
end