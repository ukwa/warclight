# frozen_string_literal: true

require 'warclight'
require 'benchmark'

##
# Environment variables for indexing:
#
# REPOSITORY_ID for the repository id/slug to load repository data from
# your configuration (default: none).
#
# REPOSITORY_FILE for the YAML file of your repository configuration
# (default: config/repositories.yml).
#
# SOLR_URL for the location of your Solr instance
# (default: http://127.0.0.1:8983/solr/warclight)
#
namespace :warclight do
  desc 'Index a warc, use FILE=<path/to/warc.gz>'
  task :index do
    raise 'Please specify your warc, ex. FILE=<path/to/warc.gz>' unless ENV['FILE']
    indexer = load_indexer
    print "Loading #{ENV['FILE']} into index...\n"
    elapsed_time = Benchmark.realtime { indexer.update(ENV['FILE']) }
    print "Indexed #{ENV['FILE']} (in #{elapsed_time.round(3)} secs).\n"
  end

  desc 'Index a directory of warcs, use DIR=<path/to/directory>'
  task :index_dir do
    raise 'Please specify your directory, ex. DIR=<path/to/directory>' unless ENV['DIR']
    Dir.glob(File.join(ENV['DIR'], '*.gz')).each do |file|
      system("rake warclight:index FILE=#{file}")
    end
  end

  desc 'Destroy all documents in the index'
  task :destroy_index_docs do
    puts 'Deleting all documents from index...'
    indexer = load_indexer
    indexer.delete_all
  end
end

def load_indexer
  # hardcoded since we don't have access to Blacklight.connection_config[:url] here
  ENV['SOLR_URL'] ||= 'http://127.0.0.1:8983/solr/warclight'

  options = {
    document: Warclight::CustomDocument,
    component: Warclight::CustomComponent
  }

  Warclight::Indexer.new(options)
end