class WelcomeController < ApplicationController
  def index
    # @jobs=Job.where(:is_hidden=>false)
    @jobs=Job.published
    if params[:c].present?
      @category=params[:c]
      @jobs=@jobs.where(job_type:@category)
    end
  end
end
