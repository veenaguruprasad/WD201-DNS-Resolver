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

def parse_dns(raw)
  raw.
    map {|line| line.strip}.
    reject {|line| line.empty? || line[0] == '#'}.
    map {|line| line.split(", ") }.
    each_with_object({}) do |record, records|
      records[record[1]] = {type: record[0], target: record[2]}
    end
end

def resolve(dns_records, lookup_chain, domain)
    record = dns_records[domain]
    if (!record)
      lookup_chain = ["Error: Record not found for #{domain}"]
    elsif record[:type] == "CNAME"
      lookup_chain.push(record[:target])
      resolve(dns_records, lookup_chain, record[:target])
    elsif record[:type] == "A"
      lookup_chain.push(record[:target])
    else
      lookup_chain = ["Invalid record type for #{domain}"]
    end
end


# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
