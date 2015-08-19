module Spree
  module  Admin
    class ProductImportsController < Spree::Admin::BaseController
      def create
        @product_import = Spree::ProductImport.create(csv_import_params)
        if @product_import.save
          import_variants_or_products
          flash[:success] = "You have successfuly imported Products."
        else
          flash[:error] = @product_import.errors.map {|key,val| val.humanize}.flatten.uniq.join(' ')
        end
        redirect_to admin_products_path
      end

      private

        def csv_import_params
          params.require(:product_import).permit(:csv_import, :preferred_upload_products, :preferred_upload_variants, :preferred_translate_products)
        end

        def import_variants_or_products
          if @product_import.preferred_upload_products
            @product_import.add_products!
          elsif @product_import.preferred_upload_variants
            @product_import.add_products!
          end
        end
    end
  end
end
