# frozen_string_literal: true

class Avo::Views::ResourceShowComponent < Avo::ResourceComponent
  include Avo::ResourcesHelper
  include Avo::ApplicationHelper

  attr_reader :fields_by_panel, :has_one_panels, :has_many_panels, :has_as_belongs_to_many_panels

  def initialize(resource: nil, reflection: nil, parent_model: nil, resource_panel: nil, actions: [])
    @resource = resource
    @reflection = reflection
    @resource_panel = resource_panel
    @actions = actions

    split_panel_fields
  end

  def title
    if @reflection.present?
      reflection_resource.name
    else
      @resource.panels.first[:name]
    end
  end

  def back_path
    if via_resource?
      helpers.resource_path(model: params[:via_resource_class].safe_constantize, resource: relation_resource, resource_id: params[:via_resource_id])
    else
      helpers.resources_path(resource: @resource)
    end
  end

  def edit_path
    args = {}

    if via_resource?
      args = {
        via_resource_class: params[:via_resource_class],
        via_resource_id: params[:via_resource_id]
      }
    end

    helpers.edit_resource_path(model: @resource.model, resource: @resource, **args)
  end

  private

  # In development and test environments we shoudl show the invalid field errors
  def should_display_invalid_fields_errors?
    (Rails.env.development? || Rails.env.test?) && @resource.invalid_fields.present?
  end
end
