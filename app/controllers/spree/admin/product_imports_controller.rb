module Spree
  module  Admin
    class ProductImportsController < Spree::Admin::BaseController
      def create
        @product_import = Spree::ProductImport.create(csv_import_params)
        if @product_import.save
          @product_import.add_products!

          flash[:success] = "You have successfuly Imported products" 
          redirect_to admin_products_path
        else 
          flash[:error] =  "There was an error validating your file please check it"
          redirect_to admin_products_path
        end 
      end


    private 

      def csv_import_params
        params.require(:product_import).permit(:csv_import, :preferred_upload_products, :preferred_upload_variants, :preferred_translate_products, :preferred_update_variants, :preferred_update_products)
      end 
    end 
  end 
end 
