# Generate Event Documents (Quote, Invoice, Purchas Order & Packing Slip)

module EventDocument
  @queue = :event_documents

  def self.perform options={}
    Document.create_event_document options
    Rails.logger.info "Create #{options[:doc_type]} for #{options[:party]}: #{options[:party_id]} and event: #{options[:id]}. 
    Lock items from Document ID: #{options[:document_id]}."
  end
end