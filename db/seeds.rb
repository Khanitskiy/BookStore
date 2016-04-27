# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# create first admin user
User.delete_all
User.create(email: "admin@gmail.com", password: "adminadmin", firstname: "Admin", lastname: "Adminovitch", admin: true)

Book.delete_all
Book.create(title: "The Rspec Book", 
						description: "Behaviour-Driven Development (BDD) gives you the best of Test Driven Development, Domain Driven Design, and Acceptance Test Driven Planning techniques, so you can create better software with self-documenting, executable tests that bring users and developers together with a common language.
													Get the most out of BDD in Ruby with The RSpec Book, written by the lead developer of RSpec, David Chelimsky.
													You'll get started right away with RSpec 2 and Cucumber by developing a simple game, using Cucumber to express high-level requirements in language your customer understands, and RSpec to express more granular requirements that focus on the behavior of individual objects in the system. You'll learn how to use test doubles (mocks and stubs) to control the environment and focus the RSpec examples on one object at a time, and how to customize RSpec to \"speak\" in the language of your domain.",
					  price: 17.6, in_stock: 228, image: "image/upload/v1456929470/nxsdvwadmqzuoxde4orl.png", order_counter: 25, best_seller: true)

Book.create(title: "The Ruby On Rails Tutorial", 
						description: "The Ruby on Rails Tutorial book and screencast series teach you how to develop and deploy real, industrial-strength web applications with Ruby on Rails, the open-source web framework that powers top websites such as Twitter, Hulu, GitHub, and the Yellow Pages. The Ruby on Rails Tutorial book is available for free online and is available for purchase as an ebook (PDF, EPUB, and MOBI formats). The companion screencast series includes 12 individual lessons, one for each chapter of the Ruby on Rails Tutorial book. All purchases also include a free copy of the Solutions Manual for Exercises, with solutions to every exercise in the book.",
					  price: 20.0, in_stock: 128, order_counter: 64, image: "image/upload/v1456929844/kndu8ixylvrlnl6upcyz.png", best_seller: true)

Book.create(title: "The Ruby Programming Language", 
						description: "The Ruby Programming Language is the authoritative guide to Ruby and provides comprehensive coverage of versions 1.8 and 1.9 of the language. It was written (and illustrated!) by an all-star team    David Flanagan, bestselling author of programming language \"bibles\" (including JavaScript: The Definitive Guide and Java in a Nutshell) and committer to the Ruby Subversion repository.
													Yukihiro \"Matz\" Matsumoto, creator, designer and lead developer of Ruby and author of Ruby in a Nutshell, which has been expanded and revised to become this book.
													why the lucky stiff, artist and Ruby programmer extraordinaire.",
					  price: 32.6, in_stock: 328, order_counter: 48, image: "image/upload/v1456929904/rtkkcjwiekw007uzl3ys.png", best_seller: true)

@order = Order.new()
@order_items = OrderItem.new()
@cookies_book = { "book_count" => "0", "total_price" => "0"}
order_id = @order.create_order(@cookies_book, 0,  1)
@order_items.create_items(@cookies_book, order_id)

Cupon.create(value: 'asdasdasd')
Cupon.create(value: 'Sk8fS0F23')
Cupon.create(value: 'J3fS03fDs')
Cupon.create(value: '23Lss02Fw')
Cupon.create(value: 'KdGn39n3v')
Cupon.create(value: 'Fskf9D2mf', discount: 10)
Cupon.create(value: '9fSk3k2nv', discount: 10)
Cupon.create(value: 'Ls02nFsd1', discount: 10)
Cupon.create(value: 'KJsfne30v', discount: 20)
Cupon.create(value: 'Anutochka', discount: 20)
