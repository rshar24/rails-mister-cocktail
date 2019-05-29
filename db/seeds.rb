# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'json'
require 'open-uri'

puts 'Destroying all cocktails...'
Cocktail.destroy_all
puts 'Coctails deleted'

puts 'Destroying all ingredients...'
Ingredient.destroy_all
puts 'Ingredients deleted'

# puts 'Destroying all doses...'
# Dose.destroy_all
# puts 'Doses deleted'

# puts 'Destroying all reviews...'
# Review.destroy_all
# puts 'Reviews deleted'

puts 'Creating ingredients'
url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
ingrident_serialized = open(url).read
ingredients = JSON.parse(ingrident_serialized)
ingredients['drinks'].each do |ingredient|
  Ingredient.create(name: ingredient['strIngredient1'])
end
puts 'Ingredients created'

puts 'Retreiving names & photos...'
all_url = 'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail'
cocktails_serialized = open(all_url).read
cocktails = JSON.parse(cocktails_serialized)
cocktails['drinks'].each do |cocktail|
  cocktail_new = Cocktail.new(name: cocktail['strDrink'])
  cocktail_new.remote_photo_url = cocktail['strDrinkThumb']
  # byebug
  cocktail_new.save
end
puts 'names retreived'

Cocktail.all.each do |cocktail|
  cocktail_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=#{cocktail.name}"
  cocktail_serialized = open(URI.escape(cocktail_url)).read
  cocktail_info = JSON.parse(cocktail_serialized)
  cocktail.instructions = cocktail_info['drinks'][0]['strInstructions']
  ingredient_counter = 1
  until cocktail_info['drinks'][0]["strIngredient#{ingredient_counter}"] == '' || cocktail_info['drinks'][0]["strIngredient#{ingredient_counter}"].nil?
    dose = Dose.new(description: cocktail_info['drinks'][0]["strMeasure#{ingredient_counter}"])
    ingredient = Ingredient.find_by(name: cocktail_info['drinks'][0]["strIngredient#{ingredient_counter}"])
    dose.ingredient = ingredient
    dose.cocktail = cocktail
    dose.save
    # byebug
    ingredient_counter += 1

  end
  puts cocktail.name
end
