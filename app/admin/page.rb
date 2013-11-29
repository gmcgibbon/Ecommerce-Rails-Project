ActiveAdmin.register Page do
	form do |f|
      f.inputs "Title" do
        f.input :title
      end
      f.inputs "Content" do
      	f.input :content, :as => :ckeditor, :input_html => { :ckeditor => { :height => 400 } }
      end
      f.actions
    end
end
