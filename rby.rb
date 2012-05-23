require 'rubygems'

require 'rack-flash'
require 'sinatra'
require 'erb'

use Rack::Session::Cookie
use Rack::Flash

helpers do
  def requested_maps
    params.keys & valid_maps
  end
  
  def valid_maps
    %w[
      aethermaw arcanclave_citadel astral_port caves_of_the_basilisk crescent_lake cynsaun_battlefield
      den_of_onis elensefar_courtyard fallenstar_lake hamlets hornshark_island howling_ghost_badlands
      sablestone_delta serpent_ford silverhead_crossing sullas_ruins swamp_of_dread the_freelands
      tombs_of_kesorak thousand_stings_garrison weldyn_channel
    ]
  end
  
  def template
    File.read 'template.tpl'
  end
  
  def max
    (requested_maps.size * 2 - 1).to_s
  end

  def names
    requested_maps.map{|name| normalize name}.join ', '
  end

  def normalize name
    name.split('_').map{|word| word.capitalize}.join(' ')
  end

  def render_template
    template.gsub('/names/', names).gsub('/max/', max).gsub('/scenarios/', scenarios)
  end

  def scenario number, name
    scenario = ''
    scenario << %Q[\n            {RBY_CASE_NEXTSCEN #{number * 2} "RBY #{name} 12"}]
    scenario << %Q[\n            {RBY_CASE_NEXTSCEN #{number * 2 + 1} "RBY #{name} 21"}]
  end

  def scenarios
    scenarios = ''
    requested_maps.each_with_index do |map, index|
      normalized_map = normalize map
      scenarios << scenario(index, normalized_map)
    end
    scenarios
  end
end

get '/' do
  erb :index
end

post '/' do
  if requested_maps.size > 1
    attachment 'RBY_Custom.cfg' ; content_type 'text/plain' ; render_template
  else
    flash[:warn] = 'Select at least two maps.' ; redirect '/'
  end
end

not_found do
  redirect '/'
end
