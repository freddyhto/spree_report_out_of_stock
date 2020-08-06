module ProductsOutStock
  module Spree
    module ProductsOutStockControllerDecorator

      def initialize
        super
        ::Spree::Admin::ReportsController.add_available_report!(:products_out_stock, :description)
      end

      def self.prepended(base)
        base.before_action :fix_filter_params, only: :products_out_stock
      end

      def products_out_stock
        @inventorys = []
        @search = ::Spree::StockMovement.includes(stock_item: [variant: [:product]] ).ransack(params[:q])
        @search.result.group_by(&:stock_item_id).each do |item_id, movements|
          total = 0
          movements.each do |movement|
            total += movement.quantity
            @inventorys << { date: movement.created_at, product: movement.stock_item.variant.product } if total == 0
          end
        end
      end

      private
      def fix_filter_params
        params[:q] ||= {}
        params[:q][:created_at_gt] = 
          params[:q][:created_at_gt].present? ?
          Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day : Time.zone.now.beginning_of_day

        params[:q][:created_at_lt] =
          params[:q][:created_at_lt].present? ?
          Time.zone.parse(params[:q][:created_at_lt]).end_of_day : ''
      end

    end
  end
end

Spree::Admin::ReportsController.prepend ProductsOutStock::Spree::ProductsOutStockControllerDecorator