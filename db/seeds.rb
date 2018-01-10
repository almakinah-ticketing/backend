# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

7.times do
    # Admin.create({
    #     f_name: Faker::Name.first_name,
    #     l_name: Faker::Name.last_name,
    #     email: Faker::Internet.email,
    #     phone_number: Faker::PhoneNumber.cell_phone,
    #     password:"123456789"
    # });
    # Attendee.create({
    #     f_name: Faker::Name.first_name,
    #     l_name: Faker::Name.last_name,
    #     email: Faker::Internet.email,
    #     phone_number: Faker::PhoneNumber.cell_phone,
    #     password:"123456789"
    # });
    category = Category.create!({
        name: Faker::ProgrammingLanguage.unique.name[0...20],
        img: Faker::LoremPixel.image
    });
    event = Event.create!({
        title: Faker::Company.unique.name[0...200],
        overview: Faker::Lorem.sentences,
        agenda: Faker::Lorem.sentences,
        event_date: "2018-01-11",
        start_datetime:Faker::Time.between(Date.tomorrow, Date.tomorrow, :morning),
        end_datetime:Faker::Time.between(Date.tomorrow, Date.tomorrow, :evening),
        category_id: category.id,
        img: Faker::LoremPixel.image
    });
    # Ticket.create!({
    #     attendee_id: Faker::Number.between(1, 7),
    #     type_id: Faker::Number.between(1, 7),
    #     event_id:Faker::Number.between(1, 7)
    # });
    Type.create!({
        name: Faker::Company.unique.type[0...20],
        price: Faker::Number.positive,
        capacity: Faker::Number.number(3),
        group_ticket_no: "1",
        event_id: event.id
    });
end
# 50.times do
#     Ticket.create({
#         attendee_id: Faker::Number.between(1, 5),
#         type_id: Faker::Number.between(1, 5),
#         event_id:Faker::Number.between(1, 5)
#     })
# end