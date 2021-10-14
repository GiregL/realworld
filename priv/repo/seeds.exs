# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Realworld.Repo.insert!(%Realworld.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Realworld.{
  Repo,
  Realworld.User,
  Realworld.Article,
  Realworld.Comment,
  Realworld.Tag,
  Realworld.TagArticle
}

#
# Users
#
users = [
  %User{
    email: "awesome.user@something.net",
    password: "123456789", # Very secure
    username: "Awesome_User35",
    bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  },

  %User{
    email: "wonderful.user@something.net",
    password: "123456789", # Very secure
    username: "Wonderful_User22",
    bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  },

  %User{
    email: "classic.user@something.net",
    password: "123456789", # Very secure
    username: "Classic_User59",
    bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  },

  %User{
    email: "Shiny.user@something.net",
    password: "123456789", # Very secure
    username: "Shiny_User29",
    bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  }
]

Enum.each(users, &(Repo.insert! &1))

#
# Tags
#

tags = Enum.map(["Red", "Blue", "Yellow"], fn color -> %Tag{title: color} end)

Enum.each(tags, &(Repo.insert! &1))

#
# Articles
#

generate_article = fn user ->
  %Article{
    title: "Hello World from " <> user.username,
    body: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
    description: "Seeding this database",
    author: user.id
  }
end

articles = for user <- users do generate_article.(user) end

Enum.each(articles, &(Repo.insert! &1))

#
# Tags on articles
#

tag_articles = for article <- articles do
  %TagArticle{
    tag: Enum.random(tags).id,
    article: article.id
  }
end

Enum.each(tag_articles, &(Repo.insert! &1))

#
# Comments
#

generate_comment = fn user, article ->
  %Comment{
    body: "What an anwesome comment !",
    author: user.id,
    article: article.id
  }
end

comment_authors = for article <- articles, user <- users do generate_comment.(user, article) end

Enum.each(comment_authors, &(Repo.insert! &1))
