require "rubygems"
require "mysql"
require(File.dirname(__FILE__)+"/typo3")

typo3 = Typo3.new

desc "Clear TYPO3 Caches"
namespace "cc" do
  desc "Clear All Caches"
  task :all => [:pages,:temp] do
  end
  
  desc "Clear only Page Caches"
  task :pages do
    typo3.with_db do |db|
      db.query('delete from cache_pagesection')
      db.query('delete from cache_hash')
    end
  end
  
  desc "Clear only temp_CACHED"
  task :temp do
    TEMP = FileList['**/temp_CACHED*.php']
    rm TEMP
  end
end

namespace "typo3" do
  task :config do
    typo3.show_config
  end
end

