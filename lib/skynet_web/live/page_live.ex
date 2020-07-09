defmodule SkynetWeb.PageLive do
  use SkynetWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 30000)
    terminators = Skynet.TerminatorServer.get_terminators()
    {:ok, assign(socket, terminators: terminators)}
  end

  @impl true
  def handle_event("spawn", %{"q" => query}, socket) do
  end

  @impl true
  def handle_event("kill", %{"q" => query}, socket) do
  end

  def handle_info(:update, socket) do
    #Process.send_after(self(), :update, 1000)
    terminators = Skynet.TerminatorServer.get_terminators()
    {:noreply, assign(socket, :terminators, terminators)}
  end


end
