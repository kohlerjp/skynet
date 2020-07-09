defmodule Skynet.TerminatorServer do
  use GenServer

  # Client
  
  def start_link(state) do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def spawn_terminator() do
    GenServer.cast(__MODULE__, :spawn_terminator)
  end

  def kill_terminator(name) do
    GenServer.cast(__MODULE__, {:kill_terminator, name})
  end

  def get_terminators() do
    GenServer.call(__MODULE__, :get_terminators)
  end

  # Callbacks

  @impl true
  def init(_state) do
    schedule_list()
    {:ok, {%{}, 1000}}
  end

  @impl true
  def handle_call(:get_terminators, _from, {name_map, _counter} = state) do
    {:reply, Map.keys(name_map), state}
  end

  @impl true
  def handle_cast({:kill_terminator, name}, {name_map, counter}) do
    DynamicSupervisor.terminate_child(Skynet.DynamicSupervisor, Map.get(name_map, name)) # TODO: handle failure
    {:noreply, {Map.delete(name_map, name), counter}}
  end
  def handle_cast(:spawn_terminator, {name_map, counter}) do
    terminator_name = "T-#{counter}"
    {:ok, pid} = Skynet.DynamicSupervisor.new_terminator(terminator_name) # TODO: handle failure
    {:noreply, {Map.put(name_map, terminator_name, pid), counter + 1}}
  end

  @impl true
  def handle_info(:list, {name_map, _counter} = state) do
    IO.inspect("#{Enum.count(Map.keys(name_map))} Terminators: #{Map.keys(name_map)}")
    schedule_list()
    {:noreply, state}
  end

  def schedule_list() do # TODO: DELETE
    #Process.send_after(self(), :list, 10000)
  end
end
