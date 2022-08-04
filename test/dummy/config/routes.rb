Rails.application.routes.draw do
  mount ResourceQuotable::Engine => "/resource_quotable"
end
