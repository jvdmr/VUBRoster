Uurrooster::Application.routes.draw do

  get "sync" => "Courses#sync"
  match "robots.txt" => "Students#robots"
  match "view/lecture/:id" => "Lectures#show", :as => :lecture
  match "view/remove_custom_lecture/:nr(/:id)" => "Lectures#remove", :as => :remove_custom_lecture
  match "view/add_custom_lecture/:nr" => "Lectures#add", :as => :add_custom_lecture
  match "view/profs/:id" => "Profs#show", :as => :prof
  match "view/course/:id" => "Courses#show", :as => :course
  match "view/courses" => "Courses#list", :as => :courses_list
  match "view/students" => "Students#list", :as => :index
  match "view/(:id)/edit" => "Students#edit", :as => :edit
  match "view/(:id)/save" => "Students#save", :as => :save
	match "view/:id/edit_custom_course(/:courseid)" => "Courses#edit", :as => :edit_custom_course
	match "view/:id/save_custom_course(/:courseid)" => "Courses#save", :as => :save_custom_course
	match "view/:id/remove_custom_course/:course" => "Students#remove_custom_course", :as => :remove_custom_course
	match "view/:id/add/:course" => "Students#add_course", :as => :add_course
	match "view/:id/remove/:course" => "Students#remove_course", :as => :remove_course
  match "view/:id/now" => "Students#now"
  match "view/:id/today" => "Students#day"
  match "view/:id/day/:day" => "Students#day"
  match "view/:id/:week/:day" => "Students#day"
  match "view/:id/:week" => "Students#show", :as => :show_week
	match "view/:id" => "Students#show", :as => :show
	match ":id" => "Students#show"
  match "ical/:id" => "Students#ical", :as => :ical

  root :to => "Students#list"

  # See how all your routes lay out with "rake routes"
end
