Spree::Admin::OrdersController.class_eval do
  def export_csv
    @search = Spree::Order.accessible_by(current_ability, :export_csv).ransack(params[:q])
    @orders = @search.result(distinct: true)

    respond_to do |format|
      format.html
      format.xlsx
    end
  end
end
