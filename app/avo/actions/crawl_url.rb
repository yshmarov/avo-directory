class Avo::Actions::CrawlUrl < Avo::BaseAction
  self.name = "Update Website Data"
  # self.visible = -> do
  #   true
  # end

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      HomepageCrawlerJob.perform_later(record)
    end
  end
end
