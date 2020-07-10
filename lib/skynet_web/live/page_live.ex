defmodule SkynetWeb.PageLive do
  use SkynetWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 1000)
    {:ok, assign(socket, terminators: Skynet.TerminatorServer.get_terminators())}
  end

  @impl true
  def handle_event("spawn", _value, socket) do
    {:noreply, assign(socket, terminators: Skynet.TerminatorServer.spawn_terminator())}
  end
  def handle_event("kill_terminator", %{"name" => terminator_name}, socket) do
    {:noreply, assign(socket, terminators: Skynet.TerminatorServer.kill_terminator(terminator_name))}
  end

  @impl true
  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 1000)
    {:noreply, assign(socket, :terminators, Skynet.TerminatorServer.get_terminators())}
  end
end
