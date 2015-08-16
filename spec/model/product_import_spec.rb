require 'spec_helper'

describe Spree::ProductImport do 

 let!(:shipping) {create(:shipping_category, name: "Shipping")}
 let!(:option_type) {create(:option_type, name: "Graphic") }
 let!(:taxon) {create(:taxon, name: "The Taxon") }

 
 it { should have_attached_file(:csv_import) }

 describe '.add_product!' do 
   it 'successfully uploads Product data' do 
     product_import = create(:product_import, csv_import: successfull_import, csv_import_content_type: 'text/csv')
     product_import.add_products!
     expect(Spree::Product.count).to eq 1 
   end
 end 

 describe 'add_globalize_product!' do
   it 'successfully adds Transaltiosn to a Product' do 
     translated_product_import = create(:product_import, csv_import: successfull_globalize_import, csv_import_content_type: 'text/csv', preferences: { translate_products: true })
     translated_product_import.add_products!
     expect(Spree::Product.count).to eq 1 
   end
 end 

 describe 'add_globalize_product!' do 
   it 'successfully adds Transaltiosn to a Product' do 
     variant_import = create(:product_import, csv_import: successfull_variant_import , csv_import_content_type: 'text/csv')
     product = create(:base_product, slug: 'test-product')
     variant_import.add_variants!
     expect(Spree::Variant.count).to eq 2 
   end

   #context 'missing fields in translations' do 
     #variant_import = create(:product_import, csv_import: successfull_missing_globalize_fields , csv_import_content_type: 'text/csv')
     #translated_product_import.add_products!
     #expect(Spree::Product.count).to eq 1 
   #end

   context "update variants" do 
    it "updates a variant that has already been added" do 
       new_variant = create(:base_variant, sku: "SKU-2")
       variant_update = create(:product_import, csv_import: update_variants_import , csv_import_content_type: 'text/csv', preferences: {update_variants: true })
       variant_update.add_variants!
       expect(new_variant.stock_items_count).to eq 6
     end 
   end
 end 
end 
