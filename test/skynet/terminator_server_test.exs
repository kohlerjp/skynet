defmodule Skynet.TerminatorServerTest do
  use ExUnit.Case, async: true

  setup do
    server = start_supervised!({Skynet.TerminatorServer, name: :server_test})
    %{server: server}
  end

  test "spawn_terminator", %{server: server} do
    assert GenServer.call(server, :spawn_terminator) == ["T-1000"]
    assert GenServer.call(server, :spawn_terminator) == ["T-1000", "T-1001"]
    assert GenServer.call(server, :spawn_terminator) == ["T-1000", "T-1001", "T-1002"]
  end

  test "kill_terminator", %{server: server} do
    assert GenServer.call(server, :spawn_terminator) == ["T-1000"]
    assert GenServer.call(server, :spawn_terminator) == ["T-1000", "T-1001"]

    assert GenServer.call(server, {:kill_terminator, "T-1001"}) == ["T-1000"]
    assert GenServer.call(server, {:kill_terminator, "T-1000"}) == []
  end

  test "killing non existent terminator", %{server: server} do
    assert GenServer.call(server, :spawn_terminator) == ["T-1000"]
    assert GenServer.call(server, {:kill_terminator, "999"}) == ["T-1000"] # does not alter state
  end

  test "get_terminators", %{server: server} do
    assert GenServer.call(server, :spawn_terminator) == ["T-1000"]
    assert GenServer.call(server, :spawn_terminator) == ["T-1000", "T-1001"]
    assert GenServer.call(server, :get_terminators) == ["T-1000", "T-1001"]

    assert GenServer.call(server, {:kill_terminator, "T-1001"}) == ["T-1000"]
    assert GenServer.call(server, :get_terminators) == ["T-1000"]
  end
end
