
class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }

  validates_presence_of :title, :description

  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader

  def self.search_by_title(title)
    return [] if title.blank?
    results = where("lower(title) LIKE ?", "%#{title.downcase}%").order("created_at DESC")
  end

  def self.search(query, options={})
    search_definition = {
      query: {
        bool: {
          must: {
            multi_match: {
              query: query,
              fields: ["title^100", "description^50"],
              operator: "and"
            }
          }
        }
      }
    }

    search_definition[:query][:bool][:must][:multi_match][:fields].push("reviews.content") if options[:reviews]

    if options[:rating_from].present? || options[:rating_to].present?
      search_definition[:query][:bool][:filter] = {
        range: {
          rating: {
            gte: (options[:rating_from] if options[:rating_from]),
            lte: (options[:rating_to] if options[:rating_from])
          }
        }
      }
    end

    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(options={})
    as_json(only: [:title, :description],
            methods: :rating,
            include: { reviews: { only: :content } })
  end

  def rating
    average = reviews.average(:rating)
    average.round(1) if average
  end
end