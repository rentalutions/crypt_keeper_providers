require 'crypt_keeper_providers/mysql_aes/log_subscriber'

module CryptKeeperProviders
  class MysqlAes
    attr_accessor :key

    # Public: Initializes the encryptor
    #
    #  options - A hash, :key is required
    def initialize(options = {})
      @key = options.fetch(:key) do
        raise ArgumentError, "Missing :key"
      end
    end

    # Public: Encrypts a string
    #
    # Returns an encrypted string
    def encrypt(value)
      escape_and_execute_sql(["SELECT AES_ENCRYPT(?, ?)", value, key]).first
    end

    # Public: Decrypts a string
    #
    # Returns a plaintext string
    def decrypt(value)
      escape_and_execute_sql(["SELECT AES_DECRYPT(?, ?)", value, key]).first
    end

    private

    # Private: Sanitize an sql query and then execute it
    def escape_and_execute_sql(query)
      query = ::ActiveRecord::Base.send :sanitize_sql_array, query
      ::ActiveRecord::Base.connection.execute(query).first
    end
  end
end
