# frozen_string_literal: true

require 'azurerm_resource'

class AzurermPostgreSqlServer < AzurermSingularResource
  name 'azurerm_postgresql_server'
  desc 'Verifies settings for an Azure PostgreSQL Server'
  example <<-EXAMPLE
    describe azure_postgresql_server(resource_group: 'rg-1', server_name: 'my-server-name') do
      it { should exist }
    end
  EXAMPLE

  ATTRS = %i(
    id
    name
    kind
    location
    type
    tags
    properties
  ).freeze

  attr_reader(*ATTRS)

  def initialize(resource_group: nil, server_name: nil)
    postgresql_server = management.postgresql_server(resource_group, server_name)
    return if has_error?(postgresql_server)

    assign_fields(ATTRS, postgresql_server)

    @resource_group = resource_group
    @server_name = server_name
    @exists = true
  end

  def configuration(parameter: nil)
    management.postgresql_server_configuration(@resource_group,@server_name,parameter)
  end

  def to_s
    "Azure PostgreSQL Server: '#{name}'"
  end
end
