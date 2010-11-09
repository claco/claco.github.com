desc 'Generate category pages'
task :categories do
  puts "Generating categories..."
  require 'rubygems'
  require 'jekyll'
  require 'fileutils'
  include Jekyll::Filters

  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')
  remove_dir("categories")
  categories = {}

  site.categories.sort.each do |category, posts|
    categories[category] = posts[-1].to_liquid['created']
    slug = category.downcase
    path = "categories/#{slug}"
    mkpath(path)

    File.open("#{path}/index.textile", 'w+') do |file|
      file.puts "---"
      file.puts "layout: default"
      file.puts "title: \"#{category}\""
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

  File.open("categories/index.textile", "w+") do |file|
    file.puts "---"
    file.puts "layout: default"
    file.puts "title: Categories"
    file.puts "---", ""

    file.puts '<div class="index categories">'
    categories.keys.each do |category|
      slug = category.downcase
      html = ""
      html << <<-html
        <div class="category">
          <span class="created" data-created="#{categories[category]}" data-format="MM/dd/yyyy">
            #{categories[category]}
          </span> &raquo;  
          <span class="title">
            <a class="permalink" href="/categories/#{slug}/">#{category}</a>
          </span>
        </div>
      html
      file.puts html
    end
    file.puts '</div>'
  end

  puts 'Done.'
end

