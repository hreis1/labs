require 'spec_helper'

RSpec.describe Database do
  describe '.connect' do
    it 'retorna uma conexão com o banco de dados' do
      connection = Database.connection

      expect(connection).to be_a PG::Connection
    end

    it 'e a conexão é a mesma em chamadas subsequentes' do
      connection = Database.connection

      expect(Database.connection).to eq connection
    end
  end
end
