require 'spec_helper'

describe "Products", type: :feature do
  let(:file_path) { Rails.root + "../../spec/fixtures/new_test.csv" }
  let(:globalize_path) { Rails.root + "../../spec/fixtures/globalize.xlsx" }
  let(:youxi_path) { Rails.root + "../../spec/fixtures/Ekokami.xlsx" }
  let!(:shipping) {create(:shipping_category, name: "Shipping")}
  let!(:taxonomy) {create(:taxonomy, name: "Designers")}
  let!(:taxon) {create(:taxon, name: "Youxi")}
  stub_authorization!


  context "admin will see a linke to upload products" do 
    before do
      visit spree.admin_products_path
    end 

    it "allows user to import a product" do 
      expect(page).to have_content("Import")
    end

    it "successfully uploads all the products in the csv file" do 
      check "import-show-button"
      attach_file "product_import_csv_import", globalize_path
      check "product_import_preferred_add_products"
      click_button "Import"
      expect(Spree::Product.count).to eq (2)
    end

    it "successfully uploads product translations" do 
      check "import-show-button"
      attach_file "product_import_csv_import", youxi_path
      check "product_import_preferred_add_products"
      click_button "Import"
      expect(page).to have_content("You have successfuly Imported products") 
      expect(Spree::Product.count).to eq 5 
      expect(Spree::Product.first.taxons).to include taxon
      expect(Spree::Product.first.properties.count).to eq 1 
      expect(Spree::Product.first.price.to_i).to eq 15 
    end
  end 
end 
