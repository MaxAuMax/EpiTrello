class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_tag, only: [:edit, :update, :destroy]

  def index
    @tags = @project.tags.order(:name)
  end

  def new
    @tag = @project.tags.build
    render layout: false
  end

  def create
    @tag = @project.tags.build(tag_params)
    if @tag.save
      respond_to do |format|
        format.html { redirect_to project_tags_path(@project), notice: 'Tag créé avec succès.' }
        format.turbo_stream { redirect_to project_tags_path(@project), status: :see_other }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_tag_form", partial: "tags/form", locals: { tag: @tag, project: @project }) }
      end
    end
  end

  def edit
    render layout: false
  end

  def update
    if @tag.update(tag_params)
      respond_to do |format|
        format.html { redirect_to project_tags_path(@project), notice: 'Tag mis à jour avec succès.' }
        format.turbo_stream { redirect_to project_tags_path(@project), status: :see_other }
      end
    else
      render :edit, layout: false
    end
  end

  def destroy
    @tag.destroy
    redirect_to project_tags_path(@project), notice: 'Tag supprimé avec succès.'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_tag
    @tag = @project.tags.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :color)
  end
end
