require 'faraday'
require 'json'
class PokemonsController < ApplicationController
  def index
    @pokemons = get_pokemon    
  end

  
  def show
    normalized_name = params[:name].downcase
    response = Faraday.get("https://pokeapi.co/api/v2/pokemon/#{normalized_name}")
    json = JSON.parse(response.body)
    @pokemon = {
      name: json["name"].capitalize,
      image: json["sprites"]["other"]["official-artwork"]["front_default"],
      id: json["id"],
      weight: json["weight"],
      height: json["height"],
      types: json["types"],
      abilities: json["abilities"]
      # Add other attributes as needed
    }
  rescue JSON::ParserError
    redirect_to error_path, alert: "Sorry, that Pokemon could not be found."
  end

  def get_pokemon
    conn = Faraday.new(url: "https://pokeapi.co/api/v2/")
    response = conn.get 'pokemon?limit=100000&offset=0'
    pokemon_results = JSON.parse(response.body)["results"]

      # Filtrar los resultados según lo que se ingresó en el formulario
  if params[:search]
    search_term = params[:search].downcase
    pokemon_results.select! { |pokemon| pokemon['name'].downcase.include? search_term }
  end

    
    # Paginar los resultados
    @pokemons = Kaminari.paginate_array(pokemon_results).page(params[:page]).per(8)
    
    @pokemons.map! do |pokemon|
      response = conn.get pokemon["url"]
      pokemon_info = JSON.parse(response.body)

      abilities = pokemon_info["abilities"].map do |ability|
        ability["ability"]["name"]
      end
      {
        name: pokemon["name"].capitalize,
        url: pokemon["url"],
        image: pokemon_info["sprites"]["other"]["official-artwork"]["front_default"],
        abilities: abilities.join(', ')
      }
    end
  end 
end
