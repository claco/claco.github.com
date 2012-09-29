require "rubygems"
require "jekyll"
require "fileutils"
require "uri"
include Jekyll::Filters

@categories_dir = "categories"
@tags_dir = "tags"

desc "Run all tasks"
task :default do
  Rake::Task["clean"].invoke
  Rake::Task["categories"].invoke
  Rake::Task["tags"].invoke
  Rake::Task["build"].invoke
end

desc "Delete generated files"
task :clean do
  puts "Deleting generated files..."
  system "rm -fR _site"
  system "rm -fR #{@categories_dir}"
  system "rm -fR #{@tags_dir}"
end

desc "Build the website"
task :build do
  puts "Generating website..."
  system "jekyll"
end

desc "Generate category pages"
task :categories do
  puts "Generating categories..."

  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')
  remove_dir(@categories_dir) if File.directory? @categories_dir
  categories = {}

  site.categories.sort{|x,y| x.to_s <=> y.to_s }.each do |category, posts|
    categories[category] = posts[-1].to_liquid["created"]
    slug = category.to_s.downcase
    path = "#{@categories_dir}/#{slug}"
    mkpath(path, :verbose => false)

    File.open("#{path}/index.textile", 'w+') do |file|
      file.puts "---"
      file.puts "layout: default"
      file.puts "title: \"Category: #{category}\""
      file.puts "---", ""
      file.puts '<div class="index posts">'

      posts.reverse.each do |post|
        post_data = post.to_liquid

        html = ""
        html << <<-html
        <div class="post">
          <span class="created" data-created="#{post_data['created']}" data-format="MM/dd/yyyy">
            {{ #{post_data['created']} | date: "%Y-%m-%dT%H:%M:%S%z" }}
          </span> &raquo;  
          <span class="title">
            <a class="permalink" href="#{post.permalink || post.url}/">#{post_data['title']}</a>
          </span>
        </div>
        html
        file.puts html
      end      
    end
  end

  File.open("#{@categories_dir}/index.textile", "w+") do |file|
    file.puts "---"
    file.puts "layout: default"
    file.puts "title: Categories"
    file.puts "---", ""

    file.puts '<div class="index categories">'
    categories.keys.each do |category|
      slug = category.to_s.downcase
      html = ""
      html << <<-html
        <div class="category">
          <span class="created" data-created="#{categories[category]}" data-format="MM/dd/yyyy">
            #{categories[category]}
          </span> &raquo;  
          <span class="title">
            <a class="permalink" href="/categories/#{URI.escape(slug)}/">#{category}</a>
          </span>
        </div>
      html
      file.puts html
    end
    file.puts '</div>'
  end

  puts 'Done.'
end

desc 'Generate tag pages'
task :tags do
  puts "Generating tags..."

  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')
  remove_dir(@tags_dir) if File.directory? @tags_dir
  tags = {}

  site.tags.sort{|x,y| x.to_s <=> y.to_s }.each do |tag, posts|
    tags[tag] = posts[-1].to_liquid['created']
    slug = tag.to_s.downcase
    path = "#{@tags_dir}/#{slug}"
    mkpath(path, :verbose => false)

    File.open("#{path}/index.textile", 'w+') do |file|
      file.puts "---"
      file.puts "layout: default"
      file.puts "title: \"Tag: #{tag}\""
      file.puts "---", ""
      file.puts '<div class="index posts">'

      posts.reverse.each do |post|
        post_data = post.to_liquid

        html = ""
        html << <<-html
        <div class="post">
          <span class="created" data-created="#{post_data['created']}" data-format="MM/dd/yyyy">
            {{ #{post_data['created']} | date: "%Y-%m-%dT%H:%M:%S%z" }}
          </span> &raquo;  
          <span class="title">
            <a class="permalink" href="#{post.url}/">#{post_data['title']}</a>
          </span>
        </div>
        html
        file.puts html
      end      
    end
  end

  File.open("#{@tags_dir}/index.textile", "w+") do |file|
    file.puts "---"
    file.puts "layout: default"
    file.puts "title: Tags"
    file.puts "---", ""

    file.puts '<div class="index tags">'
    tags.keys.each do |tag|
      slug = tag.to_s.downcase
      html = ""
      html << <<-html
        <div class="tag">
          <span class="created" data-created="#{tags[tag]}" data-format="MM/dd/yyyy">
            #{tags[tag]}
          </span> &raquo;  
          <span class="title">
            <a class="permalink" href="/tags/#{URI.escape(slug)}/">#{tag}</a>
          </span>
        </div>
      html
      file.puts html
    end
    file.puts '</div>'
  end

  puts 'Done.'
end


