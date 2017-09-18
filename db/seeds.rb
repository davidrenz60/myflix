mr_robot_desc = "Young, anti-social computer programmer Elliot works as a cybersecurity engineer during the day, but at night he is a vigilante hacker. He is recruited by the mysterious leader of an underground group of hackers to join their organization. Elliot's task? Help bring down corporate America, including the company he is paid to protect, which presents him with a moral dilemma."

house_of_cards_desc = "U.S. Rep. Francis Underwood of South Carolina starts out as a ruthless politician seeking revenge in this Netflix original production."
better_call_saul_desc = "He wasn't always Saul Goodman, ace attorney for chemist-turned-meth dealer Walter White. Six years before he begins to represent Albuquerque's most notorious criminal, Goodman is Jimmy McGill, a small-time attorney hustling to make a name for himself."

family_guy_desc = "Sick, twisted and politically incorrect, the animated series features the adventures of the Griffin family. Endearingly ignorant Peter and his stay-at-home wife Lois reside in Quahog, R.I., and have three kids."

westworld_desc = "Westworld isn't your typical amusement park. Intended for rich vacationers, the futuristic park -- which is looked after by robotic \"hosts\" -- allows its visitors to live out their fantasies through artificial consciousness."

monk_desc = "After the unsolved murder of his wife, Adrian Monk develops obsessive-compulsive disorder, which includes his terror of germs and contamination. His condition costs him his job as a prominent homicide detective in the San Francisco Police Department, but he continues to solve crimes with the help of his assistant and his former boss."

breaking_bad_desc = "Mild-mannered high school chemistry teacher Walter White thinks his life can't get much worse. His salary barely makes ends meet, a situation not likely to improve once his pregnant wife gives birth, and their teenage son is battling cerebral palsy. But Walter is dumbstruck when he learns he has terminal cancer. Realizing that his illness probably will ruin his family financially, Walter makes a desperate bid to earn as much money as he can in the time he has left by turning an old RV into a meth lab on wheels."

futurama_desc = "Accidentally frozen, pizza-deliverer Fry wakes up 1,000 years in the future. He is taken in by his sole descendant, an elderly and addled scientist who owns a small cargo delivery service."

south_park_desc = "Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado."

lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec lectus odio, vulputate et scelerisque in, lacinia quis sem. Donec tempor dictum ipsum, a rhoncus neque. Nulla facilisi. Integer euismod nunc ut quam fermentum, sit amet cursus erat dictum. Integer eget nulla nisi. Fusce non scelerisque felis, sed gravida neque. Mauris arcu odio, luctus eget augue ut, imperdiet sollicitudin velit. Phasellus ante enim, interdum et turpis quis, interdum accumsan erat. Cras viverra lobortis vehicula. Integer justo ipsum, ultrices quis malesuada nec, pulvinar sed leo. Aenean euismod nisl urna, quis eleifend metus ultrices sodales. Duis at nunc suscipit, condimentum est at, imperdiet dolor."

comedy = Category.create(name: "Comedy")
scifi = Category.create(name: "Sci Fi")
drama = Category.create(name: "Drama")

mr_robot = Video.create(title: "Mr. Robot", description: mr_robot_desc, small_cover_url: "/tmp/mr_robot.jpg", large_cover_url: "/tmp/mr_robot_large.jpg", category: scifi)
Video.create(title: "Westworld", description: westworld_desc, small_cover_url: "/tmp/westworld.jpg", large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category: scifi)

Video.create(title: "House of Cards", description: house_of_cards_desc, small_cover_url: "/tmp/house_of_cards.jpg", large_cover_url: "/tmp/house_of_cards_large.jpg", category: drama)
Video.create(title: "Breaking Bad", description: breaking_bad_desc, small_cover_url: "/tmp/breaking_bad.jpg", large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category: drama)

Video.create(title: "Better Call Saul", description: better_call_saul_desc, small_cover_url: "/tmp/better_call_saul.jpg", large_cover_url: "/tmp/better_call_saul_large.jpg", category: comedy)
Video.create(title: "Better Call Saul", description: better_call_saul_desc, small_cover_url: "/tmp/better_call_saul.jpg", large_cover_url: "/tmp/better_call_saul_large.jpg", category: comedy)
Video.create(title: "Family Guy", description: family_guy_desc, small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category: comedy)
Video.create(title: "Family Guy", description: family_guy_desc, small_cover_url: "/tmp/family_guy.jpg", large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category: comedy)
Video.create(title: "Monk", description: monk_desc, small_cover_url: "/tmp/monk.jpg", large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category: comedy)
Video.create(title: "Futurama", description: futurama_desc, small_cover_url: "/tmp/futurama.jpg", large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category: comedy)
Video.create(title: "South Park", description: south_park_desc, small_cover_url: "/tmp/south_park.jpg", large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff", category: comedy)

dave = User.create(email: "dave@test.com", password: "dave", full_name: "Dave Renz")
joe = User.create(email: "joe@test.com", password: "joe", full_name: "Joe Smith")

Review.create(rating: 2, content: lorem, user: dave, video: mr_robot)
Review.create(rating: 4, content: lorem, user: joe, video: mr_robot)
