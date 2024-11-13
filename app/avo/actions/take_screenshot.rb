class Avo::Actions::TakeScreenshot < Avo::BaseAction
  self.name = "Take fresh screenshot"
  # self.visible = -> do
  #   true
  # end

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      AttachScreenshotJob.perform_later record
    end
  end
end
