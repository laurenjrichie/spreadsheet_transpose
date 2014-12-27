require 'csv'

def csv_to_hash(file)
  investor_hash = {}
  investor_arrays = CSV.read(file).transpose
  investor_arrays.each do |array|
    investor_hash[array[0]] = array[1..-1]
  end
  investor_hash
end

def investor_to_person(investor_hash) # turn investor-sorted hash into person-sorted hash
  people_hash = {}
  investor_hash.each_pair do |investor, people|
    people.each do |person|
      people_investor_pairs = investor_hash.select{|i, p| p.include?(person)}
      people_hash.store(person, people_investor_pairs.keys.to_a)
    end
  end
  people_hash
end

def remove_inner_nesting(array)
  result = []
  array.each { |array| result << array.flatten }
  result
end

def hash_to_array(hash)
  result = []
  hash.each_pair do |person, investors|
    person_investors_array = [person, investors.flatten]
    result << person_investors_array
  end
  remove_inner_nesting(result)
end

def find_longest_array(arrays)
  array_lengths = []
  arrays.each { |array| array_lengths << array.length }
  longest_array = array_lengths.max
end

def equalize_array_lengths(array, max_length)
  equal_arrays = []
  array.each do |array|
    add_0s = max_length - array.length
    if array.length < max_length
      add_0s.times do
        array << 0
      end
    end
    equal_arrays << array
  end
end

def export_to_csv(file, array)
  CSV.open(file, "w") do |csv|
    array.each { |single_array| csv << single_array }
  end
end

def magic_transpose(input_file, output_file)
  investor_hash = csv_to_hash(input_file)
  people_hash = investor_to_person(investor_hash)
  people_investors_array = hash_to_array(people_hash)
  longest_array = find_longest_array(people_investors_array)
  array_to_export = equalize_array_lengths(people_investors_array, longest_array).transpose
  export_to_csv(output_file, array_to_export)
end

magic_transpose("/Users/laurenjrichie/Documents/MJ_test.csv", "/Users/laurenjrichie/Documents/MJ_output.csv")
