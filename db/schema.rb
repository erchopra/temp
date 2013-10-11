# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130702203025) do

  create_table "account_pricing_tiers", :force => true do |t|
    t.string   "product"
    t.integer  "account_id"
    t.integer  "pricing_tier_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "website"
    t.string   "account_type"
    t.boolean  "active"
    t.integer  "address_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "account_exec_id"
    t.integer  "sales_rep_id"
    t.integer  "account_manager_id"
  end

  create_table "accounts_buildings", :id => false, :force => true do |t|
    t.integer "account_id"
    t.integer "building_id"
  end

  create_table "addresses", :force => true do |t|
    t.string "name"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "country"
  end

  create_table "assets", :force => true do |t|
    t.string   "description"
    t.string   "resource_file_name"
    t.string   "resource_content_type"
    t.integer  "resource_file_size"
    t.datetime "resource_updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
  end

  create_table "billing_references", :force => true do |t|
    t.integer "account_id"
    t.string  "name"
    t.integer "event_id"
  end

  create_table "buildings", :force => true do |t|
    t.string  "name"
    t.boolean "insurance_required"
    t.string  "insurance_requirements", :limit => 1000
    t.string  "parking_information",    :limit => 1000
    t.string  "loading_information",    :limit => 1000
    t.string  "site_directions",        :limit => 1000
    t.integer "market_id"
    t.integer "address_id"
    t.string  "contact_title"
    t.string  "contact_name"
    t.string  "contact_phone"
    t.string  "contact_cell"
    t.string  "contact_fax"
    t.string  "contact_email"
    t.string  "timezone"
  end

  create_table "comments", :force => true do |t|
    t.text     "description"
    t.integer  "issue_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "comments", ["issue_id"], :name => "index_comments_on_issue_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "position"
    t.string   "email"
    t.string   "phone_number"
    t.string   "mobile_number"
    t.string   "fax_number"
    t.boolean  "primary_contact"
    t.boolean  "billing_notifications"
    t.boolean  "event_notifications"
    t.boolean  "sms"
    t.integer  "account_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "vendor_id"
  end

  create_table "documents", :force => true do |t|
    t.string   "document_type"
    t.string   "recipient"
    t.string   "total"
    t.integer  "event_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "status"
    t.string   "name"
    t.string   "full_file_name"
    t.integer  "creator_id"
  end

  create_table "emails", :force => true do |t|
    t.string   "email"
    t.string   "email_list"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_managed_services_rollups", :force => true do |t|
    t.integer  "revenue_cents"
    t.integer  "cogs_cents"
    t.integer  "delivery_charge_to_vendor_cents"
    t.integer  "total_billing_cents"
    t.integer  "total_tax_cents"
    t.integer  "subtotal_cents"
    t.integer  "gratuity_cents"
    t.integer  "enterprise_fee_cents"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "event_transaction_methods", :force => true do |t|
    t.string "transaction_method"
    t.string "info1"
    t.string "info2"
  end

  create_table "event_vendors", :force => true do |t|
    t.integer  "event_id"
    t.integer  "vendor_id"
    t.integer  "participation"
    t.integer  "menu_template_id"
    t.string   "pricing_type"
    t.boolean  "white_label_fooda",               :default => false, :null => false
    t.integer  "default_menu_cogs_cents"
    t.integer  "default_menu_sell_price_cents"
    t.integer  "default_menu_retail_price_cents"
    t.text     "external_vendor_notes"
    t.integer  "event_transaction_method_id"
    t.datetime "vendor_billing_summary_sent_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "meal_period"
    t.integer  "account_id"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.integer  "quantity"
    t.string   "product",                          :limit => 30
    t.string   "menu_name"
    t.string   "status"
    t.integer  "contact_id"
    t.string   "service_style"
    t.boolean  "individual_label"
    t.boolean  "utensils_plates_napkins"
    t.boolean  "serving_utensils"
    t.boolean  "sternos"
    t.boolean  "chaffing_frames"
    t.text     "internal_event_notes"
    t.text     "external_account_notes"
    t.text     "building_instructions"
    t.text     "location_instructions"
    t.integer  "location_id"
    t.integer  "event_transaction_method_id"
    t.datetime "event_start_time"
    t.datetime "event_end_time"
    t.datetime "setup_start_time"
    t.datetime "setup_end_time"
    t.integer  "created_by_id"
    t.datetime "event_start_time_utc"
    t.datetime "event_end_time_utc"
    t.datetime "setup_start_time_utc"
    t.datetime "setup_end_time_utc"
    t.integer  "event_managed_services_rollup_id"
    t.string   "cancellation_reason"
    t.boolean  "canceled_within_24_hours",                       :default => false, :null => false
  end

  create_table "inventory_item_product_types", :force => true do |t|
    t.integer "inventory_item_id"
    t.string  "product_type",      :limit => 20
  end

  create_table "inventory_items", :force => true do |t|
    t.string   "name_vendor"
    t.text     "description"
    t.string   "sku"
    t.boolean  "featured"
    t.string   "type"
    t.string   "image"
    t.integer  "vendor_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "meal_type",          :limit => 20
    t.integer  "cogs_cents"
    t.integer  "perks_price_cents"
    t.integer  "retail_price_cents"
    t.string   "name_public"
  end

  create_table "issues", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "priority"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "assignee_id"
    t.integer  "assigner_id"
    t.datetime "open_date"
    t.datetime "due_date"
    t.boolean  "status",       :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "line_item_types", :force => true do |t|
    t.string   "line_item_type"
    t.string   "line_item_sub_type"
    t.string   "sku"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "line_items", :force => true do |t|
    t.string  "line_item_type"
    t.string  "sku"
    t.string  "name"
    t.text    "notes"
    t.integer "quantity"
    t.boolean "include_price_in_expense"
    t.boolean "include_price_in_revenue"
    t.integer "event_id"
    t.integer "inventory_item_id"
    t.string  "billable_party_type"
    t.integer "billable_party_id"
    t.string  "payable_party_type"
    t.integer "payable_party_id"
    t.decimal "tax_rate_expense"
    t.decimal "tax_rate_revenue"
    t.string  "line_item_sub_type"
    t.boolean "after_subtotal"
    t.boolean "percentage_of_subtotal"
    t.integer "document_id"
    t.integer "unit_price_expense_cents"
    t.integer "unit_price_revenue_cents"
    t.integer "parent_id"
    t.integer "menu_template_id"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "location_type"
    t.integer  "expected_participation"
    t.string   "privacy"
    t.text     "service_event_instructions"
    t.text     "connectivity_instructions"
    t.text     "delivery_event_instructions"
    t.string   "building_address_notes"
    t.integer  "contact_id"
    t.integer  "account_id"
    t.integer  "building_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "markets", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.decimal  "default_tax_rate", :default => 10.5, :null => false
  end

  create_table "menu_level_discounts", :force => true do |t|
    t.integer "min_participation"
    t.integer "menu_template_id"
    t.integer "event_vendor_id"
    t.integer "cogs_cents"
    t.integer "sell_price_cents"
    t.integer "retail_price_cents"
  end

  create_table "menu_template_groups", :force => true do |t|
    t.integer  "menu_template_id"
    t.integer  "choices_to_select"
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "menu_template_inventory_items", :force => true do |t|
    t.integer  "inventory_item_id"
    t.integer  "menu_template_id"
    t.integer  "menu_template_group_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "menu_templates", :force => true do |t|
    t.string   "name"
    t.string   "pricing_type"
    t.date     "expiration_date"
    t.date     "start_date",                                          :null => false
    t.integer  "vendor_id"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "product_type",       :limit => 20
    t.integer  "cogs_cents"
    t.integer  "sell_price_cents"
    t.integer  "retail_price_cents"
    t.boolean  "expires"
    t.boolean  "all_items",                        :default => false, :null => false
  end

  create_table "options", :force => true do |t|
    t.string   "name"
    t.integer  "inventory_item_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "preferences", :force => true do |t|
    t.string   "preference_type"
    t.integer  "vendor_id"
    t.string   "cuisine"
    t.text     "disposition"
    t.integer  "account_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "pricing_tiers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.decimal  "gross_profit"
  end

  create_table "profiles", :force => true do |t|
    t.integer "user_id"
  end

  create_table "ssp_persistences", :force => true do |t|
    t.string  "ssp_persistence_type"
    t.string  "name"
    t.text    "parameters"
    t.boolean "locked",               :default => false, :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "role"
    t.string   "username",               :limit => 40
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vendor_product_types", :force => true do |t|
    t.integer "vendor_id"
    t.string  "product_type", :limit => 20
    t.string  "status",                     :default => "inactive"
  end

  create_table "vendor_products", :force => true do |t|
    t.string  "product",      :limit => 30
    t.integer "vendor_id"
    t.string  "product_type", :limit => 20
  end

  create_table "vendors", :force => true do |t|
    t.string   "name"
    t.string   "legal_name"
    t.string   "description"
    t.string   "website"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.decimal  "default_tax_rate",   :default => 0.0, :null => false
    t.integer  "address_id"
    t.integer  "vendor_manager_id"
  end

  add_foreign_key "account_pricing_tiers", "accounts", :name => "account_pricing_tiers_account_id_fk"
  add_foreign_key "account_pricing_tiers", "pricing_tiers", :name => "account_pricing_tiers_pricing_tier_id_fk"

  add_foreign_key "accounts", "addresses", :name => "accounts_address_id_fk"
  add_foreign_key "accounts", "users", :name => "accounts_sales_rep_id_fk", :column => "sales_rep_id"

  add_foreign_key "accounts_buildings", "accounts", :name => "accounts_buildings_account_id_fk"
  add_foreign_key "accounts_buildings", "buildings", :name => "accounts_buildings_building_id_fk"

  add_foreign_key "billing_references", "accounts", :name => "billing_references_account_id_fk"
  add_foreign_key "billing_references", "events", :name => "billing_references_event_id_fk"

  add_foreign_key "buildings", "addresses", :name => "buildings_address_id_fk"
  add_foreign_key "buildings", "markets", :name => "buildings_market_id_fk"

  add_foreign_key "contacts", "accounts", :name => "contacts_account_id_fk"
  add_foreign_key "contacts", "vendors", :name => "contacts_vendor_id_fk"

  add_foreign_key "documents", "events", :name => "documents_event_id_fk"
  add_foreign_key "documents", "users", :name => "documents_creator_id_fk", :column => "creator_id"

  add_foreign_key "event_vendors", "event_transaction_methods", :name => "event_vendors_event_transaction_method_id_fk"
  add_foreign_key "event_vendors", "events", :name => "event_vendors_event_id_fk"
  add_foreign_key "event_vendors", "menu_templates", :name => "event_vendors_menu_template_id_fk"
  add_foreign_key "event_vendors", "vendors", :name => "event_vendors_vendor_id_fk"

  add_foreign_key "events", "accounts", :name => "events_account_id_fk"
  add_foreign_key "events", "contacts", :name => "events_contact_id_fk"
  add_foreign_key "events", "event_transaction_methods", :name => "events_event_transaction_method_id_fk"
  add_foreign_key "events", "locations", :name => "events_location_id_fk"
  add_foreign_key "events", "users", :name => "events_created_by_id_fk", :column => "created_by_id"

  add_foreign_key "inventory_item_product_types", "inventory_items", :name => "inventory_item_product_types_inventory_item_id_fk"

  add_foreign_key "inventory_items", "vendors", :name => "inventory_items_vendor_id_fk"

  add_foreign_key "line_items", "documents", :name => "line_items_document_id_fk"
  add_foreign_key "line_items", "events", :name => "line_items_event_id_fk"
  add_foreign_key "line_items", "inventory_items", :name => "line_items_inventory_item_id_fk"

  add_foreign_key "locations", "accounts", :name => "locations_account_id_fk"
  add_foreign_key "locations", "buildings", :name => "locations_building_id_fk"
  add_foreign_key "locations", "contacts", :name => "locations_contact_id_fk"

  add_foreign_key "menu_level_discounts", "event_vendors", :name => "menu_level_discounts_event_vendor_id_fk"
  add_foreign_key "menu_level_discounts", "menu_templates", :name => "menu_level_discounts_menu_template_id_fk"

  add_foreign_key "menu_template_groups", "menu_templates", :name => "menu_template_groups_menu_template_id_fk"

  add_foreign_key "menu_template_inventory_items", "inventory_items", :name => "menu_template_inventory_items_inventory_item_id_fk"
  add_foreign_key "menu_template_inventory_items", "menu_template_groups", :name => "menu_template_inventory_items_menu_template_group_id_fk"
  add_foreign_key "menu_template_inventory_items", "menu_templates", :name => "menu_template_inventory_items_menu_template_id_fk"

  add_foreign_key "menu_templates", "vendors", :name => "menu_templates_vendor_id_fk"

  add_foreign_key "profiles", "users", :name => "profiles_user_id_fk"

  add_foreign_key "taggings", "tags", :name => "taggings_tag_id_fk"

  add_foreign_key "vendor_product_types", "vendors", :name => "vendor_product_types_vendor_id_fk"

  add_foreign_key "vendor_products", "vendors", :name => "vendor_products_vendor_id_fk"

  add_foreign_key "vendors", "addresses", :name => "vendors_address_id_fk"
  add_foreign_key "vendors", "users", :name => "vendors_vendor_manager_id_fk", :column => "vendor_manager_id"

end
