require "spec_helper"

describe Spree::Admin::ProductImportsController, type: :controller do
  stub_authorization!
  let!(:product_import) { build(:product_import, csv_import: successfull_import, csv_import_content_type: 'text/csv')}

  describe "POST #create" do
    it "redirects to the home page" do
      spree_post :create, product_import: { csv_import: product_import }
      expect(flash[:success]).to match(/You have successfuly Imported products/i)
    end
  end


end
