module Refinery
  module Pages
    module Admin
      class PreviewController < Refinery::PagesController
        include ::Refinery::ApplicationController
        helper ApplicationHelper
        helper Refinery::Core::Engine.helpers
        include Refinery::Admin::BaseController
        include Pages::RenderOptions

        skip_before_filter :error_404, :set_canonical

        layout :layout

        def show
          render_with_templates?
        end

        protected
        def admin?
          false
        end

        def find_page
          if @page = Refinery::Page.find_by_path_or_id(params[:path], params[:id])
            # Preview existing pages
            @page.attributes = page_params
          elsif params[:page]
            # Preview a non-persisted page
            @page = Page.new page_params
          end
        end
        alias_method :page, :find_page

        def layout
          'application'
        end

        def page_params
          params.require(:page).permit(
            :browser_title, :draft, :link_url, :menu_title, :meta_description,
            :parent_id, :skip_to_first_child, :show_in_menu, :title, :view_template,
            :layout_template, parts_attributes: [:id, :title, :body, :position]
          )
        end
      end
    end
  end
end
