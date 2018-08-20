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
  f = Fan.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
  User.create(email: Faker::Internet.unique.free_email(f.first_name), username: Faker::Internet.unique.user_name,
              password: '12345678', password_confirmation: '12345678', profile_type: 'Fan', profile_id: f.id)
  puts "\nFan #{f.id} = #{f.inspect} - #{f.user.inspect}"
 set_photo("public/uploads/user/photo/#{f.user.id}/profile#{f.user.id}.jpg", f.user)
end

#artist's users
Artist.destroy_all
puts "Artists: \n"
(1..5).each do
  a = Artist.create(name: Faker::RockBand.unique.name)
  User.create(email: Faker::Internet.unique.email(a.name), username: Faker::Internet.unique.user_name,
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
    sd = Faker::Time.forward(100) if event_number.odd?
    ed = sd + Random.rand(5).hours + Random.rand(45).minutes unless sd.nil?
    e = Event.create(title: "#{event_number}#{event_number.ordinal} event", description: Faker::Lorem.paragraph, place: Faker::GameOfThrones.city,
                 start_date: (sd || Faker::Time.between(3.days.ago, 2.days.ago, :all)), end_date: (ed || (Faker::Time.between(1.days.ago, Date.today, :all))), artist: a)
    puts "\n Event #{e.id} = #{e.inspect}"
    e.fans= Fan.all.sample(Random.rand(15))
    puts "\n Event #{e.id} audience = #{e.fans.inspect}"
    set_photo("public/uploads/event/photo/#{e.id}/event#{e.id}.jpg", e)
  end
end


# possibles order's states
OrderState.delete_all
OpenState.create(name: 'Abierta', description: 'Compra sin pago efectivizado')
CloseState.create(name: 'Cerrada', description: 'Compra con pago total efectivizado')
ExpiredState.create(name: 'Expirada', description: 'Compra expirada')
