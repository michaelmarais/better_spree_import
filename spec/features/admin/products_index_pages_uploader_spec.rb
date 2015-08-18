require 'spec_helper'

describe "Products", type: :feature do
  let(:file_path) { Rails.root + "../../spec/support/test.csv" }
  stub_authorization!

  context "admin will see a linke to upload products" do 
    before do
      visit spree.admin_products_path
    end 

    it "allows user to import a product" do 
      expect(page).to have_content("Import")
    end

    it "successfully uploads all the products shit I want it too!" do 
      check "import-show-button"
      attach_file "product_import_csv_import", import.csv_import.path
      check "product_import_preferred_upload_products"
      click_button "Import"
      expect(page).to have_content("You have successfuly Imported products") 
    end
  end 
end 
