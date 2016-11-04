class Superhero < ActiveRecord::Base
  has_many :likes, dependent: :destroy
  has_many :revisions, dependent: :destroy
  validates :name, presence: true,
                    length: { minimum: 5 }
end
