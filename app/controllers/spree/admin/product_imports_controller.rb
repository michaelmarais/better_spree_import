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
          flash[:error] =  @product_import.errors 
          redirect_to admin_products_path
        end 
      end


    private 

      def csv_import_params
        params.fetch(:product_import, {}).permit(:csv_import, :preferred_translate_products)
      end 
    end 
  end 
end 
