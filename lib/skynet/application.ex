defmodule Skynet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SkynetWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Skynet.PubSub},
      # Start the Endpoint (http/https)
      SkynetWeb.Endpoint,
      # Start a worker by calling: Skynet.Worker.start_link(arg)
      # {Skynet.Worker, arg},
      Skynet.DynamicSupervisor,
      {Skynet.TerminatorServer, name: Skynet.TerminatorServer}, 
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Skynet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SkynetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
