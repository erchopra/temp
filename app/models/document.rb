# == Schema Information
#
# Table name: documents
#
#  id             :integer          not null, primary key
#  document_type  :string(255)
#  recipient      :string(255)
#  total          :string(255)
#  event_id       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  status         :string(255)
#  name           :string(255)
#  full_file_name :string(255)
#  creator_id     :integer
#

include ActionView::Helpers::NumberHelper

class Document < ActiveRecord::Base
  belongs_to :event
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id', validate: true

  default_scope order 'created_at'


  def self.create_event_document options={}
    party_type, party_id, doc_type, event_id, document_id = options.values_at("party_type", "party", "doc_type", "id", "document_id")
    party = party_type.constantize.find_by_id(party_id)
    event = Event.find(event_id)
    template_path = File.join(Rails.root, 'app', 'views', 'documents', 'templates', "#{doc_type}.html.haml")
    full_document_name = document_file_name(event, doc_type)
    short_document_name = document_file_name(event)

    document_html = render_document template_path, document_id, short_document_name, event, party
    document_pdf = DocRaptor::build_pdf document_html, full_document_name
    AWS::private_write document_pdf, full_document_name

    if DocumentType::Event::invoice == doc_type
      document_total = event.revenue_total_by_party(party, true, document_id).to_s
    elsif DocumentType::Event::account_documents.include? doc_type
      document_total = event.revenue_total_by_party(party).to_s
    elsif DocumentType::Event::vendor_documents.include? doc_type
      document_total = event.expense_total_by_party(party).to_s
    else 
      0
    end

    document_created document_id, full_document_name, short_document_name, document_total
  end

  def self.create_vendor_billing_summary_document options={}

    # Template inputs
    @date, event_vendor_list = options.values_at("date", "event_vendor_list")
    @vendor = Vendor.find(event_vendor_list.first.vendor_id)
    @events = event_vendor_list.map{|ev| ev.event}
    
    # Find the template
    template_path = File.join(Rails.root, 'app', 'views', 'documents', 'templates', "vendor_billing_summary.html.haml")

    # Document Title
    @document_number = "Vendor-Billing-Summary-#{@vendor.id.to_s.rjust(6, "0")}-#{@date.strftime('%Y%m%d')}.pdf"
      
    # Generate the PDF, and push to AWS
    document_html = Haml::Engine.new(IO.read(template_path)).render(binding)
    document_pdf = DocRaptor::build_pdf document_html, @document_number
    AWS::private_write document_pdf, @document_number
    {"document_pdf"=>document_pdf, "document_name"=>@document_number}
  end

  private
    # Update the document table after a document have been generated (docraptor) and saved (aws).
    def self.document_created document_id, document_name, short_document_name, document_total
      document = Document.find document_id

      document.status = DocumentStatus::created
      document.total = document_total
      document.name = short_document_name
      document.full_file_name = document_name

      document.save
    end

    def self.document_file_name event, doc_type=nil
      count = event.documents.count
      if doc_type.nil?
        "#{event.pretty_id}-#{count}"
      else
        "#{doc_type.titleize}-#{event.pretty_id}-#{count}.pdf"
      end
    end

    def self.pretty_bool var
      var ? "Yes" : "No"
    end

    # Read a HAML file from disk and render the ruby instance into valid html.
    def self.render_document template_path, document_id, document_name, event, party
      @event = event
      @party = party
      @include_menu_items = true
      @document_name = document_name
      @document_id = document_id
      
      Haml::Engine.new(IO.read(template_path)).render(binding)
    end
end

