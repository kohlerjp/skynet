defmodule Skynet.NameRegistry do
  use Agent

  #Name registry is a tuple of a name lookup table, and a current name counter
  #   def start_link(_inital) do
  #     Agent.start_link(fn -> {%{}, %{}, 1000} end, name: __MODULE__)
  #   end
  # 
  #   def register_process(pid) do
  #     name = Agent.get_and_update(__MODULE__, fn {name_to_pid, pid_to_name, counter} -> {counter, 
  #                                 {Map.put(name_to_pid, "T-#{counter}", pid), Map.put(pid_to_name, pid, "T-#{counter}"), counter + 1}} end)
  #     "T-#{name}"
  #   end
  # 
  #   def remove_process(pid) do
  #     name = lookup_name(pid)
  #     Agent.update(__MODULE__, fn {name_to_pid, pid_to_name, counter} -> {Map.delete(name_to_pid, name), Map.delete(pid_to_name, pid), counter} end)
  #   end
  # 
  #   def lookup_pid(name) do
  #     Agent.get(__MODULE__, fn {name_to_pid, _pid_to_name, _counter} -> Map.get(name_to_pid, name) end)
  #   end
  # 
  #   def lookup_name(pid) do
  #     Agent.get(__MODULE__, fn {_name_to_pid, pid_to_name, _counter} -> Map.get(pid_to_name, pid) end)
  #   end
  # 
  #   def print_pids() do
  #     Agent.get(__MODULE__, fn {_name_to_pid, pid_to_name, _counter} -> pid_to_name end)
  #   end
  # 
  #   def print_names() do
  #     Agent.get(__MODULE__, fn {name_to_pid, _pid_to_name, _counter} -> name_to_pid end)
  #   end
  # 
  #   def dead_pids() do
  #     pids = Agent.get(__MODULE__, fn {_name_to_pid, pid_to_name, _counter} -> Map.keys(pid_to_name) end)
  #     Map.new(pids, fn pid -> {pid, !Process.alive?(pid) } end)
  #   end

  def start_link(_inital) do
    Agent.start_link(fn -> 1000 end, name: __MODULE__)
  end

  def new_id() do
    Agent.get_and_update(__MODULE__, fn count -> {String.to_atom("T-#{count}"), count + 1} end)
  end
end
