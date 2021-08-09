class Category < ApplicationRecord
  has_many :article_categories
  has_many :articles, through: :article_categories

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: {minimum:5, maximum:20}
end