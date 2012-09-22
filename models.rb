class Applicant < ActiveRecord::Base
  validates_format_of :email,
    :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i,
    :message => "Invalid email format"
  validates :email, :uniqueness => true
end

# class Product < ActiveRecord::Base
#   belongs_to :category
#
#   validates_presence_of :image_url, :title, :link
#   validates_length_of :image_url, :title, :link, :minimum => 1, :allow_blank => false
#
#   default_scope order('created_at DESC')
#
#   def hello
#     "world"
#   end
# end
#
# class Category < ActiveRecord::Base
#   has_many :products
#
#   validates_presence_of :name
#   validates_uniqueness_of :name
#
#   delegate :to_s, :to => :name
#
#   def self.to_options
#     all.collect{|cat| [cat.name, cat.id]}
#   end
# end
