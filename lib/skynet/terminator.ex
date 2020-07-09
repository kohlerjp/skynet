defmodule Skynet.Terminator do
  use GenServer

  # Client
  
  def start_link(name) do
    IO.inspect "STARTING TERMINATOR WITH NAME: #{name}"
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
    perform_replication(name)
    schedule_replication()
    {:noreply, name}
  end
  def handle_info(:connor, name) do
    perform_connor(name) 
    schedule_connor()
    {:noreply, name}
  end


  def schedule_connor() do
    Process.send_after(self(), :connor, 5000)
  end

  def schedule_replication() do
    Process.send_after(self(), :replicate, 2000)
  end

  def perform_connor(name) do
    chance = :rand.uniform(100)
    if chance <= 25 do
      IO.inspect("#{name} KILLED")
      Skynet.TerminatorServer.kill_terminator(name)
    end
  end

  def perform_replication(name) do
    chance = :rand.uniform(10)
    if chance <= 2 do
      IO.inspect("#{name} REPLICATING")
      Skynet.TerminatorServer.spawn_terminator()
    end
  end
end
