defmodule Skynet.Terminator do
  use GenServer

  # Client
  
  def start_link(name) do
    GenServer.start_link(__MODULE__, name)
  end

  # Callbacks

  @impl true
  def init(name) do
    schedule_connor()
    schedule_replication()
    {:ok, name}
  end

  @impl true
  def handle_info(:replicate, name) do
    perform_replication(:rand.uniform(10))
    schedule_replication()
    {:noreply, name}
  end
  def handle_info(:connor, name) do
    perform_connor(name, :rand.uniform(100)) 
    schedule_connor()
    {:noreply, name}
  end

  def schedule_connor() do
    Process.send_after(self(), :connor, 10000)
  end

  def schedule_replication() do
    Process.send_after(self(), :replicate, 5000)
  end

  def perform_connor(name, chance) do
    if chance <= 25 do
      Skynet.TerminatorServer.kill_terminator(name)
    end
  end

  def perform_replication(chance) do
    if chance <= 2 do
      Skynet.TerminatorServer.spawn_terminator()
    end
  end
end
