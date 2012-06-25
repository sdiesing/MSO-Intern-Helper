# 
#  MSOIntern.rb
#  MSO Intern
#  
#  Created by Stefan Diesing on 2012-05-16.
#  Copyright 2012 Stefan Diesing. All rights reserved.
# 

# TODO
# proxy

require_relative 'RailsHelper'

APP_URL         = "https://intern.marienschule.com/magic/"
LOGIN_URL       = APP_URL + "users/sign_in"
COURSES_URL     = APP_URL + "courses/"
EDIT_URL        = APP_URL + "home/edit"

class MSOIntern
  include RailsHelper
  
  attr_reader :username
  
  # create a new MSO Intern Object whith login.
  # login is required in this to ensure a valid session for every method
  def initialize(username,password,proxy = "")
    @username = username
    @proxy = proxy
    # do something with the proxy
    
    begin
      @session  = login LOGIN_URL, @username, password
    rescue Exception => e
      if e.message == "No redirect occured: server did not accept the request."
        raise "invalid username or password"
      else
        raise e.message
      end
    end
    
  end
  
  # returns an array of arrays with coverlessons
  # this method does work for the coverlessons displayed on the user's home page only
  def coverlessons
    
    if https_get( APP_URL, @session)[1] =~ /<table class='cover_lessons'>((.|\n)*)<\/table>\n*<h2>Meine Karteikarte<\/h2>/
      coverlessons = $1.split('</tr>')[1...-1]
    
      coverlessons.map! do |row|
        info = row.split(">")
        info.delete_at 0
        8.times { |i| info.delete_at i  }
        info.map!{ |e| e[0...-4].delete("\n")}
        info[0] = info[0].split(", ")
        info.flatten
      end
    else
      return []
    end
  end
  
  # returns an array of arrays each for one user's course
  # the courses are sortet by typ and block
  def courses
    courses = content_of_div("courses", APP_URL, "<i>schrifltiche")[26..-1].split("<div")[1..-1].map do |e|
      e =~ /courses\/(.*)\">(.*)<\/a>\n(.?)/
      info   = $2.split(" ")
      course = [$1.to_i] + info[0...-2]
      course << (info[-2] + info[-1]).delete("()")
      course << ($3 == "*")
    end
  
    courses.sort! {|x,y| x[2] <=> y[2]}
    courses.slice!(-2..-1) + courses
  end
  
  # planned methodes
  
  def update(info = {})
  end
  
  def mail
  end
  
  def mail=(mail)
    update mail: mail
  end
  
  private
  
  # returns the html content of the first div with given class in a url's html code
  def content_of_div(div_class, url, following_tags = "")
    find /<div class='#{div_class}'>((.|\n)*)<\/div>\n*#{following_tags}/ , url

  end
  
  def content_of_table(table_class, url, following_tags = "")
    find /<table class='#{table_class}'>((.|\n)*)<\/table>\n*#{following_tags}/ , url
  end
  
  def find(regex, url)
    https_get( url, @session)[1] =~ regex
    return $1
  end
  
end