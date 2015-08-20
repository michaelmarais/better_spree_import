require 'spec_helper'

describe "Products", type: :feature do
  let(:file_path) { Rails.root + "../../spec/fixtures/new_test.csv" }
  let(:globalize_path) { Rails.root + "../../spec/fixtures/globalize.xlsx" }
  let!(:shipping) {create(:shipping_category, name: "Shipping")}
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
      click_button "Import"
    end

    it "successfully uploads product translations" do 
      check "import-show-button"
      attach_file "product_import_csv_import", globalize_path
      click_button "Import"
      expect(page).to have_content("You have successfuly Imported products") 
      expect(Spree::Product.count).to eq 1 
    end
  end 
end 
