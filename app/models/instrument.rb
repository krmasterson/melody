class Instrument < ApplicationRecord
  include AlgoliaSearch
  has_many :bookings, dependent: :destroy
  belongs_to :user
  has_many_attached :photos

  algoliasearch do
    attributes :name, :description, :category, :location
  end

  CATEGORY = %w(Keyboard Violin Guitar Drums Flute Harmonica Microphone Harp Accordion Maracas Saxophone Xylophone)

  validates :user_id, presence: true
  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORY }
  validates :price, presence: true, numericality: { only_integer: true }
  validates :location, :description, presence: true

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
