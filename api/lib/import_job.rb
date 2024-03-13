require 'sidekiq'
require './lib/import'

class ImportJob
  include Sidekiq::Job

  def perform(csv)
    Import.import_from_csv(csv:)
  end
end
