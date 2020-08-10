module ProductsOutStock
  module Spree
    module ReportsControllerDecorator

      def initialize
        super
        ::Spree::Admin::ReportsController.add_available_report!(:products_out_stock, :description)
      end

      def self.prepended(base)
        base.before_action :fix_filter_params, only: :products_out_stock
      end

      def products_out_stock
        @inventorys = []
        @search = ::Spree::StockMovement.includes(stock_item: [:stock_location, variant: [:product]] ).ransack(params[:q])
        ::Spree::StockItem.only_deleted.where(deleted_filter_query, {
          deleted_at_gteq: params[:q][:created_at_gteq], deleted_at_lt: params[:q][:created_at_lt]
        }).each do |deleted_stock_item|
          @inventorys << {
            date: deleted_stock_item.deleted_at,
            product: deleted_stock_item.variant.product,
            location: deleted_stock_item.stock_location
          }
        end
        @search.result.group_by(&:stock_item_id).each do |item_id, movements|
          total = 0
          movements.each do |movement|
            total += movement.quantity
            if total == 0 && movement.stock_item
              @inventorys << {
                date: movement.created_at,
                product: movement.stock_item.variant.product,
                location: movement.stock_item.stock_location
              }
            end
          end
        end
      end

      private
      def fix_filter_params
        params[:q] ||= {}
        params[:q][:created_at_gteq] =
          params[:q][:created_at_gteq].present? ?
          Time.zone.parse(params[:q][:created_at_gteq]).beginning_of_day : Time.zone.now.beginning_of_day

        params[:q][:created_at_lt] =
          params[:q][:created_at_lt].present? ?
          Time.zone.parse(params[:q][:created_at_lt]).end_of_day : ''
      end

      def deleted_filter_query
        query = []
        query << 'deleted_at >= :deleted_at_gteq' if params[:q][:created_at_gteq].present?
        query << 'deleted_at <= :deleted_at_lt' if params[:q][:created_at_lt].present?
        query.join(' AND ')
      end

    end
  end
end

Spree::Admin::ReportsController.prepend ProductsOutStock::Spree::ReportsControllerDecorator