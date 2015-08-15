require 'ffaker'

FactoryGirl.define do
  factory :product_import, class: Spree::ProductImport do
    csv_import_file_name "product_import.csv" 
  end 
end
