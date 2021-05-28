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

dns_raw = File.readlines("zone")

def parse_dns(dns_raw)
  for i in dns_raw
    if (i[0] == "#")
      dns_raw.delete(i)
    end
  end

  for i in dns_raw
    if (i == "\r\n")
      dns_raw.delete("\r\n")
    end
  end

  x = []
  for i in dns_raw
    x.push(i.split(",").map(&:strip))
  end

  dns_raw = Hash[x.map.with_index { |x, i = 1| [i + 1, x] }]

  return dns_raw
end

dns_raw = File.readlines("zone")

def parse_dns(dns_raw)
  for dns_rawvalue in dns_raw
    if (dns_rawvalue[0] == "#") # iF dns_rwvalue equal to #(command)
      dns_raw.delete(dns_rawvalue) #delete the value
    end
  end

  for dns_rawvalue in dns_raw
    if (dns_rawvalue == "\r\n") #iF  the whitespace  int the records
      dns_raw.delete("\r\n")  # remove the whitespace
    end
  end

  array = []
  for dns_rawvalue in dns_raw
    array.push(dns_rawvalue.split(",").map(&:strip))
  end

  dns_raw = Hash[array.map.with_index { |x, i = 1| [i + 1, x] }]

  return dns_raw
end

def resolve(dns_records, lookup_chain, domain)
  push_value = false
  correct_domain = false
  for dns_recordvalue in dns_records.values #itarte the dns_records value
    for l in dns_recordvalue # iterate the  dns_recorvalue
      recordslength = dns_recordvalue.length
      if domain == l #check the domain and  records
        correct_domain = true
        if push_value == false
          if dns_recordvalue[0] == "A" # iF  records equal to A records
            domain = dns_recordvalue[recordslength - 1]
            lookup_chain.push(domain)
            push_value = true  # if  push the records  the value wili true
          end

          if dns_recordvalue[0] == "CNAME" # iF  records equal to   CNAME records
            domain = dns_recordvalue[recordslength - 1]
            lookup_chain.push(domain) #pust the records into the lookup_chine
            push_value = true  # if  push the records  the value will true
            resolve(dns_records, lookup_chain, domain)
          end
        end
      end
    end
  end
  if correct_domain == false
    print "Error: record not found for "
  end
  return lookup_chain
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
