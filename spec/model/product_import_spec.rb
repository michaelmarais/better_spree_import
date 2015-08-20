require 'spec_helper'

describe Spree::ProductImport do 
 let(:file_path) { Rails.root + "../../spec/fixtures/new_test.csv" }
 let(:globalize_path) { Rails.root + "../../spec/fixtures/globalize.xlsx" }
 let!(:shipping) {create(:shipping_category, name: "Shipping")}
 let!(:taxon) {create(:taxon, name: "The Taxon") }

 
 it { should have_attached_file(:csv_import) }

 describe '.add_product!' do 
   it 'successfully uploads Product data' do 
     product_import = create(:product_import,  csv_import: successfull_import, csv_import_file_name: "product.xls", csv_import_content_type: 'application/excel', preferences: {upload_products: true } )
     binding.pry
     product_import.add_products!
     expect(Spree::Product.count).to eq 1 
   end
 end 

 describe 'add_globalize_product!' do
   it 'successfully adds Transaltiosn to a Product' do 
     translated_product_import = create(:product_import, csv_import: successfull_globalize_import, csv_import_file_name: "data.xls", csv_import_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', preferences: { translate_products: true, upload_products: true })
     binding.pry
     translated_product_import.add_products!
     expect(Spree::Product.count).to eq 1 
   end

   context 'Update Product by finding slug' do 
     it "succesfullys updates a product based off the slug" do 
       product = create(:base_product, slug: 'product1')
       update_product = create(:product_import, csv_import: update_products, csv_import_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', preferences: { upload_products: true })
       update_product.add_products!
       product.reload
       expect(product.name).to eq('QuillingCard')
     end 
     
   end 
 end 

  describe "Add taxons to products" do 
    context "Admin can successfuly add taxons to a product" do 
      it "succesfullys adds a current product taxon" do 
         taxon = create(:taxon, name: "The Taxon") 
         product = create(:base_product, slug: 'product1')
         update_product = create(:product_import, csv_import: update_products, csv_import_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', preferences: { upload_products: true })
         update_product.add_products!
         product.reload
         expect(product.taxons.first.name).to eq "The Taxon"
       end 
     
       it "succesfullys adds a current product taxon if it does not already exist" do 
         product = create(:base_product, slug: 'product1')
         update_product = create(:product_import, csv_import: update_products, csv_import_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', preferences: { upload_products: true })
         update_product.add_products!
         product.reload
         expect(product.taxons).to include taxon
       end 

       it "It does add a taxon if it already exists in the product" do 
         product = create(:base_product, slug: 'product1', name: "product-1")
         product.taxons << taxon
         update_product = create(:product_import, csv_import: update_products, csv_import_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', preferences: { upload_products: true })
         update_product.add_products!
         product.reload
         expect(product.taxons.count).to eq 1
       end 
    end 
  end 
  
  describe "Add Option Types to products" do 
    let!(:property) {create(:property, name: "Type", presentation: "Type")}

    context "Admin can successfuly add properties to a product" do 
      it "succesfullys adds a current product property" do 
         product = create(:base_product, slug: 'product1')
         update_product = create(:product_import, csv_import: update_products, csv_import_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', preferences: { upload_products: true })
         update_product.add_products!
         product.reload
         expect(product.properties).to include property 
       end 
     
       it "succesfullys adds a current product property if it does not already exist" do 
         product = create(:base_product, slug: 'product1')
         update_product = create(:product_import, csv_import: update_products, csv_import_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', preferences: { upload_products: true })
         update_product.add_products!
         product.reload
         expect(product.product_properties.first.value).to eq "Card" 
       end 

       it "It does add a property if it already exists in the product" do 
         product = create(:base_product, slug: 'product1', name: "product-1")
         update_product = create(:product_import, csv_import: update_products, csv_import_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', preferences: { upload_products: true })
         update_product.add_products!
         product.reload
         expect(product.properties.count).to eq 1 
       end 
    end 
  end 

  describe "Add Option Types to products" do 
    let!(:option_type) {create(:option_type, name: "Size", presentation: "Size")}
    let!(:product_value) {create(:option_value)}

    context "Admin can successfuly add option_types to a product" do 
      it "succesfullys adds a current product option_type" do 
         product = create(:base_product, slug: 'product1')
         update_product = create(:product_import, csv_import: update_products, csv_import_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', preferences: { upload_products: true })
         update_product.add_products!
         product.reload
         expect(product.option_types).to include option_type
       end 
     
       it "succesfullys adds a current product option_type if it does not already exist" do 
         product = create(:base_product, slug: 'product1')
         update_product = create(:product_import, csv_import: update_products, csv_import_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', preferences: { upload_products: true })
         update_product.add_products!
         product.reload
         expect(product.option_types).to include option_type
       end 

       it "It does add a option_type if it already exists in the product" do 
         product = create(:base_product, slug: 'product1', name: "product-1")
         product.option_types << option_type
         update_product = create(:product_import, csv_import: update_products, csv_import_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', preferences: { upload_products: true })
         update_product.add_products!
         product.reload
         expect(product.option_types.count).to eq 1
       end 
    end 
  end 

 describe 'add_globalize_product!' do 
   it 'successfully adds Transaltiosn to a Product' do 
     variant_import = create(:product_import, csv_import: successfull_variant_import , csv_import_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', preferences: { upload_products: true})
     product = create(:base_product, slug: 'test-product')
     variant_import.add_variants!
     expect(Spree::Variant.count).to eq 2 
   end

   context "update variants" do 
    it "updates a variant that has already been added" do 
       new_variant = create(:base_variant, sku: "SKU-20")
       variant_update = create(:product_import, csv_import: update_variants_import , csv_import_content_type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', preferences: {upload_variants: true })
       variant_update.add_variants!
       new_variant.stock_items.each do |stock_item|
         expect(stock_item.count_on_hand).to eq 5
       end
     end 
   end
 end 
end 
