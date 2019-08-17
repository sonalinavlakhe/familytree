require './person'
require './home'
require 'pry'
require 'rspec'

#Execute Rspecs
RSpec::Core::Runner.run([File.dirname(__FILE__) + '/specs'])

# Load existing family tree
@new_home = Home.new
path = './db/familymemberslist.yml'
yml = YAML::load(File.open(path))
yml['members'].each { |member|
  @new_home.family << Person.new(member.last['name'], member.last['gender'], member.last['gen'], member.last['parents'])
  @new_home.family.last.add_parents(@new_home)
}


def sort_out_input(command, sliced_input)
  if command == 'GET_RELATIONSHIP'
    if ['King','Queen'].include?(sliced_input[1])
      person_name = sliced_input[1]+ ' '+ sliced_input[2]
      relation = sliced_input[3]
    else
      person_name = sliced_input[1]
      relation = sliced_input[2]
    end
    return [person_name, relation]
  elsif command == 'ADD_CHILD'
    person_name = sliced_input[1]
    child_name = sliced_input[2]
    child_gender = sliced_input[3]
    return [person_name, child_name, child_gender]
  else
    puts "PLESE ENTER VALID COMMAND"
    return []
  end
end

#process file commands one by one
def process_input(input)
  input.split("\n").each do |input|
    sliced_input = input.split(/\s/)
    command = sliced_input[0]
    sorted_inputs = sort_out_input(command, sliced_input)
    next if sorted_inputs.empty?
    person = @new_home.family.find { |member| member.name == sorted_inputs[0] }
    if person.nil?
      puts "PERSON_NOT_FOUND"
      next
    end
    if command == 'GET_RELATIONSHIP'
      relatives = person.find_relatives(sorted_inputs[1], @new_home)
      relatives.empty? ? (puts "NONE") :  (puts relatives.map!{ |relative| relative.name }.join(' '))
    elsif command == 'ADD_CHILD'
      person.add_child(@new_home, sorted_inputs)
    else
      puts "PLEASE ENTER VALID COMMAND"
      next
    end
  end
end

#checkout file parameter
if (ARGV.length == 0)
    puts "Please enter input file"
    return
else
  begin
    input = File.read(ARGV[0])
  rescue StandardError => bang
    puts "Error reading file #{ bang }"
    return
  end
end
begin
  process_input(input)
rescue StandardError => bang
puts "Error processing input. Error - #{ bang }"
end



