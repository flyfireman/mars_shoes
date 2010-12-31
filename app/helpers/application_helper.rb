# Methods added to this helper will be available to all templates in the application.
#hooopo的解决方案-->http://www.javaeye.com/topic/469505

module ApplicationHelper
  def error_div(model, field, field_name)
    return unless model
    field = field.is_a?(Symbol) ? field.to_s : field
    errors = model.errors[field]
    return unless errors
    %Q(
    <div class="errors">
    #{errors.is_a?(Array) ? errors.map{|e| field_name + e}.join(",") : field_name << errors}
    </div>
    )
  end
end

