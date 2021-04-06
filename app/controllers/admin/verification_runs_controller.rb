Response = Struct.new(:out, :err, :start_time, :finish_time, :state)

class Admin::VerificationRunsController < ApplicationController
  before_action :authenticate_user!, only: %i[create show]

  skip_forgery_protection only: :update
  before_action :authenticate_api_call, only: :update

  def create
    build_verification_run
    save_verification_run
    @verification_run.create_new_rails_app!
  end

  def show
    load_verification_run
  end

  def update
    github_status = params[:github_status]

    puts "github repo: #{params[:id]} | GH status: #{github_status}"

    verification_run = AppRecipe.find_by(app_name: params[:id]).most_recently_started

    # neutral, success, skipped, cancelled, timed_out, action_required, failure
    if params[:github_status] == "success"
      verification_run.finish_with_success!
    else
      verification_run.finish_with_failure!
    end

    render plain: "github repo: #{params[:id]} | GH status: #{github_status}"
  end

  private

  def authenticate_api_call
    authenticate_or_request_with_http_token do |api_token, _options|
      User.find_by(api_token: api_token)
    end
  end

  def build_verification_run
    @verification_run ||= verification_run_scope.build
  end

  def verification_run_scope
    load_app_recipe
    @app_recipe.verification_runs
  end

  def load_app_recipe
    @app_recipe ||= app_recipe_scope.find(params[:app_recipe_id])
  end

  def app_recipe_scope
    AppRecipe
  end

  def save_verification_run
    @verification_run.save

    # redirect_to admin_app_recipe_verification_run_path(@app_recipe, @verification_run)
    redirect_to admin_app_recipes_path(@app_recipe)
  end

  def load_verification_run
    @verification_run ||= verification_run_scope.find(params[:id])
  end
end
