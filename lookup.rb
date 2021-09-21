def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")


# FILL YOUR CODE HERE

def parse_dns(dns_raw)
  dns_matrix = Array.new
  for this_line in dns_raw do
    this_line = this_line.strip()
    unless this_line[0] == '#' or this_line.empty?
        dns_matrix.push(this_line.split(', '))
    end
  end
  return dns_matrix
end

def resolve(dns_records, lookup, dom)
  for entry in dns_records do
    if entry[1] == dom
      lookup.push(entry[2])
      if entry[0] == 'A'
        return lookup
      else
        return resolve(dns_records, lookup, entry[2])
      end
    end
  end
  return ["Nothing was found!"]
end


# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
