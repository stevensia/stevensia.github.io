ps -fe|grep jekyll|grep -v grep |awk '{print $2}'|xargs -i kill -9 {}
echo "Killed jekyll.."
bundle exec jekyll serve &
echo Finished

