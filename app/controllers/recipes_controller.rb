# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :set_course, only: [:index]
  before_action :set_cuisine, only: [:index]
  before_action :set_safe_params, only: [:index]
  before_action :authenticate_user!, except: [:show, :index]

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.all
    @recipes = @recipes.with_public if current_user.blank?
    @recipes = @recipes.search_for(params[:search]) if params[:search]
    @recipes = @recipes.with_course(@course) if @course
    @recipes = @recipes.with_cuisine(@cuisine) if @cuisine
    @recipes = @recipes.page params[:page]
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new(user: current_user)
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = Recipe.new(recipe_params.merge(user: current_user))

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_course
      @course = Course.find_by_id(params[:course_id])
    end

    def set_cuisine
      @cuisine = Cuisine.find_by_id(params[:cuisine_id])
    end

    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def set_safe_params
      @safe_params = params.permit(:course_id, :search, :cuisine_id)
    end

    def recipe_params
      params.require(:recipe).permit(:title, :info, :public, :user_id, :search, :course_id, :cuisine_id)
    end
end
