class JobsController < ApplicationController
  before_action :authenticate_user!,only:[:new,:create,:edit,:update,:destroy]
  def index
    # @jobs=Job.where(:is_hidden=>false)
    @jobs=Job.published.paginate(:page=>params[:page],:per_page=>15)
    if params[:c].present?
      @category=params[:c]
      @jobs=@jobs.where(job_type:@category)
    end
    @jobs=case params[:order]
  when 'by_lower_bound'
    @jobs.order('wage_lower_bound DESC')
  when 'by_upper_bound'
    @jobs.order('wage_upper_bound DESC')
  else
    @jobs.recent
  end
  end
  def new
    @job=Job.new
  end
  def show
    @job=Job.find(params[:id])
    if @job.is_hidden
      flash[:warning]="This job is already been archieved"
      redirect_to root_path
    end
  end
  def edit
    @job=Job.find(params[:id])
  end
  def create
    @job=Job.new(job_params)
    if @job.save
      redirect_to jobs_path
    else
      render :new
    end
  end
  def update
    @job=Job.find(params[:id])
    if @job.update(job_params)
      redirect_to jobs_path
    else
      render :edit
    end
  end
  def destroy
    @job=Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path
  end

  private
  def job_params
    params.require(:job).permit(:title,:description,:wage_lower_bound,:wage_upper_bound,:contact_email,
      :is_hidden,:job_type)
  end

end
