require 'sidekiq'
require './lib/import'

class ImportJob
  include Sidekiq::Job

  def perform(csv)
    import_from_csv(csv:)
  end
end
