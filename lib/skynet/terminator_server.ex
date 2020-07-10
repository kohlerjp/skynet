defmodule Skynet.TerminatorServer do
  use GenServer

  # Client
  
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, [name: opts[:name]])
  end

  def spawn_terminator() do
    GenServer.call(__MODULE__, :spawn_terminator)
  end

  def kill_terminator(name) do
    GenServer.call(__MODULE__, {:kill_terminator, name})
  end

  def get_terminators() do
    GenServer.call(__MODULE__, :get_terminators)
  end

  # Callbacks

  @impl true
  # State is a tuple of a mapping from terminator name to process ID,
  # and a counter. The counter is used to create unique names for spawned terminators
  def init(_state) do
    {:ok, {%{}, 1000}}
  end

  @impl true
  def handle_call(:get_terminators, _from, {name_map, _counter} = state) do
    {:reply, Map.keys(name_map), state}
  end
  def handle_call({:kill_terminator, name}, _from, {name_map, counter}) do
    terminator_name = Map.get(name_map, name)
    updated_map = case Skynet.DynamicSupervisor.kill_terminator(terminator_name) do
      :ok -> Map.delete(name_map, name)
      {:error, _reason} -> name_map
    end

    {:reply, Map.keys(updated_map), {updated_map, counter}}
  end
  def handle_call(:spawn_terminator, _from, {name_map, counter}) do
    terminator_name = "T-#{counter}"
    {:ok, pid} = Skynet.DynamicSupervisor.new_terminator(terminator_name)
    updated_map = Map.put(name_map, terminator_name, pid)
    {:reply, Map.keys(updated_map), {updated_map, counter + 1}}
  end
end
