class Avo::Resources::Listing < Avo::BaseResource
  self.title = :computed_title

  # self.includes = []
  # self.attachments = []
  self.search = { query: lambda {
    query.ransack(name_cont: params[:q],
                  description_cont: params[:q],
                  url_cont: params[:q],
                  m: 'or').result(distinct: false) },
                  item: -> do
                    {
                      title: record.computed_title,
                    }
                  end
  }

  def fields
    # field :id, as: :id
    field :website_screenshot, as: :file, is_image: true, max_file_size: 3.megabytes
    field :name, as: :text
    field :description, as: :textarea
    field :url, as: :textarea
  end
end
