class Author < ActiveRecord::Base
  validates_presence_of :firstname, :lastname

  has_many :books
end
