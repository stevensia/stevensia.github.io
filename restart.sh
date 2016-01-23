ps -fe|grep jekyll|grep -v grep |awk '{print $2}'|xargs -i kill -9 {}
echo "Killed jekyll.."
bundle exec jekyll serve &
echo Finished
exit 0
sleep 10
ps -fe|grep jekyll|grep -v grep |awk '{print $2}'|xargs -i kill -9 {}
exit 0

gem install bundler
bundle install

#Gemfile
source 'https://ruby.taobao.org'
gem 'github-pages'
