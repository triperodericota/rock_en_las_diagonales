require 'faker'

def set_photo(path_file, model)
  begin
    File.open(path_file) do |file|
      model.photo = file
      puts model.photo.url
      model.save!
    end
  rescue
    puts "\n Without photo"
  end
end

# fan's users
Fan.destroy_all
puts "Fans: \n"
(1..15).each do
  f = Fan.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
  f.reload
  User.create!(email: Faker::Internet.unique.free_email(name: f.first_name), username: Faker::Internet.unique.user_name,
              password: '12345678', password_confirmation: '12345678', profile_type: 'Fan', profile_id: f.id)
  puts "\nFan #{f.id} = #{f.inspect} - #{f.user.inspect}"
 set_photo("public/uploads/user/photo/#{f.user.id}/profile#{f.user.id}.jpg", f.user)
  end

#artist's users
Artist.destroy_all
puts "Artists: \n"
(1..5).each do
  a = Artist.create!(name: Faker::Music::RockBand.unique.name)
  User.create!(email: Faker::Internet.unique.email(name: a.name), username: Faker::Internet.unique.user_name,
              password: '12345678', password_confirmation: '12345678', profile_type: 'Artist', profile_id: a.id)
  puts "\n Artist #{a.id} = #{a.inspect} - #{a.user.inspect}"
  a.fans = Fan.all.sample(Random.rand(15))
  puts "\n Artist #{a.id} followers = #{a.fans.inspect}"
  set_photo("public/uploads/user/photo/#{a.user.id}/profile#{a.user.id}.jpg", a.user)
end

#events and audiences
Event.destroy_all
puts "Events: \n"
Artist.all.each do |a|
  events_number = Random.rand(1..3)
  events_number.times do |event_number|
    sd = event_number.odd? ? Faker::Time.forward(days: 100) : Faker::Time.between(from: 3.days.ago, to: 2.days.ago)
    ed = (sd + Random.rand(5).hours) + Random.rand(45).minutes

    e = Event.create!(title: "#{event_number}#{event_number.ordinal} event", description: Faker::Lorem.paragraph, place: Faker::TvShows::GameOfThrones.city,
                 start_date: sd, end_date: ed, artist: a)
    puts "\n Event #{e.id} = #{e.inspect}"
    e.fans= Fan.all.sample(Random.rand(15))
    puts "\n Event #{e.id} audience = #{e.fans.inspect}"
    set_photo("public/uploads/event/photo/#{e.id}/event#{e.id}.jpg", e)
  end
end

# possibles order's states
OrderState.delete_all
OpenState.create!(name: 'Abierta', description: 'Compra sin pago efectivizado')
CloseState.create!(name: 'Cerrada', description: 'Compra con pago total efectivizado')
ExpiredState.create!(name: 'Expirada', description: 'Compra expirada')

# create buyer for orders
buyer = Buyer.create!(name: 'Lionel', surname: 'Messi', dni: 22522355, phone: '2215478321', email: Faker::Internet.unique.free_email(name: 'lionelm'))

# products and orders
Product.destroy_all
Order.destroy_all
Photo.destroy_all
photo_index = 1
puts "Products: \n"
Artist.all.each do |a|
  if a.id.odd?
    2.times do |product_number|
      p = Product.create!(title: "product #{a.id} - #{product_number}", description: Faker::Lorem.sentence, price: Random.rand(50.to_f...500.to_f).round(2),
                         stock: Random.rand(10...50), artist: a)
      puts "\n Product #{p.id} = #{p.inspect}"
      # set product's photos
      p.reload
      if p.id <= 3
        (p.id).times do
          photo = Photo.create!(product: p)
          photo.reload
          set_photo("public/uploads/photo/image/#{photo_index}/product-photo#{p.id}.jpg", p)
          photo_index += 1
        end
      end
      puts "\n Product #{p.id} photos = #{p.photos.inspect}"
      # set product's orders
      #if p.id.odd?
      #  order = Order.create(product: p, fan: Fan.all.sample, units: Random.rand(1...5), buyer: buyer)
      #  puts "\n Order #{order.id} for product #{p.id} = #{order.inspect}"
      #end
    end
  end
end
