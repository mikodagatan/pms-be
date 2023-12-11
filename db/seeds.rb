# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

project = Project.create(name: 'Sample Project', code: 'SMPL')

3.times do |i|
  column = Column.create(project:, name: "Column #{i}", position: i)

  2.times do |k|
    Card.create(column:, name: "Card #{i} - #{k}", description: 'Sample Description', position: k + 1)
  end
end
