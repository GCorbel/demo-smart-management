module ApplicationHelper
  def rest_manager_row(column)
    filter = " | date: 'dd-MM-yyyy hh:mm:ss'" if column.sql_type == 'datetime'
    "{{row.resource.#{column.name} #{filter} }}"
  end

  def visible_columns
    model_class.columns.map(&:name)
  end

  def editable_columns
    model_class.columns.map(&:name) - ['id', 'created_at', 'updated_at']
  end

  def singular_model_name
    controller_name.to_s.singularize
  end

  def plural_model_name
    controller_name.to_s
  end

  def model_class
    singular_model_name.capitalize.constantize
  end

  def colspan
    model_class.columns.length + 2
  end
end
