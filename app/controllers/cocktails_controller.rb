class CocktailsController < ApplicationController

  def index
    @cocktails = Cocktail.all
  end

  def show
    @cocktail = Cocktail.find(params[:id])
    @dose = Dose.new
    @review = Review.new
    @average_rating = @cocktail.avg_rating
    @no_of_reviews = @cocktail.reviews_count
    @avg_rating_dec = @cocktail.avg_rating_dec
  end

  def new
    @cocktail = Cocktail.new
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)
    if @cocktail.save
      params[:quantity].each_with_index do |ing, index|
        @dose = Dose.new(description: ing)
        @ingredient = Ingredient.find(params[:ingredient][index])
        @dose.ingredient = @ingredient
        @dose.cocktail = @cocktail
        @dose.save
      end
      redirect_to cocktail_path(@cocktail)
    else
      render :new
    end
  end

  private

  def cocktail_params
    params.require(:cocktail).permit(:name, :photo)
  end
end
