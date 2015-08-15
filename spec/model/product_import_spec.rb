require 'spec_helper'

describe Spree::ProductImport do 
 let!(:product_import) { create(:product_import, csv_import: successfull_import, csv_import_content_type: 'text/csv')}
 let!(:translated_product_import) { create(:product_import, csv_import: successfull_globalize_import, csv_import_content_type: 'text/csv', preferences: { translate_products: true })}

 let!(:variant_import) { create(:product_import, csv_import: successfull_variant_import , csv_import_content_type: 'text/csv')}

 let!(:shipping) {create(:shipping_category, name: "Shipping")}
 let!(:option_type) {create(:option_type, name: "Graphic") }
 let!(:taxon) {create(:taxon, name: "The Taxon") }

 
 it { should have_attached_file(:csv_import) }

 describe '.add_product!' do 
   it 'successfully uploads Product data' do 
     product_import.add_products!
     expect(Spree::Product.count).to eq 1 
   end
 end 

 describe 'add_globalize_product!' do 
   it 'successfully adds Transaltiosn to a Product' do 
     translated_product_import.add_products!
     expect(Spree::Product.count).to eq 1 
   end
 end 

 describe 'add_globalize_product!' do 
   it 'successfully adds Transaltiosn to a Product' do 
     product = create(:base_product, slug: 'test-product')
     variant_import.add_variants!
     expect(Spree::Variant.count).to eq 2 
   end
 end 
end 
