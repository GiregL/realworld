defmodule Realworld.Articles.ArticleCreationTest do
  use ExUnit.Case

  alias Realworld.Articles.Article
  import Realworld.Articles.ArticleCreation

  describe "create_article_from_params/1 - Missing required arguments" do
    test "Missing title, returns an error" do
      params = %{
        "description" => "Hello World article",
        "body" => "Hi there"
      }
      article = create_article_from_params(params)
      assert match?({:error, _}, article)
    end

    test "Missing description, returns an error" do
      params = %{
        "title" => "Papaye",
        "body" => "It's a fruit"
      }
      article = create_article_from_params(params)
      assert match?({:error, _}, article)
    end

    test "Missing body, returns an error" do
      params = %{
        "title" => "Dog",
        "description" => "It's a dog."
      }
      article = create_article_from_params(params)
      assert match?({:error, _}, article)
    end
  end

  describe "create_article_from_params/1 - No optional argument" do
    test "No optional arguments, success" do
      params = %{
        "title" => "Cat",
        "description" => "Cat article",
        "body" => "Cats everywhere"
      }
      article = create_article_from_params(params)
      assert match?({:ok, _}, article)
    end

    test "No optional arguments, right values set" do
      params = %{
        "title" => "Cat",
        "description" => "Cat article",
        "body" => "Cats everywhere"
      }
      {:ok, article} = create_article_from_params(params)
      assert article == %Article{title: "Cat", description: "Cat article", body: "Cats everywhere"}
    end
  end

  describe "slug creation" do
    test "slug from simple word" do
      res = create_slug_from_title("hello")
      assert res == "hello"
    end

    test "slug from two words" do
      res = create_slug_from_title("Hello World")
      assert res == "hello-world"
    end
  end
end
