ActiveAdmin.register Order do
	Order.includes(:customer).where("status LIKE 'New'")
end
