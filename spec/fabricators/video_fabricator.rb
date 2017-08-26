Fabricator(:video) do
  title { Faker::Lorem.word }
  description { Faker::Lorem.paragraph(2) }
  category_id [1, 2, 3].sample
end