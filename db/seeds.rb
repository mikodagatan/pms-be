# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 2.times do |j|
#   project = Project.create(name: 'Sample Project', code: "SMPL#{j + 1}")

#   3.times do |i|
#     column = Column.create(project:, name: "Column #{i}", position: i + 1)

#     2.times do |k|
#       Card.create(column:, name: "Card #{i} - #{k}", description: 'Sample Description', position: k + 1)
#     end
#   end
# end

project = Project.find_or_create_by(code: 'SMPL3')

20.times do |i|
  user = User.create(first_name: 'User', last_name: "#{i + 1}", email: "user#{i + 1}@email.com",
                     username: "username #{i + 1}")
  project.users << user
end
