Fabricator(:video) do
  title { Faker::Lorem.word }
  description { Faker::Lorem.paragraph(2) }
end