admin = User.find_or_create_by!(email: "admin@wheels.local") do |u|
  u.name = "Admin"
  u.password = "password"
  u.superadmin = true
end

factory = Factory.find_or_create_by!(name: "Main Factory")
dc = DistributionCenter.find_or_create_by!(name: "Downtown Distribution")

# User assigned to both a factory and a distribution center
both = User.find_or_create_by!(email: "both@wheels.local") do |u|
  u.name = "Alex Both"
  u.password = "password"
end
both.user_factories.find_or_create_by!(factory: factory) { |uf| uf.role = "volunteer" }
both.user_distribution_centers.find_or_create_by!(distribution_center: dc) { |udc| udc.role = "volunteer" }

# User assigned to only the factory
factory_user = User.find_or_create_by!(email: "factory@wheels.local") do |u|
  u.name = "Sam Factory"
  u.password = "password"
end
factory_user.user_factories.find_or_create_by!(factory: factory) { |uf| uf.role = "volunteer" }

# User assigned to only the distribution center
dc_user = User.find_or_create_by!(email: "dc@wheels.local") do |u|
  u.name = "Jordan DC"
  u.password = "password"
end
dc_user.user_distribution_centers.find_or_create_by!(distribution_center: dc) { |udc| udc.role = "volunteer" }

puts "Seeded:"
puts "  admin@wheels.local / password (superadmin)"
puts "  both@wheels.local  / password (factory + distribution center)"
puts "  factory@wheels.local / password (factory only)"
puts "  dc@wheels.local    / password (distribution center only)"
