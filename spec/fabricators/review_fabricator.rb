Fabricator(:review) do
  user
  video
  content { Faker::Lorem.paragraph(5) }
  rating { Faker::Number.between(1, 5) }
end