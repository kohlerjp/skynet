defmodule Skynet.DynamicSupervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def kill_terminator(nil) do
    {:error, :not_found}
  end
  def kill_terminator(pid) do
    DynamicSupervisor.terminate_child(Skynet.DynamicSupervisor, pid)
  end

  def new_terminator(name) do
    child = %{id: String.to_atom(name), start: {Skynet.Terminator, :start_link, [name]}} 
    DynamicSupervisor.start_child(Skynet.DynamicSupervisor, child)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
