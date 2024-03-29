if Post.find().count() is 0
  u1 = Accounts.createUser
    username: 'ptb'
    profile:
      firstName: 'Peter'
      lastName: 'Brown'
    email: 'p@ptb.io'
    password: 'password'

  u2 = Accounts.createUser
    username: 'rhienn'
    profile:
      firstName: 'Rhienn'
      lastName: 'Davis'
    email: 'rhienn@pathable.com'
    password: 'password'

  u3 = Accounts.createUser
    username: 'ryans'
    profile:
      firstName: 'Ryan'
      lastName: 'Stouzer'
    email: 'rs@ptb.io'
    password: 'password'

  p1 = Post.create
    userId: u1
    title: 'Introducing telescope'
    url: 'http://sachagreif.com/introducing-telescope/'
    commentsCount: 1

  Subscription.create
    postId: p1.id
    userId: u1

  Comment.create
    comment: "I love this site."
    userId: u1
    postId: p1.id

  p2 = Post.create
    title: 'Make apps faster: Meteor'
    userId: u1
    url: 'http://meteor.com'

  Subscription.create
    postId: p2.id
    userId: u2

  p3 = Post.create
    title: 'Educate yourself!! This book will teach you how to make long sentences.'
    userId: u2
    url: 'http://themeteorbook.com'

  Subscription.create
    postId: p3.id
    userId: u3
