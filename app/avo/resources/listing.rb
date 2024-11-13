class Avo::Resources::Listing < Avo::BaseResource
  def fields
    # field :id, as: :id
    field :website_screenshot, as: :file, is_image: true, max_file_size: 3.megabytes
    field :name, as: :text
    field :description, as: :textarea
    field :url, as: :textarea
  end
end
