module Camt
  class File
    attr_accessor :code, :country_code, :name
    attr_accessor :doc, :ns

    delegate :errors, :to => :doc

    def self.parse file
      Camt::File.new(Nokogiri::XML(::File.read(file)))
    end

    def initialize(doc, options = {})
      self.code = options[:code] || 'CAMT'
      self.country_code = options[:country_code] || Camt.config.default_country_code || raise(ArgumentError.new("No country_code given and no default_country_code configured."))
      self.name = options[:name] || 'Generic CAMT Format'

      self.doc = doc
      self.ns = doc.namespaces['xmlns']

      check_version if valid?
    end

    def valid?
      doc.errors.empty?
    end

    def check_version
      # Sanity check the document's namespace
      raise 'This does not seem to be a CAMT format bank statement' unless ns.start_with?('urn:iso:std:iso:20022:tech:xsd:camt.')
      raise 'Only CAMT.053 is supported at the moment.' unless ns.start_with?('urn:iso:std:iso:20022:tech:xsd:camt.053.')
      return true
    end

    def messages
      @messages ||= Parser.new.parse self
    end

    def statements
      @statements ||= messages.map(&:statements).flatten
    end

    def transactions
      @transactions ||= statements.map(&:transactions).flatten
    end


    def to_s
      "#{name}: #{messages.map{|message| message.group_header.message_id }.join(', ')}"
    end

  end
end
