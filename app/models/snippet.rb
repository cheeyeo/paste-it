require 'digest/sha1'


class Snippet < ActiveRecord::Base

   
  validates_presence_of :body
  #validate format of filename??
  
  before_save :make_permalink, :check_ext
  
  def embed_js
    %(
      <link rel="stylesheet" href="http://localhost:3000/stylesheets/test.css"/>
      <link rel="stylesheet" href="http://localhost:3000/stylesheets/screen.css"/>
      #{self.get_formatted_content}
    )
  end
  
  
  def after_save
    Rails.cache.write("Snippets:show:#{id}",self,:unless_exist => false)
    Rails.cache.delete("Snippets:languages")
  end
  
  def after_destroy
    Rails.cache.delete("Snippets:show:#{id}")
    Rails.cache.delete("Snippets:languages")
  end
  
  def cache_key
    "#{self.class.name}:#{id}:#{updated_at.to_i}" 
  end
  
  def self.fetch_permalink(link)
    Rails.cache.fetch("Snippets:show:#{link}"){ find_by_permalink(link) }
  end
  
  def self.fetch(id)
    Rails.cache.fetch("Snippets:show:#{id}"){ find(id) }
  end
  
  def self.per_page
     10
   end
  
  
  def self.test(val)
    Rails.cache.fetch("Snippet:all:#{val}", :unless_exist => false, :expires_in=>1.minutes) do
      paginate :page => val, :order => 'created_at DESC', :conditions=>'private != 1'
    end
  end
  
  #load snippets categorized by languages
  def self.languages
    Rails.cache.fetch("Snippets:languages", :unless_exist => false) do 
      find(:all, :order=>"file_ext ASC",:conditions=>'private != 1').group_by(&:file_ext)
    end
  end
  
  def self.search(search, page=1)
    Rails.cache.fetch("Snippet:search:#{search}:#{page}", :unless_exist => false, :expires_in=>1.minutes) do
      paginate :per_page => 5, :page => page,
               :conditions => ['file_ext like ? AND private=?', "%#{search}", "false"], :order => 'created_at desc'
    end
  end
  
  
  def self.load_extensions
    #Rails.cache.fetch('extensions'){ Albino.name_extensions }
    Albino.name_extensions
  end
  
  def self.get_language_name(val)
    result=Albino.extensions.detect{|i| i[0] == "#{val}"}
    result[2]
  end
  
    
  
        
 
  def check_ext
    if !(self.file_name.empty?)
      ext = self.file_name.split('.')[1]
      #ext == ".rb" ? ext=".rbx" : ext
      self.file_ext = ".#{ext}"
    end
  end
  
  def make_permalink
    if self.permalink.nil?
      self.permalink = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
  end
  
  
  
  def find_lexer
    Albino.find_lexer("test.#{self.file_ext}")
  end
  
  def get_file_type
    Albino.find_lexer_name("test.#{self.file_ext}")
  end
  
  def get_formatted_content
    content = Albino.new(self.body, find_lexer)
    content
  end
  
  def get_sub_content
    format=self.body.split("\n")
    #format.delete_if{|x| x=="\r" || x == "    \r"}
    whole=""   
    (format[0].nil?) ? whole << " "  : whole << format[0]
    (format[1].nil?) ? whole << " "  : whole << format[1]
    (format[2].nil?) ? whole << " "  : whole << format[2]
    content = Albino.new(whole, find_lexer)
    content
  end
  
  
  
  def get_created_time
    self.created_at.strftime("%Y/%m/%d %I:%M%p")
  end
  
  
  
  
  
  
  protected
    def validate
       errors.add(:body, "must not be blank") if body.nil?
    end
  
end
