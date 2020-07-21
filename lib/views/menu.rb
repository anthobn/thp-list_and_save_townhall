class Menu
  attr_accessor :towns

  def initialize(towns)
    @towns = towns
    puts "------------------------------------------"
    puts "- Veuillez selectionner un format d'export"
    puts "------------------------------------------"
    puts "- 1 - Export en JSON                     -"
    puts "- 2 - Export en CSV                      -"
    puts "------------------------------------------"
    puts ""
    print "Entrez un choix : "
    input = gets.chomp
    choice(input.to_i)
  end

  def choice(input)
    if input == 1
      @towns.save_as_JSON
    else
      @towns.save_as_csv
    end
  end
end