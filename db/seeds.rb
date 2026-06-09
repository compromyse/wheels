admin = User.find_or_create_by!(email: "admin@wheels.local") do |u|
  u.name = "Admin"
  u.password = "password"
  u.superadmin = true
end

production = Production.find_or_create_by!(name: "Main Production")
dist = Distribution.find_or_create_by!(name: "Downtown Distribution")

# User assigned to both a production and a distribution
both = User.find_or_create_by!(email: "both@wheels.local") do |u|
  u.name = "Alex Both"
  u.password = "password"
end
both.user_productions.find_or_create_by!(production: production) { |up| up.role = "volunteer" }
both.user_distributions.find_or_create_by!(distribution: dist) { |ud| ud.role = "volunteer" }

# User assigned to only the production
production_user = User.find_or_create_by!(email: "production@wheels.local") do |u|
  u.name = "Sam Production"
  u.password = "password"
end
production_user.user_productions.find_or_create_by!(production: production) { |up| up.role = "volunteer" }

# User assigned to only the distribution
dist_user = User.find_or_create_by!(email: "dist@wheels.local") do |u|
  u.name = "Jordan Dist"
  u.password = "password"
end
dist_user.user_distributions.find_or_create_by!(distribution: dist) { |ud| ud.role = "volunteer" }

puts "Seeded:"
puts "  admin@wheels.local / password (superadmin)"
puts "  both@wheels.local  / password (production + distribution)"
puts "  production@wheels.local / password (production only)"
puts "  dist@wheels.local    / password (distribution only)"
