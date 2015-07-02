require 'rubygems'
require 'nokogiri'
require 'byebug'
require 'open-uri'
require 'colorize'



class Post
  attr_accessor :title, :url, :points, :item_id
  def initialize(title, url, points, item_id, all_comments = [])
    @title = title
    @url = url
    @points = points
    @item_id = item_id
    @all_comments = all_comments
  end
  
  def comments
    @all_comments
  end
  
  def add_comments(comment)
    case comment
    when Comment then @all_comments << comment
    else
      @all_comments << Comment.new(comment.to_s)
    end
  end

  def to_s
    "Post: #{@item_id}: #{@title}"
  end

  def self.parse(page)
    page_title = page.css("title")[0].text   # => My webpage 
    page_url = page.search('.title > a').map { |link| link["href"] }[0]
    page_points = page.search('.score').map { |score| score.inner_text}[0]
    item_id = page.search('.score').map { |id| id["id"] }[0]

    comments = page.search('.comment > font:first-child')
                   .map { |font| Comment.new(font.inner_text) }

    Post.new(page_title, page_url, page_points, item_id, comments)
  end
end


class Comment
  attr_reader :text

  def initialize(text)
    @text = text
  end

  def to_s
    "Comment: #{@text}".colorize(:light_blue ).colorize( :background => :green)
  end
end

class CustomError <StandardError
end

if ARGV.empty?
  raise CustomError, "Invalid url!"
  exit
else
  url = ARGV[0]
end



page = Nokogiri::HTML(open(url)) # https://news.ycombinator.com/item?id=7663775
post = Post.parse(page)
puts "POST:  #{post.title.colorize(:yellow)} "
puts "last comment:"
puts post.comments.last







