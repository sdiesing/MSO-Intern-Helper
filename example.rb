# 
#  example.rb
#  MSOIntern
#  
#  Created by Stefan Diesing on 2012-05-16.
#  Copyright 2012 Stefan Diesing. All rights reserved.
# 

require_relative 'lib/MSOIntern'

USERNAME = ""
PASSWORD = ""

# login
mso = MSOIntern.new USERNAME, PASSWORD 

# get the coverlessons
puts mso.coverlessons.map{|e| e.join("\t")}

# get your courses
puts mso.courses.map{|e| e.join("\t")}


# lessons   = ""
# last_day  = ""
# 
# MSOIntern.new(USERNAME,PASSWORD).coverlessons.each do |lesson|
#   unless last_day == lesson[1]
#     last_day = lesson[1]
#     lessons << lesson[0] + ", " + lesson [1] + "\t"
#   else
#     lessons << "".rjust(16)   
#   end
#       
#   lessons << lesson[3] + ". " + lesson[4].ljust(20) + lesson[5].ljust(35) + "" + lesson[7] + "\n"
#   lessons << "\t" + lesson[6] + "\n" unless lesson[6] == "-"
# end
#   
# 
# puts lessons
# puts "\n(Last update: #{Time.now.strftime('%d.%m %H:%M')})" unless lessons == ""
