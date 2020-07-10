defmodule Skynet.TerminatorTest do
  use ExUnit.Case, async: true

  setup do
    :sys.replace_state(Skynet.TerminatorServer, fn _state -> {%{}, 1000} end)  
    :ok
  end

  test "performing replication succeeds" do
    Skynet.Terminator.perform_replication(2)
    assert Skynet.TerminatorServer.get_terminators() == ["T-1000"]
  end

  test "performing replication fails" do
    Skynet.Terminator.perform_replication(4)
    assert Skynet.TerminatorServer.get_terminators() == []
  end

  test "killing process succeeds" do
    Skynet.TerminatorServer.spawn_terminator()
    {%{"T-1000" => terminator_pid}, _count} = :sys.get_state(Skynet.TerminatorServer)  
    assert Process.alive?(terminator_pid)

    Skynet.Terminator.perform_connor("T-1000", 10)
    assert !Process.alive?(terminator_pid)
  end

  test "killing process fails" do
    Skynet.TerminatorServer.spawn_terminator()
    {%{"T-1000" => terminator_pid}, _count} = :sys.get_state(Skynet.TerminatorServer)  
    assert Process.alive?(terminator_pid)

    Skynet.Terminator.perform_connor("T-1000", 90)
    assert Process.alive?(terminator_pid)
  end
end
