class Avo::Resources::Listing < Avo::BaseResource
  # self.record_selector = false
  # self.keep_filters_panel_open = true
  # self.index_query = -> { query.unscoped }

  # self.default_sort_column = :last_name
  # self.default_sort_direction = :asc

  self.default_view_type = :grid
  self.title = :computed_title

  # self.includes = []
  # self.attachments = []
  self.search = { query: lambda {
    query.ransack(name_cont: params[:q],
                  description_cont: params[:q],
                  url_cont: params[:q],
                  payload_cont: params[:q],
                  m: "or").result(distinct: false) },
                  item: -> do
                    {
                      title: record.computed_title
                    }
                  end
  }

  def fields
    # field :id, as: :id
    # field :name, as: :text
    # field :description, as: :textarea
    field :url, as: :text
    field :website_screenshot, as: :file, is_image: true, max_file_size: 3.megabytes, hide_on: [ :show ]

    field :title, as: :text, as_html: true do
      record.payload&.dig("page_title")
    end
    field :details, as: :text, as_html: true do
      record.payload&.dig("meta_description")
    end

    field :payload, as: :textarea, hide_on: :forms
    field :categories, as: :has_many, through: :category_listings,
                  attach_scope: lambda {
                                  query.where.not(id: parent.category_listings.select(:category_id))
                                }
  end

  self.grid_view = {
    card: lambda {
      {
        cover_url: (main_app.url_for(record.website_screenshot.url) if record.website_screenshot.attached?),
        title: [ record.clean_url, record.payload&.dig("page_title") ].compact.join(" - "),
        body: record.payload&.dig("meta_description")
      }
    }
  }

  def actions
    action Avo::Actions::TakeScreenshot
    action Avo::Actions::CrawlUrl
  end

  self.profile_photo = {
    source: -> {
      if view.index?
        # We're on the index page and don't have a record to reference
        "/icon.png"
      else
        # We have a record so we can reference it's profile_photo
        record.payload&.dig("favicon_url") || "/icon.png"
      end
    }
  }

  self.cover_photo = {
    size: :md, # :sm, :md, :lg
    visible_on: [ :show ], # can be :show, :index, :edit, or a combination [:show, :index]
    source: -> {
      if view.index?
        # We're on the index page and don't have a record to reference
        "/icon.png"
      else
        # We have a record so we can reference it's cover_photo
        record.website_screenshot
      end
    }
  }
end
