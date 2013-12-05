ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    

    custs = []
    customers= Customer.all.each{|cust| custs << cust }

    columns do
      column do
        panel "Customers With Outstanding Orders" do
          ul do
            custs.map do |customer|
              li link_to("#{customer.first_name} #{customer.last_name}", admin_customer_path(customer)) do
                ul do
                  customer.orders.where("status LIKE 'New'").each do |order|
                    li link_to("Outstanding Order #{order.id}", admin_order_path(order))
                  end
                end
              end
            end
          end
        end
      end
    end

    #columns do
    #  column do
    #    panel "Recent Orders" do
    #      ul do
    #      Orders.recent(5).map do |order|
    #        li link_to(order, admin_post_path(order))
    #      end
    #    end
    #  end
    #end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
